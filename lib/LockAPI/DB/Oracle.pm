package LockAPI::DB::Oracle;
use Carp;

sub new {
    my $class = shift;
    my $self = {};

    return bless $self, $class;
}

1;
