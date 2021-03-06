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
use LWP::UserAgent;

use FindBin;
use lib "$FindBin::Bin/../lib/";
use LockAPI::Config;
use LockAPI::Constants;

use Time::HiRes qw{ gettimeofday };
my $start = gettimeofday;

my $prog = $0;
$prog =~ s/^.*\///;

local $| = 1;

my $debug  = 0;
my $dryrun = 0;

#my $conf = LockAPI::Config->new();
my $conf = LockAPI::Config->new({ 'debug' => $debug });

my $user = getlogin;
my ( $host, $app, $expires, $extra_JSON, $lock_id, $resource );
my $lock_srv = $conf->server()    || 'localhost';
my $srv_port = $conf->port()      || 3000;
my $api_vers = $conf->api_version || 'v1';

my @actions = qw{ add delete list check modify };

GetOptions(
    "help|h"         => sub { pod2usage( 1 ); },
    "debug|d"        => \$debug,
    "dryrun|n"       => sub { $dryrun = 1; $debug = 1; },
    "user|u=s"       => \$user,
    "resource|r=s"   => \$resource,
    "host|o=s"       => \$host,
    "app|a=s"        => \$app,
    "expires|e=i"    => \$expires,
    "extra|x=s"      => \$extra_JSON,
    "server|s=s"     => \$lock_srv,
    "port|t=i"       => \$srv_port,
) || pod2usage( 1 );

$lock_srv .= $srv_port ? ":$srv_port" : '';

## We've parsed all the '-a|--arg' style args, the action should be left on ARGV
my $action = shift @ARGV || pod2usage( -verbose => 1, -message => "action is a required argument!!" );

## Validate action is valid:
pod2usage( -verbose => 1, -message => "Invalid action '$action'!!" ) unless grep {/$action/} @actions;

## Validate arguments:
pod2usage( -verbose => 1, -message => "Missing argument 'user'!!"    ) unless $user;
pod2usage( -verbose => 1, -message => "Missing argument 'host'!!"    ) unless $host;
pod2usage( -verbose => 1, -message => "Missing argument 'app'!!"     ) unless $app;
#pod2usage( -verbose => 1, -message => "Missing argument 'expires'!!" ) unless $expires;

if ( ( $action eq 'list' || $action eq 'check' ) && $extra_JSON ){
    pod2usage( -verbose => 1, -message => "Cannot use extra JSON with action '$action'" );
}

$expires = $expires || time + ( 60 * 60 * 24 );
$extra_JSON = $extra_JSON || '';

my $method = $LockAPI::Constants::method_for{ $action };
my $url = "http://$lock_srv/$api_vers/$action/$resource/$host/$user/$app/$expires/$extra_JSON";

if ( $debug ){
    print "Action  : '$action'\n";
    print "Resource: '$resource'\n";
    print "Host    : '$host'\n";
    print "App     : '$app'\n";
    print "Expires : '$expires'\n";
    print "URL     : '$url'\n";
    print "Meth    : '$method'\n";
    print "Extra   : '$extra_JSON'\n" if $extra_JSON;
    print "\n";
}

## Handle special cases here:
if ( $action eq 'check' && $lock_id ){
    ## We're checking by lock_id, URL needs to change ...
    $url = "http://$lock_srv/$api_vers/$action/$lock_id/";
}

my $ua = LWP::UserAgent->new();
$ua->timeout( 30 );

my $resp = $ua->$method( $url );

if ( $debug ){
    print "========================================================\n";
    print Dumper $resp;
    print "========================================================\n";
    my $out = $resp->content();
#    $out =~ s/&nbsp;/ /g;
#    $out =~ s/<BR>/\n/gi;
    print Dumper $out;
#    print "$out\n";
    print "========================================================\n";

    my $coder = JSON->new->ascii->pretty->allow_nonref;
    my $json = $coder->decode( $out );
    
    my $lockId;
    if ( ref $json eq 'HASH' ){
        $lockId = $json->{'lock_id'};
    } else {
        $lockId = 'Failed';
    }
    print "Method used: ", $resp->request()->method(), "\n";
    print "Return code: ", $resp->code(), "\n";
    print "Lock ID    : $lockId\n";
    print "Content    :\n\t$out\n";
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

=cut

__END__

