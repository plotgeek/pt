#!/usr/bin/env rakudo

use lib 'lib';
use plot;
use util;

sub MAIN($dirs, $op = 'create', 
         $f = 'b8184ebe49924b2065f77e13069862f1b663eb4be1b9fa0a2ed1266554511db84c19e4f31d604792a60be96076d75b88', 
         $pub = '85af06071c2131ca44e64d9a53392c88981e05e80fce246267abc2b3eb7ae5e16e0961d0a413b29728776c55ebcab568') 
{
    my @disks = $dirs.chomp.split(',');
    my @tasks;

    if ($op ~~ 'create') { 
       for @disks -> $d {
       	 put "dir: $d" ;
	 my $w = '/sd' ~ $d;
         if get_part_size($w).substr(0, *-1) < 100 {
             say "no enough space at " ~ $w;
             exit(0);
         }
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
