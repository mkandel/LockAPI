use strict;
use warnings;
package LockAPI::Utils;

use Exporter;
use base qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
    fingerprint
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

sub fingerprint {
    #my $args = @_;
    my $args = shift;
    ## my $fprint = "$conf->{'service'}_$conf->{'product'}_$conf->{'host'}";
    my $fprint = "$args->{'service'}_$args->{'product'}_$args->{'host'}";

    return $fprint;
}

1;
