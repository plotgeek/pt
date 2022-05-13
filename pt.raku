#!/usr/bin/env rakudo

use lib 'lib';
use plot;
use util;


grammar Parser {
	rule TOP {<start><sep><end>}
	token sep { '-' }
	token start {\w+}
	token end {\w+}
}


sub MAIN($dirs, $op, 
         $farmer_pk = '9199c10ad809158231f81e00f3c4887119daa6706e683bda95dcc5bd8b19c618c4efcbb1a4ca1a94d7d94295a2718a2b', 
         $pool_pk_or_contract_addr = 'xch10shgem5afu0ft2rrsquwrs8qc07j987k6qne9vydcw990n6hldyq7vfyuj') 
{
    my @disks = $dirs.chomp.split(',');
    my @tasks;


    if ($op ~~ 'clean') {
         clean(@disks);
	 exit(0);
    } 

    if ($op ~~ 'rmsys') {
       rmsys(@disks);
       exit(0);
    }
    
    if ($op ~~ 'rmall') {
        my $n;
        if  (@*ARGS.elems != 3) {
	    $n = 2;
        } else {
            $n = @*ARGS[2];
        }
        say "args: " ~ @*ARGS.elems;
        say "n:  " ~ $n;
	
        rmall(@disks,$n);
        exit(0);
    }

    if @disks.contains('-') {
	my $p = Parser.parse: @disks;
	my $start = $p<start>.chomp;
	my $sep = $p<sep>.chomp;
	my $end = $p<end>.chomp;

	if $start.contains('sd') {
	    $start = $start.substr(2, *);
	}
	if $end.contains('sd') {
	    $end = $end.substr(2, *);
	}

	say "Start: $start, End: $end";
	my $d = $start;
	loop {
	    if ($op ~~ 'create') {
                my $w = '/sd' ~ $d;
                put "farmer: $farmer_pk";
                put "poolpk or contract addr:   $pool_pk_or_contract_addr";

		qqx/tmux new -s $d -d rakudo .\/ploter.raku $d 'create' $farmer_pk $pool_pk_or_contract_addr/;
	    }
	    if ($op ~~ 'stop') {
		qqx/screen -S $d -X quit/;
	    }
	    if ($op ~~ 'add') {
		my $t = '/sd' ~ $d ~ '/' ~ 'plots';
		put "plots dir: $t";
		qqx/chia plots add -d $t/
	    }
	    if ($op ~~ 'mount') {
		my $t = '/dev/sd' ~ $d;
		mount($d);
	    }
	    if ($op ~~ 'format') {
	       format($d);
	    }


	    $d = $d.succ;
	    last if ($d eq $end);
	    LAST {
		if ($op ~~ 'create') {
                    my $w = '/sd' ~ $d;
                    put "farmer: $farmer_pk";
                    put "poolpk or contract addr:   $pool_pk_or_contract_addr";

		    qqx/tmux new -s $d -d rakudo .\/ploter.raku $d 'create' $farmer_pk $pool_pk_or_contract_addr/;
		}
		if ($op ~~ 'stop') {
		    qqx/screen -S $d -X quit/;
		}
		if ($op ~~ 'add') {
		    my $t = '/sd' ~ $d ~ '/' ~ 'plots';
		    put "plots dir: $t";
		    qqx/chia plots add -d $t/
		}
		if ($op ~~ 'mount') {
		    my $t = '/dev/sd' ~ $d;
		    mount($d);
		}
		if ($op ~~ 'format') {
	       	   format($d);
	    	}
	    }
	}
	exit(0);
    }

    if (@disks.elems == 1) {
	my $d = @disks;

	if $d.contains('sd') {
	    $d = $d.substr(2, *);
	}

	if ($op ~~ 'stop') {
	    qqx/screen -S $d -X quit/;
	}
	if ($op ~~ 'add') {
	    my $t = '/sd' ~ $d ~ '/' ~ 'plots';
	    put "plots dir: $t";
	    if $t.contains('sda') && $t.chars == 3 {
		put "home dir: " ~ $*HOME;
		$t = $*HOME ~ '/' ~ 'plots';
	    }
	    qqx/chia plots add -d $t/;
	}
	if ($op ~~ 'mount') {
	    my $t = '/dev/sd' ~ $d;
	    mount($d);
	}
	if ($op ~~ 'format') {
       	   format($d);
    	}

	if ($op ~~ 'create') {
	    put "farmer: $farmer_pk";
            put "poolpk or contract addr:   $pool_pk_or_contract_addr";
	    qqx/tmux new -s $d -d rakudo .\/ploter.raku $d 'create' $farmer_pk $pool_pk_or_contract_addr/;
	}

	exit(0);
    }
}
