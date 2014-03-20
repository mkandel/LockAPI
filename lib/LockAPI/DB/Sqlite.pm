package LockAPI::DB::Sqlite;
use Carp;

sub new {
    my $class = shift;
    my $self = {};

    return bless $self, $class;
}

sub add {
    my $self = shift;

    my $sql = "INSERT INTO locks ( service, product, host, user, caller, created, expires, extra, fingerprint ) VALUES ( '$service', '$product', '$host', '$user', '$caller', $create, $expire, $extra, '$service_$product_$host' );"
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
