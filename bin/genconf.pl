#!/usr/local/bin/perl -w
use strict;
use warnings;

use Carp;
use Getopt::Long;
Getopt::Long::Configure qw/bundling no_ignore_case/;
use Data::Dumper;
# Some Data::Dumper settings:
local $Data::Dumper::Useqq  = 1;
local $Data::Dumper::Indent = 3;

local $| = 1;

my $debug  = 0;
my $user   = 0;
my $server = 0;

GetOptions(
    "debug|d"        => \$debug,
    "user|u"         => \$user,
    "server|s"       => \$server,
);

my $prog = $0;
$prog =~ s/^.*\///;

## Code goes here
use YAML::Syck;
use FindBin;

if ( $server && $user ){
    die "ERROR: user and server are mutually exclusive!!!\n";
}

my $conf_file;
if ( $user ){
    ## Per user settings
    $conf_file = "~/.lockerrc";
} elsif ( $server ) {
    ## Server settings
    $conf_file = "$FindBin::Bin/../config/lockapi.cfg";
} else {
    ## Global settings
    $conf_file = "$FindBin::Bin/../config/locker.cfg";
}

my $conf = {
    'server'      => 'localhost',
    'port'        => '3000',
    'api_version' => 'v1',
};

my $out = Dump( $conf );

if ( $debug ){
    print "OUT [$conf_file]: \n$out\n";
} else {
    open my $OUT, '>', $conf_file || die "Error opening '$conf_file': $!\n";

    print $OUT $out;

    close $OUT || die "Error closing '$conf_file': $!\n";
}

__END__

