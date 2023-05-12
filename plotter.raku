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
       	       put "dir: $d" ;
	       my $mount_dir = '/sd' ~ $d;
               my $f_dir = '/sd' ~ $d ~ '/' ~ 'plots/';
               my $t1 = '/sd' ~ $d ~ '/' ~ 't1/';
	       say  $f_dir;
	       say  $t1;
	       # TODO: check f_dir wheather exist
	       next if (get_size(get_part_size($mount_dir)) < get_size($conf.disk_avail));
	       my $proc = bb($f_dir, $t1, $conf.type, $conf.farmer_key, $conf.pool_key, $conf.pool_contract, $conf.media, $conf.bb_level, $conf.bb);
  	       my $promise = $proc.start;	   
               loop {
    	            put do given $promise.status {
      	         	 when Planned { "Still working on $f_dir" } # TODO send msg to message queue
	             	 when Kept    { $proc = bb($f_dir, $t1, $conf.type, $conf.farmer_key, $conf.pool_key, $conf.pool_contract, $conf.media, $conf.bb_level, $conf.bb); $promise = $proc.start }
	             	 when Broken  { "Error!!!" }    
      	     	    }
	      	    last if (get_size(get_part_size($mount_dir)) < get_size($conf.disk_avail));
	      	    sleep 1;      
	       }
       	  }
	  sleep 1; 
    }
}
