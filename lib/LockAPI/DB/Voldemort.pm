package LockAPI::DB::Voldemort;
use Carp;

sub new {
    my $class = shift;
    my $self = {};

    return bless $self, $class;
}

1;
