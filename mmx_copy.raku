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
    my $single = $conf.mmx_single;

    loop {
	for @disks -> $d {
	    my $tmp_dir   = '/sd' ~ $d ~ '/' ~ "plots/";
	    my $host      = "localhost";
	    if ($single) {	    
	        say "single copy mode";
	        for dir($tmp_dir.IO.absolute) -> $pf {
		    # TODO: check f_dir wheather exist
		    if ($pf.IO.extension ~~ 'fpt') {
		       my $proc      = Proc::Async.new: 'chia_plot_copy', '-d', '-t', $host, '--', $pf;
		       say $proc;
		       my $promise   = $proc.start;	   
		       loop {
    	           	    put do given $promise.status {
			    	when Planned { "Still copying on $tmp_dir" } 
			    	when Kept    { last; }
	        	    	when Broken  { "Error!!!" }    
      	     	    	    }
	      	            sleep 1;      
	               }
		    }
		    say "no fpt file";
	        }
	    } else {
	      say "multi copy mode";
	      my $sf        = $tmp_dir ~ $conf.file_type;
	      say $sf;
	      qqx/chia_plot_copy -d -t $host -- $sf/;
	    }
	}
	sleep 1; 
    }
}
