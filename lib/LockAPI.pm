package LockAPI;
use Mojo::Base 'Mojolicious';

our $VERSION = '0.01';

# This method will run once at server start
sub startup {
    my $self = shift;

    ## Shutup supid secret warning ...
    ## Old style, pre-5.18?
    #$self->secret('My very secret motherfucking passphrase.');
    ## New style ...
    $self->secrets(['My very secret motherfucking passphrase.']);

    # Documentation browser under "/perldoc"
    $self->plugin('PODRenderer');

    # Router
    my $r = $self->routes;

    # Normal route to controller
    $r->get('/')->to('example#welcome');

    ## API v1 routes
    ## Add
    $r->put('/v1/add/'   )->to( 'action-add#add' );

    ## Delete
    $r->put('/v1/delete/')->to('action-delete#delete');

    ## List
    $r->get('/v1/list/'  )->to('action-list#list'    );
    
    ## Check
    $r->get('/v1/check/' )->to('action-check#check'  );

    ## Modify
    $r->put('/v1/modify/')->to('action-modify#modify');

    ## Default
#    $r->get('/v1/'       )->render(text => 'Available actions: add delete list check modify');
}

1;
__END__

=encoding utf-8

=head1 NAME

LockAPI - Blah blah blah

=head1 SYNOPSIS

  use LockAPI;

=head1 DESCRIPTION

LockAPI is

=head1 AUTHOR

Marc Kandel E<lt>marc.kandel.cpan@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2014- Marc Kandel

=head1 LICENSE

This code is released as Apathyware:

"The code doesn't care what you do with it, and neither do I."

=head1 SEE ALSO

=cut
