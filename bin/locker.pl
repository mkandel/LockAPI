#!/usr/local/bin/perl -w

=head1 NAME

locker.pl - commandline client for LockAPI

=head1 SYNOPSIS

locker.pl [options] 
            
=head1 OPTIONS

=over

=item B<--help|-h>

Print this usage information and exit.

=item B<--debug|-d>

Enable debugging output

=item B<--dryrun|-n>

Enable debugging and disable notifications

=item B<--user|-u>

username of user requesting the lock

=item B<--product|-p>

product you want to lock

=item B<--service|-s>

service you want to lock

=item B<--host|-o>

hostname of the machine you wish to lock

=item B<--app|-a>

name of script/app requesting the lock

=item B<--expires|-e>

OPTIONAL: expiration date/time in UNIX epoch time

=item B<--extra|-x>

OPTIONAL: JSON encoded hash

=back
         
=head1 DESCRIPTION

C<locker.pl> commandline client for LockAPI

=cut

=head1 AUTHOR

Marc Kandel C<< <marc.kandel.cpan at gmail.com> >>

=head1 LICENSE

This code is released as Apathyware:

"The code doesn't care what you do with it, and neither do I."

=cut

use strict;
use warnings;

use Carp;
use Getopt::Long;
Getopt::Long::Configure qw/bundling no_ignore_case/;
use Data::Dumper;
# Some Data::Dumper settings:
local $Data::Dumper::Useqq  = 1;
local $Data::Dumper::Indent = 3;
use Pod::Usage;

use POSIX qw{ getlogin };
use JSON;

local $| = 1;

my $debug  = 0;
my $dryrun = 0;

my $user = getlogin;
my ( $product, $service, $host, $app, $expires );
my $extra_JSON;
my %extra;

GetOptions(
    "help|h"         => sub { pod2usage( 1 ); },
    "debug|d"        => \$debug,
    "dryrun|n"       => sub { $dryrun = 1; $debug = 1; },
    "user|u=s"       => \$user,
    "product|p=s"    => \$product,
    "service|s=s"    => \$service,
    "host|o=s"       => \$host,
    "app|a=s"        => \$app,
    "expires|e=i"    => \$expires,
    "extra|x=s"      => \$extra_JSON,
);

my $prog = $0;
$prog =~ s/^.*\///;


__END__

service    - logical environment (dev3/load3)
product    - product being worked on (buyer/s4/auc)
host       - host being locked
user       - user requesting the lock
app        - application requesting the lock.  could possibly be the same as 'product' but not in the case of Ops Tools
extra      - optional hash of metadata relating to the lock
expires    - time lock expires.  if no time given, default to some # of hours from 'add' time
