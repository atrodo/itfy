package itfy::Schema::ItfyDB::Result::BenchCmd;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("UUIDColumns", "Core");

=head1 NAME

itfy::Schema::ItfyDB::Result::BenchCmd

=cut

__PACKAGE__->table("bench_cmd");

=head1 ACCESSORS

=head2 bench_cmd_id

  data_type: 'varchar'
  is_nullable: 0
  size: 36

=head2 project_id

  data_type: 'varchar'
  is_nullable: 0
  size: 36

=head2 interp

  data_type: 'varchar'
  is_nullable: 0
  size: 32

=head2 cmd

  data_type: 'varchar'
  is_nullable: 0
  size: 32

=head2 args

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 count

  data_type: 'int unsigned'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "bench_cmd_id",
  { data_type => "varchar", is_nullable => 0, size => 36 },
  "project_id",
  { data_type => "varchar", is_nullable => 0, size => 36 },
  "interp",
  { data_type => "varchar", is_nullable => 0, size => 32 },
  "cmd",
  { data_type => "varchar", is_nullable => 0, size => 32 },
  "args",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "count",
  { data_type => "int unsigned", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("bench_cmd_id");
__PACKAGE__->uuid_columns("bench_cmd_id");

1;
