package LockAPI::Action::Add;
use Mojo::Base 'Mojolicious::Controller';
use Carp;

sub new {
    my $class = shift;

    my $self = @_;

    return bless $self, $class;
}

sub ping {
    my $self = shift;

    my $status = 200; ## Assume OK until something borks ...
    my $ret->{'status'} = $status; ## Not sure what I was thinking with both of these but whatever ...
    my $stash = $self->stash();
    $self->stash( 'now' => localtime( time ) );
    use Data::Dumper;
    print Dumper $stash;

    my $text = "Ping: " . localtime( time );
    $self->stash( 'content' => $text );
    $self->app->log->debug("$text");
    $self->render( text => "$text", status => $ret->{'status'} );
}

1;

__END__

