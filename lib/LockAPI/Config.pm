package LockAPI::Config;
use YAML::Syck;
use FindBin;
use Carp;

sub new {
    my $class = shift;
    my $attrs = shift || {};
    my $conf_dir;

    my $self;

    print "Checking for '$ENV{HOME}/.lockapirc'\n" if $self->{ 'debug' };
    if ( -e "$ENV{HOME}/.lockapirc" ){
        ## Developer convenience :P
        $self->{ 'conf_file' } = "$ENV{HOME}/.lockapirc";
        print "Setting conf_file to '$ENV{HOME}/.lockapirc'\n" if $self->{ 'debug' };
    } elsif ( -e "$FindBin::Bin/../config/lockapi.cfg" ){
        ## In a build tree/deploy
        $self->{ 'conf_file' } = "$FindBin::Bin/../config/lockapi.cfg";
        print "Setting conf_file to '$FindBin::Bin/../config/lockapi.cfg'\n" if $self->{ 'debug' };
    } else {
        croak "new: cannot find config file ...\n";
    }

    bless $self, $class;

    my $conf = $self->load_config( $self->{ 'conf_file' } );
    $self->{ 'conf' } = $conf;

    ## Set the fields and the rules the values must comply with
    $self->{ 'fields' } = {
        'server'       => '^\w+$',
        'port'         => '^[0-9]+$',
        'api_version'  => '^\w+$',
        'log_dir'      => '',
        'db_path'      => '',
        'debug'        => '\d+',
    };
    ## Automatic getter/setter creation
    ## Use for simple get_foo set_foo creation
    while ( my ( $field, $rule ) = each %{ $self->{ 'fields' } } ) {
        no warnings 'redefine';
        no strict 'refs';

        my $func = __PACKAGE__ . "::" . $field;
        print "creating $func()\n" if $self->{'debug'};
        *$func = sub {
            my $self = shift;
            my $val  = shift;
            print "Entered '$func'\n" if $self->{'debug'};
            print " with value '$val'\n" if ( $val && $self->{ 'debug' } );
#            if ( not defined $val ) {
#                confess "Cannot set field '$field' with undef!";
#            }

            ## Check against regex rule
            if ( $val ){
                if ( $val =~ /$rule/ ) {
                    print "Setting '$field' to '$val'\n";
                    $self->{ $field } = $val;
                } else {
                    confess "Cannot set field '$field' with value '$val', does not conform with rule '$self->{fields}{$field}'.";
                }
            }
            return $self->{ 'conf' }->{ $field };
        };
    }

    ## Add passed in arguments to $self:
    foreach my $attr ( keys %{ $attrs } ){
        $self->$attr( $attrs->{ $attr } );
    }

    return $self;
}

sub load_config {
    my $self = shift;
    #my $conf_dir = "$FindBin::Bin/../config";
    my $conf_file = shift || croak "load_config: config_file is a mandatory argument!\n";

    my $conf;

    if ( -e $conf_file ){
        $conf = LoadFile( $conf_file ) || croak "ERROR: loading '$conf_file': $!\n";
    } else {
        croak "load_config: config_file '$conf_file' does not exist!\n";
    }

     return $conf;
}


1;
