package LockAPI::DB::Sqlite;
use Carp;
use DBI;
use DBD::SQLite;
use Data::Dumper;
use LockAPI::Config;
use LockAPI::Utils qw{ fingerprint };

sub new {
    my $class = shift;
    my $self = {};

    my $config = LockAPI::Config->new();
    my $dir    = $config->db_path();
    my $db    = $dir . '/LockDB.sqlite';

    $self->{ '_db' } = $db;

    my $self->{'dbh'}   = DBI->connect("dbi:SQLite:dbname=$db","","",
        { 
            RaiseError => 1,
            AutoCommit => 1,

        }
    ) or croak $DBI::errstr;

#    my $trace_setting = "3|SQL";
#    my $trace_filename = '/tmp/lockapi.trace';
#    DBI->trace($trace_setting, $trace_filename);
    $self->{'table'} = 'locks';

    $self->{'log'} = Mojo::Log->new( path => '/tmp/lockapi.log' );
    $self->{'_config'} = $config;

    return bless $self, $class;
}

sub add {
    my $self = shift;
    my $conf = shift || croak "Cannot add entry without data ...\n";

    my $ret->{'lock_id'} = -1;
    $ret->{'status'} = 200;

    my $fprint = fingerprint( { 
            host     => $conf->{'host'},
            resource => $conf->{'resource'},
    } );

    my $sql =
        "INSERT INTO $self->{'table'} ( resource, host, user, caller, created, expires, extra, fingerprint )
        VALUES (
            '$conf->{'resource'}',
            '$conf->{'host'}',
            '$conf->{'user'}',
            '$conf->{'caller'}',
            '$conf->{'created'}',
            '$conf->{'expires'}',
            '$conf->{'extra'}',
            '$fprint' 
        );";

#    print "*** '$sql' ***\n";

    if ( $conf->{'_config'}->{'debug'} ){
        $self->{'log'}->debug( "** " . __PACKAGE__ . "::add(): Will run '$sql'\n" );
    }

    eval{
        unless ( $conf->{'dryrun'} ){
            $self->{'dbh'}->do( $sql );
        }
    };
    #croak $@ if $@;
    if ( $DBI::errstr ){
        $self->{'status'} = 598;
        $ret->{'status'} = 598;
        $ret->{'error'} = $DBI::errstr || 'No $DBI::errstr returned ...';
        croak $DBI::errstr;
    }

    $sql = "SELECT lock_id FROM locks WHERE fingerprint = '$fprint';";

    if ( $conf->{'debug'} ){
        $self->{'log'}->debug( "** " . __PACKAGE__ . "::add(): Will run '$sql'\n" );
    }

    eval{
        unless ( $conf->{'dryrun'} ){
            $self->{'log'}->debug( "** " . __PACKAGE__ . "::add(): Running '$sql'\n" );
            $ret->{'lock_id'} = $self->{'dbh'}->selectall_arrayref( $sql )->[0]->[0] or croak $DBI::errstr;
        }
    };
    #croak $@ if $@;
    if ( $DBI::errstr ){
        $self->{'status'} = 599;
        $ret->{'status'} = 599;
        $ret->{'error'} = $DBI::errstr || 'No $DBI::errstr returned ...';
        croak $DBI::errstr;
    }

    if ( defined $conf->{'debug'} ){
        my $out = Dumper $ret;
        $self->{'log'}->debug( "** " . __PACKAGE__ . "::add(): Created lock_id '$ret->{'lock_id'}' **" );
        $self->{'log'}->debug( "** " . __PACKAGE__ . "::add(): Returning: '$out' **" );
    }
    print "******************************\n";
    print Dumper $ret;
    print "******************************\n";

    return $ret || croak __PACKAGE__, '::add(): Unrecoverable error ...';
}

sub list {
    my $self = shift;

    ## ASC is default ORDER BY
    my $sql = "SELECT * FROM locks;";

    my $out = $self->{'dbh'}->selectall_arrayref( $sql ) or croak $DBI::errstr;
#    print Dumper $out;
    return $out;
}

sub list_filtered {
    my $self = shift;
    my $conf = shift || croak "Cannot list entry without data ...\n";

    if ( defined $conf->{'debug'} ){
        my $out = Dumper $conf;
        $self->{'log'}->debug( "** " . __PACKAGE__ . "::list(): received: '$out' **" );
    }
}

sub delete {
    my $self = shift;
    my $id   = shift || croak "Cannot delete by ID without an ID to delete!";

    my $sql = "DELETE FROM locks WHERE lock_id == $id;";

    my $out = $self->{'dbh'}->selectall_arrayref( $sql ) or croak $DBI::errstr;
    print Dumper $out;
    return $out;
}

sub modify {
    my $self = shift;
    my $conf = shift || croak "Cannot modify entry without data ...\n";

}

sub check_id {
    my $self = shift;
    my $id   = shift || croak "Cannot get entry without data ...\n";

    ## Locks are valid unless they're expired
    my $now  = time;

    ## If the "expires" timestamp is >= now, we're still valid
    my $sql = "SELECT count( lock_id ) FROM locks WHERE lock_id == $id AND expires >= $now;";

    my $out = $self->{'dbh'}->selectall_arrayref( $sql )->[0] or croak $DBI::errstr;

    return  $out;
}

sub check_fingerprint {
    my $self = shift;
    my $conf = shift || croak "Cannot get entry without data ...\n";

    $self->{'log'}->debug( Dumper $conf );

    my $fprint = fingerprint( {
            host     => $conf->{'host'},
            resource => $conf->{'resource'},
    } );

    my $sql = "SELECT count( lock_id ) FROM locks WHERE fingerprint LIKE '$fprint';";
    $self->{'log'}->debug( "check_fingerprint: '$fprint'" );

    return  $self->{'dbh'}->selectall_arrayref( $sql )->[0]->[0] or croak $DBI::errstr;
}

1;

__END__

CREATE TABLE locks (
    lock_id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE NOT NULL,
    caller TEXT NOT NULL,
    user TEXT NOT NULL,
    expires INTEGER NOT NULL,
    extra BLOB,
    created INTEGER NOT NULL,
    host TEXT NOT NULL,
    fingerprint TEXT UNIQUE NOT NULL
);
