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

GetOptions(
    "debug|d"        => \$debug,
);

my $prog = $0;
$prog =~ s/^.*\///;

## Code goes here
use JSON::XS;

use FindBin;

my $data = {
    'zero'  => 0,
    'one'   => 1,
    'two'   => 2,
    'three' => 3,
    'four'  => 4,
    'five'  => 5,
    'six'   => 6,
    'seven' => 7,
    'eight' => 8,
    'nine'  => 9,
};

my $out = encode_json $data;
print "$out\n";

__END__

