package itfy::Schema::ItfyDB;

use strict;
use warnings;

use base qw/DBIx::Class::Schema/;

__PACKAGE__->load_namespaces;

sub import_config
{
  my $schema = shift;
  my $config = shift;

  foreach my $project_c (@{$config->{project}})
  {
    my $project_rs = $schema->resultset("Project");
    my $project = $project_rs->update_or_create({
      name => $project_c->{name},
      url => $project_c->{url},
    });

    foreach my $bench_cmd_c (@{$project_c->{bench_cmd}})
    {
      my $bench_cmd_rs = $schema->resultset("BenchCmd");
      my %values = map {$_ => $bench_cmd_c->{$_} } qw/name desc cmd count shown/;
      $values{project_id} = $project->project_id;

      my $bench_cmd = $bench_cmd_rs->update_or_create(%values);
    }

    foreach my $branch_c (@{$project_c->{branch}})
    {
      my $bench_branch_rs = $schema->resultset("BenchBranch");
      my $branch = $bench_branch_rs->update_or_create({
        project_id => $project->project_id,
        name => $branch_c->{name},
        ref  => $branch_c->{ref},
      });
    }
  }

  # Handle any project dependencies
  foreach my $project_c (@{$config->{project}})
  {
    foreach my $branch_c (@{$project_c->{branch}})
    {
      if (exists $branch_c->{dependencies})
      {
        my $project = $schema->resultset("Project")->find({
          name => $project_c->{name},
        });
        my $branch = $schema->resultset("BenchBranch")->find({
          project_id => $project->project_id,
          name => $branch_c->{name},
        });
        foreach my $dep (@{ $branch_c->{dependencies} })
        {
          my ($dep_project_name, $dep_branch_name) = split /:/, $dep;
          my $project_dep = $schema->resultset("Project")->find({
            name => $dep_project_name,
          });
          my $branch_dep = $schema->resultset("BenchBranch")->find({
            project_id => $project_dep->project_id,
            name => $dep_branch_name,
          });
          $schema->resultset("BenchBranchDep")->find_or_create({
            bench_branch_id => $branch->bench_branch_id,
            dep_bench_branch_id => $branch_dep->bench_branch_id,
          });
        }
      }
    }
  }
}

1;
