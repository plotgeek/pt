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
    loop {
    	 for @disks -> $d {
               my $tmp_dir   = '/sd' ~ $d ~ '/' ~ "plots/";
	       my $host      = "localhost";

	     for dir($tmp_dir.IO.absolute) -> $pf {
	       # TODO: check f_dir wheather exist
	       my $proc      = mmx_copy($host, $pf);
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
       	  }
	  sleep 1; 
    }
}
