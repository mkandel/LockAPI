package LockAPI::Constants;

our %method_for = (
    'add'     => 'put',
    'delete'  => 'put',
    'modify'  => 'put',
    'list'    => 'get',
    'check'   => 'get',
);

our %errs = (
    597     => 'Locked',
    598     => 'Insert Failed',
    599     => 'Select Failed',
);

1;
