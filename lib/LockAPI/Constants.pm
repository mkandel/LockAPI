package LockAPI::Constants;
use Mojo::Base 'Mojolicious::Controller';
use Carp;

our %method_for = (
    'add'     => 'put',
    'delete'  => 'put',
    'modify'  => 'put',
    'list'    => 'get',
    'check'   => 'get',
);

1;
