package LockAPI;
use Mojo::Base 'Mojolicious';
use Carp;
use Data::Dumper;

use lib "$FindBin::Bin/../lib/";
use LockAPI::Config;
use LockAPI::DB::Sqlite;

our $VERSION = '0.01';

# This method will run once at server start
sub startup {
    my $self = shift;

    my $conf = LockAPI::Config->new();
    my $api_vers = $conf->api_version() || 'v1';

    ## We can change the DB type by changing this logic to config based:
    my $db = LockAPI::DB::Sqlite->new();

    $self->stash( 'db' => $db );

    ## Shutup supid secret warning ...
    ## Old style, pre-5.18?
    #$self->secret('My very secret motherfucking passphrase.');
    ## New style ...
    $self->secrets(['My very secret motherfucking passphrase.']);

    # Router
    my $r = $self->routes;

    ## API v1 routes
    ## PUT
    ## add:
    $r->any("/$api_vers/add/:service/:product/#host/:user/#caller"  )->to("action-add#add" );
    #$r->any("/$api_vers/add/:service/:product/#host/:user/#caller/:expires", expires => qr/\d+/ )->to("action-add#add" );
    $r->any("/$api_vers/add/:service/:product/#host/:user/#caller/:expires" )->to("action-add#add" );
    $r->any("/$api_vers/add/:service/:product/#host/:user/#caller/:expires/(*extra)" )
        ->to("action-add#add" );
    $r->any("/$api_vers/add/:service/:product/#host/:user/#caller/(*extra)" )->to("action-add#add" );

=pod

    foreach my $action ( qw{ add delete modify } ){
        ## These need to be PUT but for testing in a browser ... need to use ANY ...
        #$r->put("/$api_vers/$action/:service/:product/#host/:user/#caller/(:expires)", expires => qr/\d+/  )->to("action-$action#$action" );
        $r->any("/$api_vers/$action/:service/:product/#host/:user/#caller/(:expires)", expires => qr/\d+/  )->to("action-$action#$action" );
        #$r->put("/$api_vers/$action/:service/:product/#host/:user/#caller/(:expires)/(*extra"), expires => qr/\d+/  )->to("action-$action#$action" );
        $r->any("/$api_vers/$action/:service/:product/#host/:user/#caller/(:expires)/(*extra)", expires => qr/\d+/  )->to("action-$action#$action" );
        #$r->put("/$api_vers/$action/:service/:product/#host/:user/#caller/(*extra)"  )->to("action-$action#$action" );
        $r->any("/$api_vers/$action/:service/:product/#host/:user/#caller/(*extra)"  )->to("action-$action#$action" );
        #$r->put("/$api_vers/$action/:service/:product/#host/:user/#caller"  )->to("action-$action#$action" );
        $r->any("/$api_vers/$action/:service/:product/#host/:user/#caller"  )->to("action-$action#$action" );
    }

=cut

    ## GET
    foreach my $action ( qw{ list check } ){
        $r->get("/$api_vers/$action/:service/:product/#host/:user/#caller"   )->to( "action-$action#$action" );
    }

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

=head1 SEE ALSO

=cut

