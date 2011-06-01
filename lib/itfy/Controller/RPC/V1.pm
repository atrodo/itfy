package itfy::Controller::RPC::V1;
use Moose;
use namespace::autoclean;
use JSON::Any;
use autodie qw/:all/;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

itfy::Controller::RPC::V1 - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 default

=cut

sub default : Path : Args
{
  my $self    = shift;
  my $c       = shift;
  my $api_key = shift;

  my $machine = $c->model('ItfyDB::Machine')->find( { api_key => $api_key } );
  if ( !defined $machine )
  {
    $c->response->status(401);
    $c->response->body(
      JSON::Any->objToJson( { error => "API Key is incorrect" } ) );
    $c->response->content_type("application/json");
    $c->detach();
  }

  $c->stash->{machine} = $machine;
  $c->stash->{rpcout}  = {};

  $c->forward( join "/", @_ );

  $c->response->body( JSON::Any->objToJson( $c->stash->{rpcout} ) );
  $c->response->content_type("application/json");
}

=head2 RPC methods

=cut

sub revhash
{
  my $rev  = shift;
  my $proj = $rev->bench_branch->project;

  my @children;
  my $children_rs = $rev->children;
  while ( my $child = $children_rs->next )
  {
    push @children, revhash($child);
  }

  my @cmds;
  my $cmd_rs = $proj->bench_cmds;
  while ( my $cmd = $cmd_rs->next )
  {
    push @cmds,
        {
      cmd    => $cmd->cmd,
      cmd_id => $cmd->bench_cmd_id,
      name   => $cmd->name,
      count  => $cmd->count,
        };
  }

  return {
    project  => $proj->name,
    git_name => $proj->git_name,
    url      => $proj->url,
    rev_id   => $rev->bench_branch_rev_id,
    rev      => $rev->revision,
    cmds     => [@cmds],
    children => [@children],
  };
}

sub todo : Private
{
  my $self = shift;
  my $c    = shift;

  # Find all the missing revisions
  my $done_rev_rs = $c->stash->{machine}->bench_runs->search(
    {},
    {
      select   => 'bench_branch_rev_id',
      distinct => 1,
    }
  );
  my $rev_rs = $c->model('ItfyDB::BenchBranchRev')->search(
    {
      'me.bench_branch_rev_id' => { '-not_in' => $done_rev_rs->as_query },
      'me.parent_bench_branch_rev_id' => undef,
    },
    {
      order_by => "me.revision_stamp desc",

      #prefetch => [qw/children/],
    }
  )->slice( 0, 5 );

  #$rev_rs->result_class('DBIx::Class::ResultClass::HashRefInflator');

  # If they are missing any of the last 5 revisions, send the newest.
  # Otherwise, send a random old revision

  my @result;
  while ( my $rev = $rev_rs->next )
  {
    push @result, revhash($rev);
  }
  $c->stash->{rpcout}->{list} = [@result];
  $c->log->debug( Data::Dumper::Dumper( $c->stash->{rpcout}->{list} ) );
}

use Data::Dumper;

sub get_rev_bydate
{
  my $c        = shift;
  my $git_name = shift;
  my $date     = shift;

  local $ENV{GIT_DIR} = $c->config->{meta_repo_root} . "/$git_name/.git";

  system("git fetch");

  my $rev
      = qx#git log --first-parent --before="$date" --format=%H origin/master | head -1#;
  chomp $rev;

  return get_rev( $c, $git_name, $rev );
}

sub get_rev
{
  my $c        = shift;
  my $git_name = shift;
  my $rev      = shift;

  local $ENV{GIT_DIR} = $c->config->{meta_repo_root} . "/$git_name/.git";

  my $git_log = qx/git log $rev -1 --format=%H:%ct:%cD/;
  if ( !defined $git_log )
  {
    system("git fetch");
    my $git_log = qx/git log $rev -1 --format=%H:%ct:%cD/;
  }

  # Find the aka, date and stamp
  chomp $git_log;

  my ( $rev_hash, $rev_stamp, $rev_date ) = split m/:/, $git_log, 3;
  my $git_describe = qx/git describe $rev --tags/;
  chomp $git_describe;

  return (
    revision       => $rev_hash,
    revision_aka   => $git_describe,
    revision_date  => $rev_date,
    revision_stamp => $rev_stamp,
  );

}

sub add_branch_rev : Private
{
  my $self = shift;
  my $c    = shift;

  my $rpcin = JSON::Any->jsonToObj( $c->request->params->{payload} || "{}" );

  # Find the project
  my $project = $c->model('ItfyDB::Project')->find(
    {
      name => { like => $rpcin->{repository}->{name} },
    }
  );
  die "Cannot find project: " . $rpcin->{repository}->{name}
      unless defined $project;

  my $git_name = $project->git_name;

  # Find the branch
  my $branch_name = $rpcin->{ref};
  $branch_name =~ s[refs/heads/][]xms;
  my $branch = $project->bench_branch->find(
    {
      name => $branch_name,
    }
  );

  # Find the final, pushed revision
  my $rev = $rpcin->{after};

  # Save the revision
  eval {
    my $new_rev = $branch->create_related(
      "revs",
      {
        get_rev( $c, $git_name, $rev ),
      }
    );

    my $dep_rs = $new_rev->bench_branch->dependencies;
    while ( my $dep = $dep_rs->next )
    {
      $dep = $dep->dep_bench_branch;
      $new_rev->create_related(
        "children",
        {
          bench_branch_id => $dep->bench_branch_id,

          #parent_bench_branch_id => $new_rev->bench_branch_id,
          get_rev_bydate(
            $c, $dep->project->git_name, $new_rev->revision_date
          ),
        }
      );
    }
  };
}

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
