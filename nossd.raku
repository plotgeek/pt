#!/usr/bin/env rakudo

use lib 'lib';
use plot;
use util;

sub MAIN($dirs, 
    	 $op = 'sf', 
	 $addr = 'xch1xy4kmhd6avkde5z0h67mefzgakeq9ahnj802tuxjluq7prj9rhjqre2cjj')
{
    my @disks = parse($dirs);
    my @tasks = @disks.rotor: 3, :partial;
    my $path = "";

    if ($op ~~ 'mf') {
       for @tasks -> @s {
       	   my $subpath = "";
	   my $sname = $op ~ '_';
	   for @s -> $t {
	       my $f_dir = '/sd' ~ $t ~ '/' ~ 'plots';
	       $subpath = $subpath ~ "-d,tf $f_dir ";
	       $sname = $sname ~ $t;
	   }
	   say "path : $subpath";
	   nossd($sname, $subpath, $addr);
       }   
    } elsif ($op ~~ 'ms') {
       for @tasks -> @s {
       	   my $subpath = "";
	   my $sname = $op ~ '_';
	   for @s -> $t {
	       my $f_dir = '/sd' ~ $t ~ '/' ~ 'plots';
	       $subpath = $subpath ~ "-d,ts $f_dir ";
	       $sname = $sname ~ $t;
	   }
	   say "path : $subpath";
	   nossd($sname, $subpath, $addr);
       }   
    } elsif ($op ~~ 'sf') {
       for @tasks -> @s {
       	   my $subpath = "";
	   my $sname = $op ~ '_';
	   for @s -> $t {
	       my $f_dir = '/sd' ~ $t ~ '/' ~ 'plots';
	       $subpath = $subpath ~ "-d $f_dir ";
	       $sname = $sname ~ $t;
	   }
	   say "path : $subpath";
	   nossd($sname, $subpath, $addr);
       }   
    } elsif ($op ~~ 'spt') {
       my $sname = $op ~ '_';
       for @disks -> $d {
           put "dir: $d" ;
           my $f_dir = '/sd' ~ $d ~ '/' ~ 'plots ';
	   $path = $path ~ "-d,ts $f_dir";
	   $sname = $sname ~ $d;
       }
       say "path : $path";
       nossd($sname, $path, $addr);
    } elsif ($op ~~ 'fpt') {
       my $sname = $op ~ '_';
       for @disks -> $d {
           put "dir: $d" ;
           my $f_dir = '/sd' ~ $d ~ '/' ~ 'plots ';
	   $path = $path ~ "-d,tf $f_dir";
	   $sname = $sname ~ $d;
       }
       say "path : $path";
       nossd($sname, $path, $addr);	
    } elsif ($op ~~ 'harvester') {
       my $sname = $op ~ '_';
       for @disks -> $d {
           put "dir: $d" ;
           my $f_dir = '/sd' ~ $d ~ '/' ~ 'plots ';
	   $path = $path ~ "-d,r $f_dir";
	   $sname = $sname ~ $d;
       }
       say "path : $path";
       nossd($sname, $path, $addr);
    } else {
       say "wrong op type $op";
    }
}
