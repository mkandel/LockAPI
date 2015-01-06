package LockAPI::Action::Ping;
use Mojo::Base 'Mojolicious::Controller';
use Carp;

#sub new {
#    my $class = shift;
#
#    my $self = @_;
#
#    return bless $self, $class;
#}

sub ping {
    my $self = shift;

    my $status = 200; ## Assume OK until something borks ...
    my $ret->{'status'} = $status; ## Not sure what I was thinking with both of these but whatever ...
    my $stash = $self->stash();
    use Data::Dumper;
    print Dumper $stash;
#    $self->stash( 'now'   => localtime( time ) );
    $self->stash( 'title' => 'LockAPI Ping Page' );

    my $text = "Ping: " . localtime( time );
    $self->stash( text => $text );
    $self->app->log->new( path => '/tmp/lockapi.log' );
    $self->app->log->debug( time . ": $text");
#    $self->render( text => "$text", status => $ret->{'status'} );
}

1;

__END__

