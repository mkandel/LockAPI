package LockAPI::Action::Delete;
use Mojo::Base 'Mojolicious::Controller';
use Carp;
use Data::Dumper::HTML qw( dumper_html );

sub delete {
    my $self = shift;
    my $status = 200;

    my $stash = $self->stash();

#    my $text = dumper_html( $stash );

    my $db = $self->app->db();

    my $lock_id = $stash->{'lock_id'} || croak "delete requires a lock_id!";

    my $val = $db->delete( $lock_id );
    my $text = dumper_html( $val );

    $self->render( text => $text );
}

1;
