package itfy::Schema::ItfyDB::Result::Machine;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("UUIDColumns", "Core");

=head1 NAME

itfy::Schema::ItfyDB::Result::Machine

=cut

__PACKAGE__->table("machine");

__PACKAGE__->add_columns(
  "machine_id",
  { data_type => "varchar", is_nullable => 0, size => 36 },
  "api_key",
  { data_type => "varchar", is_nullable => 0, size => 36 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 32 },
  "phys_mem",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "os",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "cpu",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "cpu_speed",
  { data_type => "varchar", is_nullable => 0, size => 255 },
);
__PACKAGE__->set_primary_key("machine_id");
__PACKAGE__->uuid_columns("machine_id");
__PACKAGE__->add_unique_constraint([ qw/name/ ]);
__PACKAGE__->add_unique_constraint([ qw/api_key/ ]);

__PACKAGE__->has_many('bench_runs' => 'itfy::Schema::ItfyDB::Result::BenchRun', "machine_id");

1;
