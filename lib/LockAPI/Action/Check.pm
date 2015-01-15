package LockAPI::Action::Check;
use Mojo::Base 'Mojolicious::Controller';
use Carp;
use Data::Dumper;
local $Data::Dumper::Useqq  = 1;
local $Data::Dumper::Indent = 2;
use Data::Dumper::HTML qw(dumper_html);

use FindBin;
use lib "$FindBin::Bin/../../../lib/";
use LockAPI::DB::Sqlite;
use LockAPI::Utils qw{ fingerprint };

sub check {
    my $self = shift;

    my $conf = {
        debug      => 1,
        lock_id    => $self->stash()->{ 'lock_id' } || -1,
    };

    my $ret;
    my $val;
    $ret->{'status'} = 200;

    my $text = '';

    my $db = LockAPI::DB::Sqlite->new();

    ## if lock_id == -1 we're checking by fingerprint, otherwise by id:
    if ( $conf->{'lock_id'} == -1 ){
        ## check by fingerprint
        my $fp = fingerprint( );
        $self->app->log->debug( "** FP: '$fp' **" );

        $val = $db->check_fingerprint( $self->stash() );
    } elsif ( $conf->{'lock_id'} ){
        ## Check by ID
        $val = $db->check_id( $conf->{'lock_id'} )->[0];
    } else {
        $ret->{'status'} = 598;
        $text = "Invalid lock_id: '$conf->{'lock_id'}' - Unrecoverable, bailing, sorry!";
    }

    if ( $val == 0 ){
        $text = 'FREE';
    } elsif ( $val == 1 ){
        $ret->{'status'} = 597;
        $text = 'LOCKED';
    } else {
        $text = "Something very weird happened, we got more results from the DB than we should have ...\nSelf:\n";
        $text .= dumper_html( $self );
        $text .= "\nRet:\n";
        $text .= dumper_html( $ret );
    }

    $self->render( text => "$text", status => $ret->{'status'} );
}

1;

__END__

