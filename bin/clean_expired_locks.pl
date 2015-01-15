#!/usr/local/bin/perl -w
use strict;
use warnings;

use Data::Dumper;
use DBI;
use Getopt::Long;
Getopt::Long::Configure qw/bundling no_ignore_case/;

my $debug  = 0;
my $dryrun = 0;

my $db    = 'data/LockDB.sqlite';
my $dbh   = DBI->connect("dbi:SQLite:dbname=$db","","", { RaiseError => 1}) or die $DBI::errstr;
my $table = 'locks';

GetOptions(
    "debug|d"        => \$debug,
    "dryrun|n"       => \$dryrun,
);

my $now = time;

my $sql   = "SELECT * FROM locks WHERE expires <= $now;";
my $locks = $dbh->selectall_arrayref( $sql );

print Dumper $locks if $debug;

#my @locks;

foreach my $lock ( @{ $locks } ){
    $sql = "DELETE FROM locks WHERE lock_id == $lock->[9];";
    $dbh->do( $sql ) unless $dryrun;

    if ( $dryrun ){
        print "(dryrun) Would run '$sql'\n";
    }

    if ( $DBI::err ){
        print "ERROR> ", $DBI::errstr, "\n";
    }
}

## DETACH DATABASE $db
$dbh->disconnect();

__END__

