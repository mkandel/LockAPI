use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('LockAPI');
my $api_vers = 'v1';

$t->get_ok('/ping')->status_is(200);
$t->get_ok("/$api_vers/ping")->status_is(200);
$t->get_ok('/ping')->status_is(200)->content_like(qr/Ping:.*/);
$t->get_ok("/$api_vers/ping")->status_is(200)->content_like(qr/Ping:.*/);

done_testing();
