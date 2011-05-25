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
);
__PACKAGE__->set_primary_key("bench_run_id");
__PACKAGE__->uuid_columns("bench_run_id");

__PACKAGE__->belongs_to('machine' => 'itfy::Schema::ItfyDB::Result::Machine', "machine_id");

__PACKAGE__->belongs_to('bench_branch_rev' => 'itfy::Schema::ItfyDB::Result::BenchBranchRev', "bench_branch_rev_id");

1;
