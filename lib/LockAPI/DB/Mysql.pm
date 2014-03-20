package LockAPI::DB::Mysql;
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

    service TEXT NOT NULL,
    extra BLOB,
    created INTEGER NOT NULL,
    user TEXT NOT NULL,
    expires INTEGER NOT NULL,
    app TEXT NOT NULL,
    lock_id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE NOT NULL,
    product TEXT NOT NULL,
    host TEXT NOT NULL
