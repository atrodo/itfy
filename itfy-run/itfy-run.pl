#!/usr/bin/perl 
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../perl5/lib/perl5";
use lib "$FindBin::Bin/../lib";
use local::lib "$FindBin::Bin/../perl5";
use lib "$FindBin::Bin/../../tool_bench/lib/";

use autodie qw/:all/;
use itfy::Schema::ItfyDB;
require Tool::Bench;

my $schema = itfy::Schema::ItfyDB->connect("dbi:SQLite:dbname=$FindBin::Bin/../itfy.sqlite");

my $root = "/home/atrodo/parrot/parrot";
my $machine = $schema->resultset("Machine")->find({name => "ipfy"});
my $project = $schema->resultset("Project")->find({name => "Parrot"});

foreach my $rev (@ARGV)
{
  chdir $root;

  warn "Building...\n";
  system("bash build-it.sh $rev 1>/dev/null 2>/dev/null");

  my $git_log = qx/git log $rev -1 --format=%H:%ct:%cD/;
  chomp $git_log;

  my ($rev_hash, $rev_stamp, $rev_date) = split m/:/, $git_log, 3;

  my $git_describe = qx/git describe $rev --tags/;
  chomp $git_describe;

  warn "Running commands...\n";
  foreach my $cmd ($project->bench_cmds->all)
  {
    warn "  T::B-ing " . $cmd->name . "...\n";
    my $bench= Tool::Bench->new;
    my $exec = join ' ', $cmd->interp, $cmd->cmd, $cmd->args;
    $bench->add_items( $cmd->name => sub{qx{$exec}});
    $bench->run($cmd->count);
    my $json = $bench->report(
      format => "JSON",
      interp => $cmd->interp,
    );

    $cmd->add_result_json({
      revision => $rev_hash,
      revision_aka => $git_describe,
      revision_date => $rev_date,
      revision_stamp => $rev_stamp,
      machine => $machine,
      json => $json,
    });
  }

}
