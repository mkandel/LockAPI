package LockAPI::Constants;
use Carp;

our %method_for = (
    'add'     => 'put',
    'delete'  => 'put',
    'modify'  => 'put',
    'list'    => 'get',
    'check'   => 'get',
);

1;
