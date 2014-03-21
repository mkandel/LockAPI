package LockAPI::Client;
use YAML::Syck;
use FindBin;
use Carp;

sub new {
    my $class = shift;
    my $self = shift || {};
    my $conf_file = "$FindBin::Bin/../config";

    if ( -e "$conf_file/locker.cfg" ){
        $self->{ 'conf_file' } = "$conf_file/lockapi.cfg";
        print "Setting conf_file to '$conf_file/lockapi.cfg'\n" if $self->{ 'debug' };;
    } else {
        croak "new: cannot find config file ...\n";
    }

    bless $self, $class;

    $self->{ 'conf' } = $self->load_config();

    return $self;
}

sub load_config {
    my $self = shift;
    #my $conf_dir = "$FindBin::Bin/../config";
    my $conf_file = $self->{'conf_file'} || croak "load_config: config_file is a mandatory argument!\n";

    my $conf;

    if ( -e $conf_file ){
        $conf = LoadFile( $conf_file ) || croak "ERROR: loading '$conf_file': $!\n";
    } else {
        croak __PACKAGE__,"::load_config: config_file '$conf_file' does not exist!\n";
    }

     return $conf;
}


1;
