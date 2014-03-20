package LockAPI::Action::Add;
use Mojo::Base 'Mojolicious::Controller';
use Carp;
use YAML::Syck;
use URI::Escape;
use Data::Dumper;

use FindBin;
use lib "$FindBin::Bin/../../../lib/";
use LockAPI::DB::Sqlite;

sub add {
    my $self = shift;

    my $db = LockAPI::DB::Sqlite->new();
    my $conf = {};

    my $status = 200; ## Assume OK until something borks ...
    my $stash = $self->stash();

    my $text = '<PRE>';
    $text .= Dumper $stash;
    $text .= '</PRE>';
#    my @data = split /\n/, Dump( $self->stash() );
#    my $out = '';
#
#    foreach my $line ( @data ){
#        $line =~ s/^(\w+)/&nbsp;&nbsp;&nbsp;&nbsp;$1/g;
#        $out .= $line . '<BR>';
#    }
#
#    $self->render( text => "<CODE>$out</CODE>" );

    eval{
        $db->add( $conf );
    };
    croak $@ if $@;

    $self->render( text => "$text", status => $status );
}

1;
