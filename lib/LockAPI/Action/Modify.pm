package LockAPI::Action::Modify;
use Mojo::Base 'Mojolicious::Controller';
use Carp;

sub add {
    my $self = shift;

    $self->render(text => 'Hi from LockAPI::Action::Modify::modify()!!');
}

1;
