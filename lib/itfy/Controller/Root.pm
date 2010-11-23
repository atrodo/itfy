package itfy::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

itfy::Controller::Root - Root Controller for itfy

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    # Hello World
    #$c->response->body( $c->welcome_message );
    my $machine = $c->model("ItfyDB::Machine")->find({name => "ipfy"});
    my $project = $c->model("ItfyDB::Project")->find({name => "Parrot"});
    my $cmd_rs = $project->bench_cmds;

    $c->stash->{machine}  = $machine;
    $c->stash->{project}  = $project;
    $c->stash->{cmd_rs}   = $cmd_rs;
    $c->stash->{template} = 'index.tt2';
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Catalyst developer

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
