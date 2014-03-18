use Test::More;
use FindBin;
use lib "$FindBin::Bin/../lib/";
#use LockAPI::Config;

my $module_under_test = "LockAPI::Config";

#BEGIN { use_ok( $module_under_test ); }
use_ok( $module_under_test );

my $conf = LockAPI::Config->new();

my $test_serv = 'localhost';
my $test_port = '3000';
my $test_vers = 'v1';

my @meths = qw{ api_version server port };
can_ok( $module_under_test, @meths );

is( $conf->api_version(), $test_vers, "LockAPI::Config::api_version()" );
is( $conf->server(), $test_serv, "LockAPI::Config::server()" );
is( $conf->port(), $test_port, "LockAPI::Config::port()" );

done_testing();
