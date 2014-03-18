package LockAPI::Action::List;
use Mojo::Base 'Mojolicious::Controller';
use Carp;

sub list {
    my $self = shift;

    $self->render( text => 'Hey, you found LocakAPI::Action::List->list()' );
}

1;
