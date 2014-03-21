package LockAPI::DB::Sqlite;
use Carp;
use DBD::SQLite;

sub new {
    my $class = shift;
    my $self = {};

    return bless $self, $class;
}

sub add {
    my $self = shift;
    my $conf = shift || croak "Cannot add entry without data ...\n";

    my $db = LockAPI::DB::Sqlite->new();
    my $fprint = "$self->{'service'}_$self->{'product'}_$self->{'host'}";

    my $sql = "INSERT INTO locks ( service, product, host, user, caller, created, expires, extra, fingerprint ) VALUES ( $self->{'service'}, $self->{'product'}, $self->{'host'}, $self->{'user'}, $self->{'caller'}, $self->{'create'}, $self->{'expire'}, $self->{'extra'}, '$fprint' );";

    if ( $self->{'debug'} ){
        print "Will run '$sql'\n";
    }

    eval{
        $dbh->do( $sql ) unless $conf->{'dryrun'};
    };
    croak $@ if $@;
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
