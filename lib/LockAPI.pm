package LockAPI;
use Mojo::Base 'Mojolicious';

our $VERSION = '0.01';

# This method will run once at server start
sub startup {
    my $self = shift;

    ## Shutup supid secret warning ...
    $self->secret('My very secret motherfucking passphrase.');

    # Documentation browser under "/perldoc"
    $self->plugin('PODRenderer');

    # Router
    my $r = $self->routes;

    # Normal route to controller
    $r->get('/')->to('example#welcome');

#    my $root = $r->under('/');
    #$root->post('/list')->to('blog#list');
#    $root->get(sub { shift->render(text => 'Go away!') });

    ## API v1 routes
    ## Add
    $r->get('/v1/add/'   )->to( controller => 'LockAPI::Action::List', action => 'list' );

    ## Delete
    $r->get('/v1/delete/')->to('action::Delete#delete');

    ## List
    $r->get('/v1/list/'  )->to('action::List#list'    );
    
    ## Check
    $r->get('/v1/check/' )->to('action::Check#check'  );

    ## Modify
    $r->get('/v1/modify/')->to('action::Modify#modify');

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

Marc Kandel E<lt>mkandel@ariba.comE<gt>

=head1 COPYRIGHT

Copyright 2014- Marc Kandel

=head1 LICENSE

This code is released as Apathyware:

"The code doesn't care what you do with it, and neither do I."

=head1 SEE ALSO

=cut
