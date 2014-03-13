#!/usr/local/bin/perl -w
use strict;
use warnings;

use Data::Dumper;
use DBI;
use Getopt::Long;
Getopt::Long::Configure qw/bundling no_ignore_case/;

my $debug = 0;
my $db    = 'data/LockDB.sqlite';
my $dbh   = DBI->connect("dbi:SQLite:dbname=$db","","", { RaiseError => 1}) or die $DBI::errstr;
my $table = 'locks';
my $full  = "$db\.$table";

GetOptions(
    "debug|d"        => \$debug,
);

my %fields = (
    'lock_id'   => { 'type' => 'INTEGER', 'key' => 1, 'null' => 0, 'unique' => 1, },
    'service'   => { 'type' => 'TEXT',    'key' => 0, 'null' => 0, 'unique' => 0, },
    'product'   => { 'type' => 'TEXT',    'key' => 0, 'null' => 0, 'unique' => 0, },
    'host'      => { 'type' => 'TEXT',    'key' => 0, 'null' => 0, 'unique' => 0, },
    'created'   => { 'type' => 'INTEGER', 'key' => 1, 'null' => 0, 'unique' => 0, },
    'expires'   => { 'type' => 'INTEGER', 'key' => 1, 'null' => 0, 'unique' => 0, },
);

$dbh->do( "DROP TABLE IF EXISTS $table" );

my $sql = <<EOT;
CREATE TABLE $table (
EOT

foreach my $field ( keys %fields ){
    $sql .= $field . ' ' . $fields{ $field }->{'type'} . ",\n";
    if ( $field eq 'lock_id' ){
        ## This is the primary key, needs special handling:
        ## strip the ',\n'
        $sql =~ s/,\n$//;
        ## Add the special stuff and the ',\n'
        $sql .= " PRIMARY KEY AUTOINCREMENT,\n"
    }
}
## sqlite fails if there's an extra , ... -------------------------^
$sql =~ s/,\n$/\n/;

$sql .= ")\n";  ## Add the ')'

print "Running SQL:\n$sql\n" if $debug;
$sql =~ s/\n//g;

$dbh->do( $sql ) unless $debug;

if ( $DBI::err ){
    print "ERROR> ", $DBI::errstr, "\n";
} else {
    print "SQL Successful!\n";
    #print "SQL Successful!\n" if $debug;
}

=pod

my $sth = $dbh->prepare( $sql );
print Dumper $dbh if $debug;
print Dumper $sth if $debug;

$dbh->{'RaiseError'} = 1;
$sth->{'RaiseError'} = 1;

$sth->execute unless $debug;
$sth->finish;

print Dumper $sth if $debug;

if ( $dbh->err() ){
    print "ERROR> ", $dbh->errstr(), "\n";
} else {
    print "SQL Successful!\n" if $debug;
}

=cut

## DETACH DATABASE $db
$dbh->disconnect();

__END__

lockId - integer - autoincrement - non null - primary key
service - varchar(100) - not null
product - varchar(100) - not null
host - varchar(200) - not null
created - datetime - not null
expires - datetime - not null - default create + 24 hours?
