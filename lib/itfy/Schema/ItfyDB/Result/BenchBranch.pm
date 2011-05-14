package itfy::Schema::ItfyDB::Result::BenchBranch;

use strict;
use warnings;

use base 'DBIx::Class::Core';

use JSON::Any;

__PACKAGE__->load_components("UUIDColumns", "Core");

=head1 NAME

itfy::Schema::ItfyDB::Result::BenchBranch

=cut

__PACKAGE__->table("bench_branch");

=head1 ACCESSORS

=head2 bench_branch_id

  data_type: 'varchar'
  is_nullable: 0
  size: 36

=head2 project_id

  data_type: 'varchar'
  is_nullable: 0
  size: 36

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 32

=cut

__PACKAGE__->add_columns(
  "bench_branch_id",
  { data_type => "varchar", is_nullable => 0, size => 36 },
  "project_id",
  { data_type => "varchar", is_nullable => 0, size => 36 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 32 },
);
__PACKAGE__->set_primary_key("bench_branch_id");
__PACKAGE__->uuid_columns("bench_branch_id");

__PACKAGE__->belongs_to('project' => 'itfy::Schema::ItfyDB::Result::Project', "project_id");

1;
