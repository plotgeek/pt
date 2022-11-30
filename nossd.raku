#!/usr/bin/env rakudo

use lib 'lib';
use plot;
use util;

sub MAIN($dirs, 
    	 $op = 'spt', 
	 $addr = 'xch1xy4kmhd6avkde5z0h67mefzgakeq9ahnj802tuxjluq7prj9rhjqre2cjj')
{
    my @disks = parse($dirs);
    my $path = "";

    if ($op ~~ 'spt') {
       for @disks -> $d {
           put "dir: $d" ;
           my $f_dir = '/sd' ~ $d ~ '/' ~ 'plots ';
	   $path = $path ~ "-d,ts $f_dir";
       }
       say "path : $path";
    } elsif ($op ~~ 'fpt') {
       for @disks -> $d {
           put "dir: $d" ;
           my $f_dir = '/sd' ~ $d ~ '/' ~ 'plots ';
	   $path = $path ~ "-d,tf $f_dir";
       }
       say "path : $path";
    } elsif ($op ~~ 'harvester') {
       for @disks -> $d {
           put "dir: $d" ;
           my $f_dir = '/sd' ~ $d ~ '/' ~ 'plots ';
	   $path = $path ~ "-d,r $f_dir";
       }
       say "path : $path";
    } else {
       say "wrong op type $op";
    }

    nossd($op, $path, $addr);
}
