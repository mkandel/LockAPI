package LockAPI::Action::Add;
use Mojo::Base 'Mojolicious::Controller';
use Carp;
use JSON::XS;
use URI::Escape;
use Data::Dumper;

use FindBin;
use lib "$FindBin::Bin/../../../lib/";
use LockAPI::DB::Sqlite;

sub add {
    my $self = shift;

    my $created = time;

    my $db = $self->app->db();

    my $conf = {
        'debug'      => 1,
#        'dryrun'     => 1,
    };

#    my $status = 200; ## Assume OK until something borks ...
#    my $ret->{'status'} = $status; ## Not sure what I was thinking with both of these but whatever ...
    my $ret;
    $ret->{ 'payload' } = undef;
    my $stash = $self->stash();

    $conf->{'resource' } = $stash->{'resource'};
    $conf->{'host'     } = $stash->{'host'};
    $conf->{'user'     } = $stash->{'user'};
    $conf->{'caller'   } = $stash->{'caller'};
    $conf->{'extra'    } = $stash->{'extra'};
    $conf->{'created'  } = $created;
    $conf->{'expires'  } = $stash->{'expires'};

    if (  ! defined $conf->{'expires'} || $conf->{'expires'} < 1 ){ ## zero or -1 indicate default expiration ...
        $conf->{'expires'} = $created + ( 60 * 60 * 24 ); ## default to 24 hours after created time
    }

    eval{
        $ret = $db->add( $conf );
    };

    my $text = '';
    if ( $@ ){
        if ( $@ =~ m/UNIQUE constraint failed/ ){
            $text .= "*UNIQUE constraint failed*\n";
            $ret->{'error_msg' } = 'FALIED - Lock already exists';
        } else {
            $text .= "Unknown DB Error encountered:\n<BR>\n";
            $ret->{'error_msg' } = 'Unknown DB Error encountered';
            croak $@;
        }
        $ret->{'status'} = 598;
    }

    $self->stash->{'lock_id'} = $ret->{'lock_id'};


    if ( $ret && $self->{'debug'} ){
        $text .= "\n<HR><PRE>\n";
        $text .= Dumper $stash;
        $text .= "\n</PRE>\n";

        $text .= "<HR>\n";
        $text .= Dumper $ret;
        $text .= '<BR>';
    }

    $self->app->log->debug("$text");
    $self->render( json => $ret );
    #$self->render( text => $ret, status => $ret->{'status'} );
}

1;

__END__

my $sql = "
    INSERT INTO locks ( host, user, caller, created, expires, extra, fingerprint )
    VALUES (
        $self->{'resource'},
        $self->{'host'},
        $self->{'user'},
        $self->{'caller'},
        $self->{'created'},
        $self->{'expires'},
        $self->{'extra'},
        "$self->{'fingerprint'},
    );";

##
## Fingerprint is calculated by LockAPI::Utils->fingerprint()
##
