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
    #my $log = shift || croak "__PACKAGE__::add - Missing argument?!?\n";
    #my $log = shift;
    my $log = Mojo::Log->new();

    my $db    = 'data/LockDB.sqlite';
    my $dbh   = DBI->connect("dbi:SQLite:dbname=$db","","", { RaiseError => 1}) or croak $DBI::errstr;
    my $table = 'locks';

    my $ret;

    my $fprint = "$conf->{'service'}_$conf->{'product'}_$conf->{'host'}";

    my $sql = "INSERT INTO locks ( service, product, host, user, caller, created, expires, extra, fingerprint ) VALUES ( '$conf->{'service'}', '$conf->{'product'}', '$conf->{'host'}', '$conf->{'user'}', '$conf->{'caller'}', $conf->{'created'}, $conf->{'expires'}, '$conf->{'extra'}', '$fprint' );";

    if ( $conf->{'debug'} ){
        $log->debug( "Will run '$sql'" );
    }

    eval{
        $dbh->do( $sql ) unless $conf->{'dryrun'};
    };
    croak $@ if $@;

    $sql = "SELECT lock_id FROM locks WHERE fingerprint = '$fprint';";
    eval{
        $ret = $dbh->do( $sql ) unless $conf->{'dryrun'};
    };
    croak $@ if $@;

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
