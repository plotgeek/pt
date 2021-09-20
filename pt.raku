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


sub MAIN($dirs, $op = 'create', 
         $farmer_pk = 'b8184ebe49924b2065f77e13069862f1b663eb4be1b9fa0a2ed1266554511db84c19e4f31d604792a60be96076d75b88', 
         $pool_pk_or_contract_addr = '85af06071c2131ca44e64d9a53392c88981e05e80fce246267abc2b3eb7ae5e16e0961d0a413b29728776c55ebcab568') 
{
    my @disks = $dirs.chomp.split(',');
    my @tasks;


    if ($op ~~ 'clean') {
         clean(@disks);
	 exit(0);
    } 

    if ($op ~~ 'format') {
       format(@disks);        
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
	        put "farmer: $farmer_pk";
                put "poolpk or contract addr:   $pool_pk_or_contract_addr";
		qqx/screen -S $d -d -m rakudo .\/ploter.raku $d 'create' $farmer_pk $pool_pk_or_contract_addr/;
	    }
	    if ($op ~~ 'stop') {
		qqx/screen -S $d -X quit/;
	    }
	    if ($op ~~ 'add') {
		my $t = '/' ~ $d ~ '/' ~ 'plots';
		put "plots dir: $t";
		if $d.contains('sda') && $d.chars == 3 {
		    put "home dir: " ~ $*HOME;
		    $t = $*HOME ~ '/' ~ 'plots';
		}
		qqx/chia plots add -d $t/
	    }

	    $d = $d.succ;
	    last if ($d eq $end);
	    LAST {
		if ($op ~~ 'create') {
		    put "farmer: $farmer_pk";
                    put "poolpk or contract addr:   $pool_pk_or_contract_addr";
		    qqx/screen -S $d -d -m rakudo .\/ploter.raku $d 'create' $farmer_pk $pool_pk_or_contract_addr/;
		}
		if ($op ~~ 'stop') {
		    qqx/screen -S $d -X quit/;
		}
		if ($op ~~ 'add') {
		    my $t = '/' ~ $d ~ '/' ~ 'plots';
		    put "plots dir: $t";
		    if $d.contains('sda') && $d.chars == 3 {
			put "home dir: " ~ $*HOME;
			$t = $*HOME ~ '/' ~ 'plots';
		    }
		    qqx/chia plots add -d $t/
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

	if ($op ~~ 'create') {
	    put "farmer: $farmer_pk";
            put "poolpk or contract addr:   $pool_pk_or_contract_addr";
	    qqx/screen -S $d -d -m rakudo .\/ploter.raku $d 'create' $farmer_pk $pool_pk_or_contract_addr/;
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
    }

}
