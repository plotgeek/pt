#!/usr/bin/env rakudo
use lib "../lib/";
use util;


sub MAIN($dirs)
{
    my @disks = parse_comma($dirs);
    my $nfs_exports = "/etc/exports";

    for @disks -> $t {
	my $d = "/sd" ~ $t  ~ " *(rw,async,no_root_squash)";
        for $nfs_exports.IO.lines() -> $l {
	    next if ($l ~~ $d);
	    last {
	       say $d;	       
	       #spurt $nfs_exports, $d, :append;
	    }
	}
    }

    #qqx/service  nfs-server restart/;
}