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

    foreach my $branch_name (@{$project_c->{branch}})
    {
      my $bench_branch_rs = $schema->resultset("BenchBranch");
      my $branch = $bench_branch_rs->update_or_create({
        project_id => $project->project_id,
        name => $branch_name,
      });
    }
  }
}

1;
