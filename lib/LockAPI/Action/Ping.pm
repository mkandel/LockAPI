package LockAPI::Action::Ping;
use Mojo::Base 'Mojolicious::Controller';
use Carp;
use Data::Dumper;

sub ping {
    my $self = shift;

    my $status = 200; ## Assume OK until something borks ...
    my $ret->{'status'} = $status; ## Not sure what I was thinking with both of these but whatever ...
    my $stash = $self->stash();
#    print Dumper $stash;

    $self->stash( 'title' => 'LockAPI Ping Page' );

    my $text = "Ping: " . localtime( time );
    $self->stash( text => $text );
    $self->app->log->new( path => '/tmp/lockapi.log' );
    $self->app->log->debug( time . ": $text");
}

1;

__END__

