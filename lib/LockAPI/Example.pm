package LockAPI::Example;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub welcome {
    my $self = shift;

    # Render template "example/welcome.html.ep" with message
    $self->render(
        msg => 'Hey, welcome to the Mojolicious real-time web framework MotherFucker!!!!' );
}

1;
