#!/usr/local/bin/env raku


use lib 'lib';
use plot;
use util;


grammar Parser {
	rule TOP {<start><sep><end>}
	token sep { '-' }
	token start {\w+}
	token end {\w+}
}


sub MAIN($dirs, $op, $arg_3 = '9199c10ad809158231f81e00f3c4887119daa6706e683bda95dcc5bd8b19c618c4efcbb1a4ca1a94d7d94295a2718a2b', 
    		     $arg_4 = 'xch10shgem5afu0ft2rrsquwrs8qc07j987k6qne9vydcw990n6hldyq7vfyuj') 
{
    my @disks;
    if ($dirs.contains(',')) {	
       @disks = $dirs.chomp.split(',');
    } elsif ($dirs.contains('-')) {
       my $p     = Parser.parse: $dirs;
       my $start = $p<start>.chomp;
       my $sep   = $p<sep>.chomp;
       my $end   = $p<end>.chomp;

       if $start.contains('sd') {
	    $start = $start.substr(2, *);
       }
       if $end.contains('sd') {
	    $end = $end.substr(2, *);
       }

       @disks.push: $start;
       my $t = $start;
       loop {
	  $t = $t.succ;
	  @disks.push: $t;
	  last if ($t eq $end);
       }
    } else {
       @disks.push: $dirs;
    }


##########################################################################################
# misc ops 
##########################################################################################
    if ($op ~~ 'clean') {
        clean(@disks);
    } 
    if ($op ~~ 'count') {
        my $cnt = count(@disks);
	say @disks.elems  ~ " disks, total counts: $cnt";
    } 
    if ($op ~~ 'rmsys') {
        rmsys(@disks);
    }
    if ($op ~~ 'rmall') {
        my $n;
        if  (@*ARGS.elems != 3) {
	    $n = 2;
        } else {
            $n = $arg_3;
        }
        say "args: " ~ @*ARGS.elems;
        say "n:  " ~ $n;
	
        rmall(@disks,$n);
    }
    if ($op ~~ 'test') {
	if (@*ARGS.elems == 3) {
	   test(@disks, $arg_3)
	} elsif (@*ARGS.elems == 4) {
	   test(@disks, $arg_3, $arg_4);
	} else {
	   test(@disks);
	}
    }
    
##########################################################################################
# main ops 
##########################################################################################

    my $fs = 'xfs';

    if ($op ~~ 'stop') {
       for @disks -> $d {
       	   qqx/tmux kill-session -t $d /;
       }
    }
    if ($op ~~ 'add') {
       for @disks -> $d {
   	   my $t = '/sd' ~ $d ~ '/' ~ 'plots';
       	   put "plots dir: $t";
	   qqx/chia plots add -d $t/
       }
    }
    if ($op ~~ 'mount') {
       for @disks -> $d {
	   if ( @*ARGS.elems == 3) {
	      $fs = $arg_3;
	   } 
	   mount($d, $fs);
       }
    }
    if ($op ~~ 'format') {
       for @disks -> $d {
           if (@*ARGS.elems == 3) {
	      $fs = $arg_3;
	   }
           format($d, $fs);
       }
    }
}