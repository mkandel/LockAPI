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

    my $config = LockAPI::Config->new();
    #my $config = LockAPI::Config->new({ debug => 1 });
    my $api_vers = $config->api_version() || 'v1';

    $self->app->log->new( path => $config->log_dir() || "/tmp/lockapi_server.log" );

    ## We can change the DB type by changing this logic to config based:
    my $db = LockAPI::DB::Sqlite->new();

    $self->attr( 'db' );
    $self->attr( 'config' );
    $self->attr( 'debug' );
    $self->db( $db );
    $self->config( $config );
    $self->debug( $config->debug() || 0 );

    ## Shutup supid secret warning ...
    ## Old style, pre-5.18?
    #$self->secret('My very secret motherfucking passphrase.');
    ## New style ...
    $self->secrets(['fdshgfjgjfdkgjebjdhsaajfsadgjhfgakjdgfjagdsfnbdsfagdfjag']);

    # Router
    my $r = $self->routes;

    ## API v1 routes
    ## PUT
    ## add:
    $r->any("/$api_vers/add/:resource/:service/:product/#host/:user/#caller"  )->to("action-add#add" );
    $r->any("/$api_vers/add/:resource/:service/:product/#host/:user/#caller/:expires" )->to("action-add#add" );
    $r->any("/$api_vers/add/:resource/:service/:product/#host/:user/#caller/:expires/(*extra)" )
        ->to("action-add#add" );
    $r->any("/$api_vers/add/:resource/:service/:product/#host/:user/#caller/(*extra)" )->to("action-add#add" );

    ## ping links
    $r->get("/$api_vers/ping"             )->to( "action-ping#ping" );
    $r->get("/ping"             )->to( "action-ping#ping" );
    
    ## list all link
    $r->get("/$api_vers/list"             )->to( "action-list#list" );
    ## Count the locks
    $r->get("/$api_vers/list/count"       )->to( "action-list#count" );
    ## list all link
    $r->get("/$api_vers/list/:filter"     )->to( "action-list#list_filtered" );
    ## list all link
    $r->get("/$api_vers/list/:filter/count"     )->to( "action-list#count_filtered" );
    
    ## Check by lock_id
    $r->get("/$api_vers/check/:lock_id"   )->to( "action-check#check" );
    ## Check by fingerprint
    $r->get("/$api_vers/check/:resource/:service/:product/#host/:user/#caller" )->to( "action-check#check_fprint" );
    
    ## Delete by lock_id
    $r->get("/$api_vers/delete/:lock_id"  )->to( "action-delete#delete" );

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

LockAPI - REST based centralized locking service

=head1 SYNOPSIS

  use LockAPI;

=head1 DESCRIPTION

LockAPI is

=head1 AUTHOR

Marc Kandel E<lt>marc.kandel.cpan@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2014 - 2015 Marc Kandel

=head1 SEE ALSO

=cut

