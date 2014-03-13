package LockAPI::Action::Check;
use Mojo::Base 'Mojolicious::Controller';

sub check {
    my $self = shift;

    $self->render(text => 'Hi from LockAPI::Action::Check::check()!!');
}

1;
