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
    'created'   => { 'type' => 'INTEGER', 'key' => 1, 'null' => 0, 'unique' => 0, },
    'expires'   => { 'type' => 'INTEGER', 'key' => 1, 'null' => 0, 'unique' => 0, },
    'service'   => { 'type' => 'TEXT',    'key' => 0, 'null' => 0, 'unique' => 0, },
    'product'   => { 'type' => 'TEXT',    'key' => 0, 'null' => 0, 'unique' => 0, },
    'host'      => { 'type' => 'TEXT',    'key' => 0, 'null' => 0, 'unique' => 0, },
    'app'       => { 'type' => 'TEXT',    'key' => 0, 'null' => 0, 'unique' => 0, },
    'user'      => { 'type' => 'TEXT',    'key' => 0, 'null' => 0, 'unique' => 0, },
    'extra'     => { 'type' => 'BLOB',    'key' => 0, 'null' => 1, 'unique' => 0, },
);

$dbh->do( "DROP TABLE IF EXISTS $table" );

my $sql = <<EOT;
CREATE TABLE $table (
EOT

foreach my $field ( keys %fields ){
    #print "=================================================\n";
    #print "unique: '" . $fields{ $field }->{'unique'} . "'\n";
    #print "null:   '" . $fields{ $field }->{'null'} . "'\n";
    #print "=================================================\n";
    $sql .= $field . ' ' . $fields{ $field }->{'type'};
    if ( $field eq 'lock_id' ){
        ## This is the primary key, needs special handling:
        $sql .= " UNIQUE PRIMARY KEY AUTOINCREMENT";
    }
    $sql .= $fields{ $field }->{'unique'} ? '' : ' UNIQUE';
    $sql .= $fields{ $field }->{'null'}   ? '' : ' NOT NULL';
    $sql .= ",\n";
}
## sqlite fails if there's an extra , at the end ...
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

## DETACH DATABASE $db
$dbh->disconnect();

__END__

lockId - integer - autoincrement - non null - primary key
service - varchar(100) - not null
product - varchar(100) - not null
host - varchar(200) - not null
created - datetime - not null
expires - datetime - not null - default create + 24 hours?
user - varchar(100) - not null
app - varchar(100) - not null
extra - blob - null ok
