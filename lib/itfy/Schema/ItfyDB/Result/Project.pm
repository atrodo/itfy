package itfy::Schema::ItfyDB::Result::Project;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("UUIDColumns", "Core");

=head1 NAME

itfy::Schema::ItfyDB::Result::BenchCmd

=cut

__PACKAGE__->table("project");

__PACKAGE__->add_columns(
  "project_id",
  { data_type => "varchar", is_nullable => 0, size => 36 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 32 },
  "url",
  { data_type => "varchar", is_nullable => 0, size => 255 },
);
__PACKAGE__->set_primary_key("project_id");
__PACKAGE__->uuid_columns("project_id");
__PACKAGE__->add_unique_constraint([ qw/name/ ]);

__PACKAGE__->has_many('bench_cmds' => 'itfy::Schema::ItfyDB::Result::BenchCmd', "project_id");
__PACKAGE__->has_many('bench_branch' => 'itfy::Schema::ItfyDB::Result::BenchBranch', "project_id");

sub git_name
{
  my $self = shift;
  my $url = $self->url;

  $url =~ s[^ .* / (\w*) [.] git $ ][$1]xms;
  return $url;
}

1;
