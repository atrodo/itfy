package itfy;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;
use Try::Tiny;
use LWP::Simple;

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    ConfigLoader
    Static::Simple
/;

extends 'Catalyst';

our $VERSION = '0.01';
$VERSION = eval $VERSION;

# Configure the application.
#
# Note that settings in itfy.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
  name => 'itfy',
  # Disable deprecated behavior needed by old applications
  disable_component_resolution_regex_fallback => 1,

  default_view => "TT",
  'View::JSON' =>
  {
    expose_stash => 'rpc',
    allow_callback => 0,
  },
  'View::TT' =>
  {
      CATALYST_VAR => 'Catalyst',
      INCLUDE_PATH => [
          __PACKAGE__->path_to( 'root', 'src' ),
      ],
      #WRAPPER      => 'site/wrapper.tt2',
      TEMPLATE_EXTENSION  => '.tt2',
      EVAL_PERL   => 1,
  },
);

# Start the application
__PACKAGE__->setup();

# Load up remote config now

sub load_meta_config
{
  my $c = shift;

  $DB::single = 1;
  use JSON;

  $c->log->debug("Loading meta_config\n");

  try
  {
    warn $c->config->{meta_json};
    my $browser = LWP::UserAgent->new;
    my $response = $browser->get( $c->config->{meta_json} );
    die "Can't get it -- ", $response->status_line
       unless $response->is_success;

    my $json_raw = $response->decoded_content;

    my $conv = JSON->new->relaxed->allow_barekey;
    my $json = $conv->decode($json_raw);

    $c->model("ItfyDB")->schema->import_config($json);
  } catch {
    warn $_;
  };
}

__PACKAGE__->load_meta_config();

=head1 NAME

itfy - Catalyst based application

=head1 SYNOPSIS

    script/itfy_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<itfy::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Catalyst developer

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
