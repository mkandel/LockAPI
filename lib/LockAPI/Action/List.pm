package LockAPI::Action::List;
use Mojo::Base 'Mojolicious::Controller';

sub add {
    my $self = shift;

    # Render template "example/welcome.html.ep" with message
    $self->render(
        msg => 'Hey, you found LocakAPI::Action::List->list()' );
}

1;
