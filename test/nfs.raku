


use lib "../lib/";
use util;


sub MAIN($dirs)
{

    my $nfs_exports = "/etc/exports";
    my @disks =  parse_comma($dirs);

    for @disks -> $t {
    
	my $d = "/sd" ~ $t  ~ " *(rw,sync,no_root_squash)\n";

    	spurt $nfs_exports, $d, :append;
    }

    qqx/service  nfs-server restart/;
}