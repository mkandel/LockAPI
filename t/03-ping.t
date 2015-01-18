use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('LockAPI');

use LockAPI::Config;
my $config   = LockAPI::Config->new();
my $api_vers = $config->api_version();

$t->get_ok('/ping')->status_is(200);
$t->get_ok("/$api_vers/ping")->status_is(200);
$t->get_ok('/ping')->status_is(200)->content_like(qr/Ping:.*/);
$t->get_ok("/$api_vers/ping")->status_is(200)->content_like(qr/Ping:.*/);

done_testing();
