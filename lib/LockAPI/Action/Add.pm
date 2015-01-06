package LockAPI::Action::Add;
use Mojo::Base 'Mojolicious::Controller';
use Carp;
use YAML::Syck;
use URI::Escape;
use Data::Dumper;

use FindBin;
use lib "$FindBin::Bin/../../../lib/";
use LockAPI::DB::Sqlite;

sub add {
    my $self = shift;

    my $created = time;

    my $db = LockAPI::DB::Sqlite->new();

    my $conf = {
        'debug'      => 1,
#        'dryrun'     => 1,
    };

    my $status = 200; ## Assume OK until something borks ...
    my $ret->{'status'} = $status; ## Not sure what I was thinking with both of these but whatever ...
    my $stash = $self->stash();

    $conf->{'service'  } = $stash->{'service'};
    $conf->{'resource' } = $stash->{'resource'};
    $conf->{'product'  } = $stash->{'product'};
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
        $ret = $db->add( $confg );
    };

    my $text = '';
    if ( $@ ){
        if ( $@ =~ m/UNIQUE constraint failed/ ){
            $text .= "UNIQUE constraint failed\n";
        } else {
            $text .= "Unknown DB Error encountered:\n<BR>\n";
            croak $@;
        }
    }

    $self->stash->{'lock_id'} = $ret->{'lock_id'};


    if ( $ret && defined $self->{'debug'} ){
        $text .= "\n<HR><PRE>\n";
        $text .= Dumper $stash;
        $text .= "\n</PRE>\n";

        $text .= "<HR>\n";
        $text .= Dumper $ret;
        $text .= '<BR>';
    }

    $self->app->log->debug("$text");
    $self->render( text => "$text", status => $ret->{'status'} );
}

1;

__END__

my $sql = "
    INSERT INTO locks ( service, product, host, user, caller, created, expires, extra, fingerprint )
    VALUES (
        $self->{'service'},
        $self->{'product'},
        $self->{'host'},
        $self->{'user'},
        $self->{'caller'},
        $self->{'created'},
        $self->{'expires'},
        $self->{'extra'},
        "$self->{'service'}_$self->{'product'}_$self->{'host'}"
    );";

##
## Fingerprint is calculated by LockAPI::DB::Sqlite
##
