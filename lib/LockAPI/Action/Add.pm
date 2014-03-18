package LockAPI::Action::Add;
use Mojo::Base 'Mojolicious::Controller';
use Carp;
use YAML::Syck;
use Data::Dumper;

use FindBin;
use lib "$FindBin::Bin/../../../lib/";
use LockAPI::DB::Sqlite;

sub add {
    my $self = shift;

    my $status = 200; ## Assume OK until something borks ...

    my $text = Dumper $self;
#    my $db = $self->
#    my @data = split /\n/, Dump( $self->stash() );
#    my $out = '';
#
#    foreach my $line ( @data ){
#        $line =~ s/^(\w+)/&nbsp;&nbsp;&nbsp;&nbsp;$1/g;
#        $out .= $line . '<BR>';
#    }
#
#    $self->render( text => "<CODE>$out</CODE>" );
    $self->render( text => "$text", status => $status );
}

1;
