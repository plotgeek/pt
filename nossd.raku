#!/usr/bin/env rakudo

use lib 'lib';
use lib '.';
use conf;
use plot;
use util;

sub MAIN($dirs, $op = 'ms')
{
    say $addr;
    my @disks = parse($dirs);
    my @tasks = @disks.rotor: $spt_disks, :partial;
    my $path  = "";

    if ($op ~~ 'ms') {
       for @tasks -> @s {
       	   my $subpath = "";
	   my $sname = $op ~ '_';
	   for @s -> $t {
	       my $f_dir = '/sd' ~ $t ~ '/' ~ 'plots';
	       $subpath = $subpath ~ "-d,ts $f_dir ";
	       $sname = $sname ~ $t;
	   }
	   say "path : $subpath";
	   nossd($sname, $subpath, $addr, $mem_spt);
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
	   nossd($sname, $subpath, $addr, $mem_spt);
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
       nossd($sname, $path, $addr,$mem_spt);
    } elsif ($op ~~ 'fpt') {
       for @disks -> $d {
           put "dir: $d" ;
           my $f_dir = '/sd' ~ $d ~ '/' ~ 'plots ';
	   my $path = "-d,tf $f_dir";
	   my $sname = $op ~ '_' ~ $d;
       	   qqx/tmux new -s $sname -d rakudo fpt.raku $d $mem_fpt/;
       }
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
