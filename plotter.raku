#!/usr/bin/env rakudo

use lib 'lib';
use plot;
use util;

sub MAIN($dirs, $op = 'create', 
         $f = '9199c10ad809158231f81e00f3c4887119daa6706e683bda95dcc5bd8b19c618c4efcbb1a4ca1a94d7d94295a2718a2b', 
         $pub = 'xch10shgem5afu0ft2rrsquwrs8qc07j987k6qne9vydcw990n6hldyq7vfyuj') 
{
    my @disks = parse($dirs);

    if ($op ~~ 'create') { 
       loop {
       	   for @disks -> $d {
       	       put "dir: $d" ;
	       my $w = '/sd' ~ $d;
               my $f_dir = '/sd' ~ $d ~ '/' ~ 'plots/';
	       # TODO: check f_dir wheather exist
	       next if (get_num($f_dir) > 8);
	       my $proc = plotter($f_dir, $d, $f, $pub);
  	       my $promise = $proc.start;	   
               loop {
    	            put do given $promise.status {
      	         	 when Planned { "Still working on $f_dir" } # TODO send msg to message queue
	             	 when Kept    { $proc = plotter($f_dir, $d, $f, $pub); $promise = $proc.start }
	             	 when Broken  { "Error!!!" }    
      	     	    }
	      	    last if (get_num($f_dir) > 9);
	      	    sleep 1;      
	       }
       	   }
	   sleep 1; 
       }
     }
}
