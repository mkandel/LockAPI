package LockAPI::Action::Delete;
use Mojo::Base 'Mojolicious::Controller';
use Carp;

sub delete {
    my $self = shift;

    $self->render( text => 'Hi from LockAPI::Action::Delete::delete()!!' );
}

1;
