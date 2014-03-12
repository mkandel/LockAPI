#!/usr/local/bin/perl -w
use strict;
use warnings;

use DBI;
my $db    = 'LockDB';
my $dbh   = DBI->connect("dbi:SQLite:dbname=$db","","");
my $table = 'locks';

my %fields = (
    'lock_id'   => { 'type' => 'INTEGER', 'key' => 1, 'null' => 0, 'unique' => 1, },
    'service'   => { 'type' => 'TEXT',    'key' => 0, 'null' => 0, 'unique' => 0, },
    'product'   => { 'type' => 'TEXT',    'key' => 0, 'null' => 0, 'unique' => 0, },
    'host'      => { 'type' => 'TEXT',    'key' => 0, 'null' => 0, 'unique' => 0, },
    'created'   => { 'type' => 'INTEGER', 'key' => 1, 'null' => 0, 'unique' => 0, },
    'expires'   => { 'type' => 'INTEGER', 'key' => 1, 'null' => 0, 'unique' => 0, },
);

__END__

lockId - integer - autoincrement - non null - primary key
service - varchar(100) - not null
product - varchar(100) - not null
host - varchar(200) - not null
created - datetime - not null
expires - datetime - not null - default create + 24 hours?
