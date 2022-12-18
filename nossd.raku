#!/usr/bin/env rakudo

use lib 'lib';
use lib ".";
use Conf;
use plot;
use util;

sub MAIN($dirs, $op = 'ms')
{
    my $conf  = Conf.new;
    say $conf.addr;
    say "dir: $dirs";
    my @disks = parse($dirs);
    my @tasks = @disks.rotor: $conf.num_of_spt_disks, :partial;
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
	   nossd($sname, $subpath, $conf.addr, $conf.mem_spt);
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
	   nossd($sname, $subpath, $conf.addr, $conf.mem_spt);
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
       nossd($sname, $path, $conf.addr,$conf.mem_spt);
    } elsif ($op ~~ 'fpt') {
       for @disks -> $d {
           put "dir: $d" ;
           my $f_dir = '/sd' ~ $d ~ '/' ~ 'plots ';
	   my $path = "-d,tf $f_dir";
	   my $sname = $op ~ '_' ~ $d;
	   my $mem = $conf.mem_fpt;
       	   qqx/tmux new -s $sname -d rakudo fpt.raku $d $mem/;
       }
    } elsif ($op ~~ 'harvester') {
       my $sname = $op ~ '_' ~ $dirs;
       for @disks -> $d {
           put "dir: $d" ;
           my $f_dir = '/sd' ~ $d ~ '/' ~ 'plots ';
	   $path = $path ~ "-d,r $f_dir";
	   #$sname = $sname ~ $d;
       }
       say "path : $path";
       say "sname：$sname";
       nossd($sname, $path, $conf.addr);
    } else {
       say "wrong op type $op";
    }
}
