#!/opt/local/bin/perl -w
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

my $debug = 0;

GetOptions(
    "debug|d"        => \$debug,
);

my $prog = $0;
$prog =~ s/^.*\///;

## Code goes here
use YAML::XS;
use FindBin;

my $conf_file = "$FindBin::Bin/../.lockerrc";

my %conf = (
    'server'      => 'localhost',
    'port'        => '3000',
    'api_version' => 'v1',
);



__END__

