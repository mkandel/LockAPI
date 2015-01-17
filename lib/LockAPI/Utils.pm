use strict;
use warnings;
package LockAPI::Utils;

use Exporter;
use base qw(Exporter);
use Carp;

our %EXPORT_TAGS = ( 'all' => [ qw(
    fingerprint
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

sub fingerprint {
    my $args = shift;

    unless ( defined $args->{'resource'} && defined $args->{'host'} ){
        croak "Cannot create fingerprint, not enough information!  resource and host are both required!";
    }

    my $fprint = "$args->{'resource'}_$args->{'host'}";

    return $fprint;
}

1;
