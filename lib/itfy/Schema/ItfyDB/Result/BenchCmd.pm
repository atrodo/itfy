package itfy::Schema::ItfyDB::Result::BenchCmd;

use strict;
use warnings;

use base 'DBIx::Class::Core';

use JSON::Any;

__PACKAGE__->load_components("UUIDColumns", "Core");

=head1 NAME

itfy::Schema::ItfyDB::Result::BenchCmd

=cut

__PACKAGE__->table("bench_cmd");

__PACKAGE__->add_columns(
  "bench_cmd_id",
  { data_type => "varchar", is_nullable => 0, size => 36 },
  "project_id",
  { data_type => "varchar", is_nullable => 0, size => 36 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 32 },
  "desc",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "cmd",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "count",
  { data_type => "int unsigned", is_nullable => 0 },
  "shown",
  { data_type => "boolean", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("bench_cmd_id");
__PACKAGE__->uuid_columns("bench_cmd_id");

__PACKAGE__->add_unique_constraint([ qw/project_id name/ ]);

__PACKAGE__->has_many('bench_results' => 'itfy::Schema::ItfyDB::Result::BenchResult', "bench_cmd_id");

__PACKAGE__->belongs_to('project' => 'itfy::Schema::ItfyDB::Result::Project', "project_id");

sub add_result_json
{
  my $self = shift;
  my $args = shift;

  my $json = JSON::Any->jsonToObj($args->{json});

  if (ref $json eq "ARRAY")
  {
    foreach my $timing (@$json)
    {
      $self->add_result_json({ %$args, json => JSON::Any->objToJson($timing)});
    }
    return;
  }

  my $result = $self->create_related("bench_results",
  {
    max_time => $json->{max_time},
    avg_time => $json->{avg_time},
    min_time => $json->{min_time},
    submit_stamp => time,
    total_time => $json->{total_time},
    total_runs => $json->{total_runs},
    revision => $args->{revision},
    revision_aka => $args->{revision_aka},
    revision_date => $args->{revision_date},
    revision_stamp => $args->{revision_stamp},
    machine => $args->{machine},
  });

  $result->create_related("bench_result_json", {
    json => $args->{json},
  });
}

1;
