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
    my $args = shift;

#    use Data::Dumper;
#    print "==", Dumper $args, "==";

    ## my $fprint = "$conf->{'service'}_$conf->{'product'}_$conf->{'host'}";
    my $fprint = "$args->{'resource'}_$args->{'service'}_$args->{'product'}_$args->{'host'}";

#    my $fprint;
#    if ( defined $args->{'resource'} ){
#        $fprint = "$args->{'resource'}_$args->{'service'}_$args->{'product'}_$args->{'host'}";
#    } else {
#        print "No Args!!!\n";
#        $fprint = 0;
#    }

    return $fprint;
}

1;
