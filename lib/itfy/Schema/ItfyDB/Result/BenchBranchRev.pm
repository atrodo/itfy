package itfy::Schema::ItfyDB::Result::BenchBranchRev;

use strict;
use warnings;

use base 'DBIx::Class::Core';

use JSON::Any;

__PACKAGE__->load_components("UUIDColumns", "Core");

=head1 NAME

itfy::Schema::ItfyDB::Result::BenchRun

=cut

__PACKAGE__->table("bench_branch_rev");

__PACKAGE__->add_columns(
  "bench_branch_rev_id",
  { data_type => "varchar", is_nullable => 0, size => 36 },
  "bench_branch_id",
  { data_type => "varchar", is_nullable => 0, size => 36 },
  "parent_bench_branch_rev_id",
  { data_type => "varchar", is_nullable => 1, size => 36 },
  "revision",
  { data_type => "varchar", is_nullable => 0, size => 40 },
  "revision_aka",
  { data_type => "varchar", is_nullable => 0, size => 40 },
  "revision_date",
  { data_type => "datetime", is_nullable => 0, },
  "revision_stamp",
  { data_type => "int unsigned", is_nullable => 0, },
);

__PACKAGE__->set_primary_key("bench_branch_rev_id");
__PACKAGE__->uuid_columns("bench_branch_rev_id");
__PACKAGE__->add_unique_constraint([ qw/bench_branch_id revision/ ]);

__PACKAGE__->belongs_to('bench_branch' => 'itfy::Schema::ItfyDB::Result::BenchBranch', "bench_branch_id");

__PACKAGE__->belongs_to('parent' => 'itfy::Schema::ItfyDB::Result::BenchBranchRev', {"foreign.bench_branch_id" => "self.parent_bench_branch_rev_id"});

__PACKAGE__->has_many('children' => 'itfy::Schema::ItfyDB::Result::BenchBranchRev', {"foreign.parent_bench_branch_rev_id" => "self.bench_branch_rev_id"});

1;
