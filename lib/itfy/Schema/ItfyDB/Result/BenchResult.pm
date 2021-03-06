package itfy::Schema::ItfyDB::Result::BenchResult;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("UUIDColumns", "Core");

=head1 NAME

itfy::Schema::ItfyDB::Result::BenchResult

=cut

__PACKAGE__->table("bench_result");

__PACKAGE__->add_columns(
  "bench_result_id",
  { data_type => "varchar", is_nullable => 0, size => 36 },
  "bench_run_id",
  { data_type => "varchar", is_nullable => 0, size => 36 },
  "bench_cmd_id",
  { data_type => "varchar", is_nullable => 0, size => 36 },
  "max_time",
  { data_type => "float", is_nullable => 0 },
  "avg_time",
  { data_type => "float", is_nullable => 0 },
  "min_time",
  { data_type => "float", is_nullable => 0 },
  "total_time",
  { data_type => "float", is_nullable => 0 },
  "total_runs",
  { data_type => "int unsigned", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("bench_result_id");
__PACKAGE__->uuid_columns("bench_result_id");

__PACKAGE__->has_one('bench_result_json' => 'itfy::Schema::ItfyDB::Result::BenchResultJson', "bench_result_id");

__PACKAGE__->belongs_to('bench_run' => 'itfy::Schema::ItfyDB::Result::BenchRun', "bench_run_id");
__PACKAGE__->belongs_to('bench_cmd' => 'itfy::Schema::ItfyDB::Result::BenchCmd', "bench_cmd_id");

1;
