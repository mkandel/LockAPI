package LockAPI::DB::Sqlite;
use Mojo::Base 'Mojolicious::Controller';
use Carp;

sub new {
    my $class = shift;
    my $self = {};

    return bless $self, $class;
}

1;
