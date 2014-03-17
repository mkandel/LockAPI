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
use Pod::Usage;

use POSIX qw{ getlogin };
use JSON;

use Time::HiRes qw{ gettimeofday };
my $start = gettimeofday;

my $prog = $0;
$prog =~ s/^.*\///;

local $| = 1;

my $debug  = 0;
my $dryrun = 0;

my $user = getlogin;
my ( $product, $service, $host, $app, $expires, $extra_JSON );
my $lock_srv = 'localhost';
my $srv_port = 3000;

my @actions = qw{ add delete list check modify };

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
    "server|r=s"     => \$lock_srv,
    "port|t=i"       => \$srv_port,
);

$lock_srv .= $srv_port ? ":$srv_port" : '';

## We've parsed all the '-a|--arg' style args, the action should be left on ARGV
my $action = shift @ARGV || pod2usage( -verbose => 1, -message => "action is a required argument!!" );

## Validate action is valid:
pod2usage( -verbose => 1, -message => "Invalid action '$action'!!" ) unless grep {/$action/} @actions;

## Validate arguments:
pod2usage( -verbose => 1, -message => "Missing argument 'user'!!"    ) unless $user;
pod2usage( -verbose => 1, -message => "Missing argument 'product'!!" ) unless $product;
pod2usage( -verbose => 1, -message => "Missing argument 'service'!!" ) unless $service;
pod2usage( -verbose => 1, -message => "Missing argument 'host'!!"    ) unless $host;
pod2usage( -verbose => 1, -message => "Missing argument 'app'!!"     ) unless $app;
$expires = $expires || time;
$extra_JSON = $extra_JSON || '';

my $url = "http://$lock_srv/v1/$action/$service/$product/$host/$user/$app/$extra_JSON";

if ( $debug ){
    print "Action : '$action'\n";
    print "Product: '$product'\n";
    print "Service: '$service'\n";
    print "Host   : '$host'\n";
    print "App    : '$app'\n";
    print "Expires: '$expires'\n";
    print "URL    : '$url'\n";
    print "\n";
}



#########################################################################################
END{
    if ( $debug ){
        my $run_time = gettimeofday() - $start;
        print "$prog ran for ";
        if ( $run_time < 60 ){
            print "$run_time seconds.\n";
        } else {
            use integer;
            print $run_time / 60 . " minutes " . $run_time % 60 
                . " seconds ($run_time seconds).\n";
        }
    }
}

=head1 NAME

locker.pl - commandline client for LockAPI

=head1 SYNOPSIS

locker.pl <action> [options] 
            
=head1 OPTIONS

=over

=item B<<action>>

One of:
add
check
delete
list
modify

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

__END__

service    - logical environment (dev3/load3)
product    - product being worked on (buyer/s4/auc)
host       - host being locked
user       - user requesting the lock
app        - application requesting the lock.  could possibly be the same as 'product' but not in the case of Ops Tools
extra      - optional hash of metadata relating to the lock
expires    - time lock expires.  if no time given, default to some # of hours from 'add' time

