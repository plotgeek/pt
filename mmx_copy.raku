#!/usr/bin/env rakudo

use lib 'lib';
use lib '.';
use plot;
use util;
use Conf;



sub MAIN($dirs) 
{
    my $conf  = Conf.new;	
    my @disks = parse_comma($dirs);
    my $copy  = $conf.mmx_copy;
    say $copy;

    loop {
        my @promises;
	for @disks -> $d {
	    my  $tmp_dir   = '/sd' ~ $d ~ '/' ~ "plots/";
	    my  $host      = "localhost";
	    my  $sf        = $tmp_dir ~ $conf.file_type;
	    say $sf;
            @promises.push: start {               
	        qqx/chia_plot_copy -d -t $host -- $sf/;
	    }
	}
	await @promises;
	sleep 1; 
    }
}
