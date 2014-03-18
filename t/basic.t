use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('LockAPI');
$t->get_ok('/v1/')->status_is(200)->content_like(qr/Available actions/i);
$t->get_ok('/')->status_is(404)->content_like(qr/Page not found... yet!/i);

done_testing();
