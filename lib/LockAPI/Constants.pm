package LockAPI::Constants;
use Carp;

our %method_for = (
    'add'     => 'put',
    'delete'  => 'put',
    'modify'  => 'put',
    'list'    => 'get',
    'check'   => 'get',
);

our %errs = (
    598     => 'Insert Failed',
    599     => 'Select Failed',
);

1;
