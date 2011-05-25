#!/usr/bin/perl 
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../perl5/lib/perl5";
use lib "$FindBin::Bin/../lib";
use local::lib "$FindBin::Bin/../perl5";
use lib "$FindBin::Bin/../../tool_bench/lib/";

use autodie qw/:all/;
use File::Temp;
use JSON::Any;
use LWP::UserAgent;

require Tool::Bench;

# Build projects at revisions
# Run each bench_cmd

# Load Config
my $config = do "$FindBin::Bin/config.pl";

my $root = "$FindBin::Bin";

# Loop (possibly) forever
while (1)
{

  # Connect to website w/key to download tasks
  my $browser  = LWP::UserAgent->new;
  my $host     = $config->{host};
  my $key      = $config->{api_key};
  my $response = $browser->get("$host/rpc/v1/$key/todo");

  die "Can't get it -- ", $response->status_line
      unless $response->is_success;

  my $json_raw = $response->decoded_content;

  my $json = JSON::Any->jsonToObj($json_raw);

  foreach my $todo ( @{ $json->{list} } )
  {
    my $tempdir     = File::Temp->newdir();
    my $install_dir = $tempdir->dirname;

    local $ENV{PATH} = "$install_dir/bin:$ENV{PATH}";
    warn $ENV{PATH};

    my $rev;

    my $build_it = sub
    {
      my $project = shift;
      chdir $config->{build_root};

      if ( !-d $project->{git_name} )
      {
        system( "git clone " . $project->{url} . " " . $project->{git_name} );
      }

      chdir $project->{git_name};

      # Checkout
      system("git fetch");
      system("git clean -xfd");
      system( "git checkout -f " . $project->{rev} );

      # Build

      if ( -r "Configure.pl" )
      {
        system("perl Configure.pl --prefix=$install_dir");
        system("make");
        system("make install");
      }
      else
      {
        die "Could not build " . $project->{project} . "\n";
      }

    };

    $build_it->($todo);
    foreach my $child ( @{ $todo->{children} } )
    {
      $build_it->($child);
    }

  }

  # Remember what I said about a forever loop?  I lied.
  last;
}
