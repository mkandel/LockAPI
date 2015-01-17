package LockAPI::DB::Voldemort;
use Carp;

sub new {
    my $class = shift;
    my $self = {};

    return bless $self, $class;
}

sub add {
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
    expires INTEGER NOT NULL,
    extra BLOB,
    created INTEGER NOT NULL,
    host TEXT NOT NULL,
    fingerprint TEXT UNIQUE NOT NULL
);
