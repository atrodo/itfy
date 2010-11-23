package itfy::Schema::ItfyDB::Result::BenchResultJson;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("UUIDColumns", "Core");

=head1 NAME

itfy::Schema::ItfyDB::Result::BenchResultJson

=cut

__PACKAGE__->table("bench_result_json");

=head1 ACCESSORS

=head2 bench_result_id

  data_type: 'varchar'
  is_nullable: 0
  size: 36

=head2 json

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "bench_result_id",
  { data_type => "varchar", is_nullable => 0, size => 36 },
  "json",
  { data_type => "text", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("bench_result_id");
__PACKAGE__->uuid_columns("bench_result_id");

__PACKAGE__->belongs_to('bench_result' => 'itfy::Schema::ItfyDB::Result::BenchResult', "bench_result_id");

1;
