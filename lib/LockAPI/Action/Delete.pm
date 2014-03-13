package LockAPI::Action::Delete;
use Mojo::Base 'Mojolicious::Controller';

sub delete {
    my $self = shift;

    $self->render(text => 'Hi from LockAPI::Action::Delete::delete()!!');
}

1;
