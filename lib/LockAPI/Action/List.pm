package LockAPI::Action::List;
use Mojo::Base 'Mojolicious::Controller';
use Carp;
use Data::Dumper::HTML qw{ dumper_html };

sub list {
    my $self   = shift;
    my $status = 200;

    my $db = $self->app->db();

    my $val = $db->list();
    my $text = dumper_html( $val );

    $self->render( text => $text );
}

sub count {
    my $self   = shift;
    my $status = 200;

    my $db = $self->app->db();

    my $val = $db->list();
    my $text = scalar @{ $val };

    $self->render( text => $text );
}

sub list_filtered {
    my $self   = shift;
    my $filter = shift;
    my $status = 200;

    my $db = $self->app->db();

    my $val = $db->list_filtered();
    my $text = dumper_html( $val );

    $self->render( text => $text );
}

sub count_filtered {
    my $self   = shift;
    my $filter = shift;
    my $status = 200;

    my $db = $self->app->db();

    my $val = $db->list_filtered();
    my $text = scalar @{ $val };

    $self->render( text => $text );
}

1;
