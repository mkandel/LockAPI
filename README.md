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

# NAME

LockAPI - REST based centralized locking service

# SYNOPSIS

    use LockAPI;

# DESCRIPTION

LockAPI is

# AUTHOR

Marc Kandel <marc.kandel.cpan@gmail.com>

# COPYRIGHT

Copyright 2014- Marc Kandel

# SEE ALSO
