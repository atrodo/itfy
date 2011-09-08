package itfy::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

itfy::Controller::Root - Root Controller for itfy

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    my $machine = $c->model("ItfyDB::Machine")->find({name => "atrodo.org"});
    my $project = $c->model("ItfyDB::Project")->find({name => "Parrot"});
    my $cmd_rs = $c->model("ItfyDB::BenchCmd");
    my $branch_rs = $project->bench_branch;

    my $branches = [];

    my $results_by_cmd = {};

    while (my $branch = $branch_rs->next)
    {
      my $revs = [];
      my $rev_rs = $branch->revs->search({
          "bench_run.success" => 'true',
          "bench_run.machine_id" => $machine->machine_id,
        }, {
          prefetch => [{bench_run => "bench_results"}, {"children" => {bench_run => "bench_results"}} ],
          #'+select' => [{max => 'submit_stamp', '-as' => 'max_submit_stamp'}],
          #group_by => [qw/me.bench_branch_rev_id/],
          #having => {submit_stamp => \"= max_submit_stamp"},
      });

      $rev_rs->result_class('DBIx::Class::ResultClass::HashRefInflator');

      #push @$branches, {
      #  name => $branch->name,
      #  revs => $rev_rs,
      #};
      #die Data::Dumper::Dumper($rev_rs->all);

      my $extract;
      $extract = sub
      {
        my $rev = shift;
        foreach my $child (@{ $rev->{children} })
        {
          $extract->($child);
        }

        my $newest_submit = 0;

        foreach my $run (@{ $rev->{bench_run} })
        {
          next
            if $newest_submit > $run->{submit_stamp};

          $newest_submit = $run->{submit_stamp};

          foreach my $result (@{ $run->{bench_results} })
          {
            push @{ $results_by_cmd->{$result->{bench_cmd_id}}}, {
              %$result,
              submit_stamp => $run->{submit_stamp},
              revision => $rev->{revision},
              revision_aka => $rev->{revision_aka},
              revision_stamp => $rev->{revision_stamp},
              revision_date => $rev->{revision_date},
            };
          }
        }
      };

      while (my $rev = $rev_rs->next)
      {
        $extract->($rev);
      }
    }

    # qw/bench_branch_rev_id bench_run bench_cmd_id
    $c->stash->{results_by_cmd} = $results_by_cmd;
    $c->stash->{machine}  = $machine;
    $c->stash->{project}  = $project;
    $c->stash->{cmd_rs}   = $cmd_rs;
    $c->stash->{branches} = $branches;
    $c->stash->{template} = 'index.tt2';
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Catalyst developer

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
