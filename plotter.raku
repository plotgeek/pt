#!/usr/bin/env rakudo

use lib 'lib';
use plot;
use util;

sub MAIN($dirs, $op = 'create', 
         $f = '9199c10ad809158231f81e00f3c4887119daa6706e683bda95dcc5bd8b19c618c4efcbb1a4ca1a94d7d94295a2718a2b', 
         $pub = 'xch10shgem5afu0ft2rrsquwrs8qc07j987k6qne9vydcw990n6hldyq7vfyuj') 
{
    my @disks = $dirs.chomp.split(',');
    my @tasks;

    if ($op ~~ 'create') { 
       for @disks -> $d {
       	 put "dir: $d" ;
	 my $w = '/sd' ~ $d;
         my $t1     = '/sd' ~ $d ~ '/' ~ 't1/';
         my $t2     = '/sd' ~ $d ~ '/' ~ 't2/';
         my $f_dir = '/sd' ~ $d ~ '/' ~ 'plots/';
         if ($d eq 'sda') {
       	   put "home dir: " ~ $*HOME;
	   $t1 = $*HOME ~ '/' ~ 't1/';
	   $t2 = $*HOME ~ '/' ~ 't2/';
	   $f_dir = $*HOME ~ '/' ~ 'plots/';
         }
         my $p = ploter($t1, $t2, $f_dir, $d, $f, $pub);
         @tasks.push: $p;
       }
    
       loop {
    	 my $n_t = @tasks.elems;
	 my $i = 0;
	 while ($i < $n_t) {
	    my $t  = @tasks[$i];
    	    put "{$n_t}, {$t.key}  = > {$t.value}";

	    my $d     =  $t.key;
	    my $p     =  $t.value;
	    my $t1    = '/sd' ~ $d ~ '/' ~ 't1/';
            my $t2    = '/sd' ~ $d ~ '/' ~ 't2/';
            my $f_dir = '/sd' ~ $d ~ '/' ~ 'plots/';
	    if $d ~~ /sda/ {
       	      put "home dir: " ~ $*HOME;
	      $t1 = $*HOME ~ '/' ~ 't1/';
	      $t2 = $*HOME ~ '/' ~ 't2/';
	      $f_dir = $*HOME ~ '/' ~ 'plots/';
            }

	    put do given $p.status {
	       when Planned { "Still working on it" }
	       when Kept    { @tasks[$i] = ploter($t1, $t2, $f_dir, $d, $f, $pub) }
	       when Broken  { "Error!!!" }    
	    }
	    $i++;
	}
	sleep 5;
       }
     }
}
