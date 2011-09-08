package itfy::Schema::ItfyDB::Result::BenchRun;

use strict;
use warnings;

use base 'DBIx::Class::Core';

use JSON::Any;

__PACKAGE__->load_components("UUIDColumns", "Core");

=head1 NAME

itfy::Schema::ItfyDB::Result::BenchRun

=cut

__PACKAGE__->table("bench_run");

__PACKAGE__->add_columns(
  "bench_run_id",
  { data_type => "varchar", is_nullable => 0, size => 36 },
  "machine_id",
  { data_type => "varchar", is_nullable => 0, size => 36 },
  "bench_branch_rev_id",
  { data_type => "varchar", is_nullable => 0, size => 36 },
  "submit_stamp",
  { data_type => "int unsigned", is_nullable => 0, },
  "success",
  { data_type => "boolean", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("bench_run_id");
__PACKAGE__->uuid_columns("bench_run_id");

__PACKAGE__->belongs_to('machine' => 'itfy::Schema::ItfyDB::Result::Machine', "machine_id");

__PACKAGE__->belongs_to('bench_branch_rev' => 'itfy::Schema::ItfyDB::Result::BenchBranchRev', "bench_branch_rev_id");

__PACKAGE__->has_many('bench_results' => 'itfy::Schema::ItfyDB::Result::BenchResult', "bench_run_id");

sub add_result_json
{
  my $self = shift;
  my $cmd_id = shift;
  my $json_raw = shift;

  warn $cmd_id;
  warn $json_raw;
  my $json = JSON::Any->jsonToObj($json_raw);

  if (ref $json eq "ARRAY")
  {
    foreach my $timing (@$json)
    {
      $self->add_result_json($cmd_id, JSON::Any->objToJson($timing));
    }
    return;
  }

  my $result = $self->create_related("bench_results",
  {
    bench_cmd_id => $cmd_id,
    max_time => $json->{max_time},
    avg_time => $json->{avg_time},
    min_time => $json->{min_time},
    total_time => $json->{total_time},
    total_runs => $json->{total_runs},
  });

  $result->create_related("bench_result_json", {
    json => $json_raw,
  });
}

1;
