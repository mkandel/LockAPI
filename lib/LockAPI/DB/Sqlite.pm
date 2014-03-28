package LockAPI::DB::Sqlite;
use Carp;
use DBI;
use DBD::SQLite;
use Data::Dumper;

sub new {
    my $class = shift;
    my $self = {};

    my $self->{'log'} = Mojo::Log->new();

    return bless $self, $class;
}

sub add {
    my $self = shift;
    my $conf = shift || croak "Cannot add entry without data ...\n";

    my $db    = 'data/LockDB.sqlite';
    my $dbh   = DBI->connect("dbi:SQLite:dbname=$db","","", { RaiseError => 1}) or croak $DBI::errstr;
    my $table = 'locks';
    ## We'll be handling errors in Perl ...
#    $dbh->{'RaiseError'} = 0;
#    $dbh->{'PrintError'} = 0;

    my $ret->{'lock_id'} = -1;
    $ret->{'status'} = 200;

    my $fprint = "$conf->{'service'}_$conf->{'product'}_$conf->{'host'}";

    my $sql = "INSERT INTO locks ( service, product, host, user, caller, created, expires, extra, fingerprint ) VALUES ( '$conf->{'service'}', '$conf->{'product'}', '$conf->{'host'}', '$conf->{'user'}', '$conf->{'caller'}', $conf->{'created'}, $conf->{'expires'}, '$conf->{'extra'}', '$fprint' );";

    if ( $conf->{'debug'} ){
        $self->{'log'}->debug( "** " . __PACKAGE__ . "::add: Will run '$sql'\n" );
    }

    eval{
        unless ( $conf->{'dryrun'} ){
            $dbh->do( $sql );
        }
    };
    #croak $@ if $@;
    if ( $@ ){
        $self->{'status'} = 598;
        $ret->{'status'} = 598;
        #croak $@;
    }

    $sql = "SELECT lock_id FROM locks WHERE fingerprint = '$fprint';";

    if ( $conf->{'debug'} ){
        $self->{'log'}->debug( "** " . __PACKAGE__ . "::add: Will run '$sql'\n" );
    }

    eval{
        unless ( $conf->{'dryrun'} ){
            $self->{'log'}->debug( "** " . __PACKAGE__ . "::add: Running '$sql'\n" );
            $ret->{'lock_id'} = $dbh->selectall_arrayref( $sql )->[0]->[0] or croak DBI::errstr;
        }
    };
    #croak $@ if $@;
    if ( $@ ){
        $self->{'status'} = 599;
        $ret->{'status'} = 599;
        #croak $@;
    }

    if ( defined $conf->{'debug'} ){
        my $out = Dumper $ret;
        $self->{'log'}->debug( "** " . __PACKAGE__ . "::add: Created lock_id '$ret->{'lock_id'}' **" );
        $self->{'log'}->debug( "** " . __PACKAGE__ . "::add: Returning: '$out' **" );
    }

    return $ret || croak __PACKAGE__, '::add(): Unrecoverable error ...';
}

sub list {
}

sub delete {
}

sub modify {
}

sub get {
}

1;

__END__

CREATE TABLE locks (
    lock_id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE NOT NULL,
    caller TEXT NOT NULL,
    user TEXT NOT NULL,
    product TEXT NOT NULL,
    expires INTEGER NOT NULL,
    extra BLOB,
    service TEXT NOT NULL,
    created INTEGER NOT NULL,
    host TEXT NOT NULL,
    fingerprint TEXT UNIQUE NOT NULL
);
