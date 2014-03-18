package LockAPI::Action::Add;
use Mojo::Base 'Mojolicious::Controller';
use Carp;
use YAML::Syck;

sub add {
    my $self = shift;
    my @data = split /\n/, Dump( $self->stash() );
    my $out = '';

    foreach my $line ( @data ){
        $line =~ s/^(\w+)/&nbsp;&nbsp;&nbsp;&nbsp;$1/g;
        $out .= $line . '<BR>';
    }

    $self->render( text => "<CODE>$out</CODE>" );
}

1;
