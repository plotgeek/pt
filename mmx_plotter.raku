#!/usr/bin/env rakudo

use lib 'lib';
use lib '.';
use plot;
use util;
use Conf;

sub MAIN($dirs) 
{
    my $conf  = Conf.new;	
    my @disks = parse($dirs);
    loop {
    	 for @disks -> $d {
       	       #put "dir: $d" ;
	       my $mount_dir = '/sd' ~ $d;
               my $f_dir = '/sd' ~ $d ~ '/' ~ 'plots/';
               my $tmp_dir = '/sd' ~ $d ~ '/' ~ 't1/';
	       # TODO: check f_dir wheather exist
	       #next if (get_size(get_part_size($mount_dir)) < get_size($conf.disk_avail));
	       my $proc = mmx($d, $conf.mmx_level, $conf.type, $conf.farmer_key, $conf.pool_key, $conf.pool_contract);
  	       my $promise = $proc.start;	   
               loop {
    	            put do given $promise.status {
      	         	 when Planned { "Still plotting on $tmp_dir" } # TODO send msg to message queue
	             	 when Kept    { $proc = mmx($d, $conf.mmx_level, $conf.type, $conf.farmer_key, $conf.pool_key, $conf.pool_contract); $promise = $proc.start }
	             	 when Broken  { "Error!!!" }    
      	     	    }
	      	    #last if (get_size(get_part_size($mount_dir)) < get_size($conf.disk_avail));
	      	    sleep 1;      
	       }
       	  }
	  sleep 1; 
    }
}
