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

use FindBin;
use lib "$FindBin::Bin/../lib/";
use LockAPI::Config;

my $prog = $0;
$prog =~ s/^.*\///;

local $| = 1;

my $conf = LockAPI::Config->new();

my $debug    = 0;
my $srv_port = $conf->port()      || 3000;
my $server_n = 'morbo';

GetOptions(
    "help|h"         => sub { pod2usage( 1 ); },
    "debug|d"        => \$debug,
    "server|s=s"     => \$server_n,
);

my $server;
if ( $server_n eq 'morbo' || $server_n eq 'm' ){
    $server = '/usr/local/bin/morbo';
} elsif ( $server_n eq 'hypnotoad' || $server_n eq 'h' ){
    $server = '/usr/local/bin/morbo';
} else {
    pod2usage( -message => "Invalid server '$server_n'", -exitval => 2 );
}

my $cmd = "$server --listen http://*:$srv_port --verbose $FindBin::Bin/../script/lock_api";
print "Running '$cmd':\n";

return system $cmd;

=head1 NAME

start_server.pl - wrapper to start morbo server with configured port

=head1 SYNOPSIS

start_server.pl [options] 
            
=head1 OPTIONS

=over

=item B<--help|-h>

Print this usage information and exit.

=item B<--debug|-d>

Enable debugging output

=item B<server>

Either morbo/m or hypnotoad/h

=back
         
=head1 DESCRIPTION

C<start_server.pl> wrapper to start morbo server with configured port

=cut

=head1 AUTHOR

Marc Kandel C<< <marc.kandel.cpan at gmail.com> >>

=cut

__END__

