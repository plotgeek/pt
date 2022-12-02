#!/usr/bin/env rakudo


use lib 'lib';
use plot;
use util;


sub MAIN($dirs, $op, $arg_3 = '9199c10ad809158231f81e00f3c4887119daa6706e683bda95dcc5bd8b19c618c4efcbb1a4ca1a94d7d94295a2718a2b', 
    		     $arg_4 = 'xch10shgem5afu0ft2rrsquwrs8qc07j987k6qne9vydcw990n6hldyq7vfyuj') 
{
    my @disks;
    @disks = parse($dirs);


##########################################################################################
# misc ops 
##########################################################################################
    if ($op ~~ 'clean') {
        clean(@disks);
    } 
    if ($op ~~ 'count') {
        my $cnt = 0;
        if (@*ARGS.elems == 2) {
           $cnt = count(@disks, 'plot');
	   say @disks.elems  ~ " disks, total : $cnt plots";
	}
	if (@*ARGS.elems == 3) {
	   my $ft = $arg_3;
	   if ($arg_3 ~~ 'plot') {
	      $cnt = count(@disks, 'plot');
	   }
	   if ($arg_3 ~~ 'spt') {
	      $cnt = count(@disks, 'spt');      
	   }
	   if ($arg_3 ~~ 'fpt') {
	      $cnt = count(@disks, 'fpt')
	   }
	   say @disks.elems  ~ " disks, total $arg_3: $cnt ";
	}
    } 
    if ($op ~~ 'rmsys') {
        rmsys(@disks);
    }
    if ($op ~~ 'rm') {
        my $n;
        if  (@*ARGS.elems != 3) {
	    $n = 2;
        } else {
            $n = $arg_3;
        }
        say "args: " ~ @*ARGS.elems;
        say "n:  " ~ $n;
	
        rm(@disks,$n);
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