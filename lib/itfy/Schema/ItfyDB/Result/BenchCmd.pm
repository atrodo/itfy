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

1;
