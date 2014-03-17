package LockAPI::Constants;
use Mojo::Base 'Mojolicious::Controller';

my %method_for = (
    'add'     => 'PUT',
    'delete'  => 'PUT',
    'modify'  => 'PUT',
    'list'    => 'GET',
    'check'   => 'GET',
);

1;
