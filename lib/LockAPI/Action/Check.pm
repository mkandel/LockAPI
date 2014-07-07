package LockAPI::Action::Check;
use Mojo::Base 'Mojolicious::Controller';
use Carp;
use Data::Dumper;

use FindBin;
use lib "$FindBin::Bin/../../../lib/";
use LockAPI::DB::Sqlite;

sub check {
    my $self = shift;

    my $conf = {
        debug      => 1,
        lock_id    => $self->stash()->{ 'lock_id' } || -1,
    };

    my $text = '';
    if ( $conf->{ 'debug' } ){
        $text .= "Stash:<BR><PRE>";
        $text .= Dumper $self->stash();
        $text .= "</PRE>";

#        $self->render( text => "Stash:<BR><PRE>$text</PRE>" );
    }

    my $db = LockAPI::DB::Sqlite->new();

    my $ret->{'status'} = 200;

    eval{
        $ret = $db->check( $conf );
    };

    if ( $conf->{ 'debug' } ){
        $text .= "Returning:<BR><PRE>";
        $text .= Dumper $ret;
        $text .= "</PRE>";

        $self->app->log->debug("$text");
    }
    $self->render( text => "$text", status => $ret->{'status'} );
}

1;

__END__

