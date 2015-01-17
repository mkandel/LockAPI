use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('LockAPI');

$t->get_ok('/ping')->status_is(200);
#$t->get_ok('/ping')->status_is(200)->text_is('Ping:');
#$t->get_ok('/ping')->status_is(200)->text_is('Ping:');

done_testing();
