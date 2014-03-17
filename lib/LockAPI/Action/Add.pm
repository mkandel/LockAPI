package LockAPI::Action::Add;
use Mojo::Base 'Mojolicious::Controller';
use Carp;

sub add {
    my $self = shift;

    $self->render(text => 'Hi from LockAPI::Action::Add::add()!!');
}

1;
