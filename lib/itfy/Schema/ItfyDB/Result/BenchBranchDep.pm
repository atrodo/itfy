package itfy::Schema::ItfyDB::Result::BenchBranchDep;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("UUIDColumns", "Core");

=head1 NAME

itfy::Schema::ItfyDB::Result::BenchBranchDep

=cut

__PACKAGE__->table("bench_branch_dep");

__PACKAGE__->add_columns(
  "bench_branch_id",
  { data_type => "varchar", is_nullable => 0, size => 36 },
  "dep_bench_branch_id",
  { data_type => "varchar", is_nullable => 0, size => 36 },
);
__PACKAGE__->set_primary_key("bench_branch_id", "dep_bench_branch_id");

__PACKAGE__->belongs_to('bench_branch' => 'itfy::Schema::ItfyDB::Result::BenchBranch', "bench_branch_id");
__PACKAGE__->belongs_to('dep_bench_branch' => 'itfy::Schema::ItfyDB::Result::BenchBranch', { "foreign.bench_branch_id" => "self.dep_bench_branch_id"});

1;
