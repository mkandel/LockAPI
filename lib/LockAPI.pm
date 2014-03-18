package LockAPI;
use Mojo::Base 'Mojolicious';
use Carp;

use lib "$FindBin::Bin/../lib/";
use LockAPI::Config;

our $VERSION = '0.01';

# This method will run once at server start
sub startup {
    my $self = shift;

    my $conf = LockAPI::Config->new();
    my $api_vers = $conf->api_version() || 'v1';

    ## Shutup supid secret warning ...
    ## Old style, pre-5.18?
    #$self->secret('My very secret motherfucking passphrase.');
    ## New style ...
    $self->secrets(['My very secret motherfucking passphrase.']);

    # Router
    my $r = $self->routes;

    # Normal route to controller
    #$r->get('/')->to('example#welcome');

    ## API v1 routes
    ## PUT
    foreach my $action ( qw{ add delete modify } ){
        $r->put("/$api_vers/$action/:service/:product/#host/:user/#app/"  )->to("action-$action#$action" );
    }

    ## GET
    foreach my $action ( qw{ list check } ){
#                 $r->get('/v1/list/:service/:product/#host/:user/#app')->to(
        $r->get("/$api_vers/$action/:service/:product/#host/:user/#app"   )->to( "action-list#list" );
        #$r->get("/$api_vers/$action/:service/:product/#host/:user/#app"   )->to( "action-$action#$action" );
    }


#    $r->put("/$api_vers/add/"   )->to( 'action-add#add' );

    ## Delete
#    $r->put("/$api_vers/delete/")->to('action-delete#delete');

    ## List
#    $r->get("/$api_vers/list/"  )->to('action-list#list'    );
    
    ## Check
#    $r->get("/$api_vers/check/" )->to('action-check#check'  );

    ## Modify
#    $r->put("/$api_vers/modify/")->to('action-modify#modify');

    ## Default
    $r->get('/v1/' )->to(
        cb  => sub {
            my $self = shift;
            $self->render( text => 'Available actions:<BR> GET:<BR> list check<BR> PUT:<BR> add delete modify');
        }
    );
}

1;
__END__

=encoding utf-8

=head1 NAME

LockAPI - Blah blah blah

=head1 SYNOPSIS

  use LockAPI;

=head1 DESCRIPTION

LockAPI is

=head1 AUTHOR

Marc Kandel E<lt>marc.kandel.cpan@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2014- Marc Kandel

=head1 LICENSE

This code is released as Apathyware:

"The code doesn't care what you do with it, and neither do I."

=head1 SEE ALSO

=cut
