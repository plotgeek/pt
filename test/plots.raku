#!/usr/bin/env rakudo

use lib '../lib';
use util;

grammar DEVS {
	rule TOP {<start><sep><end>}
	token sep   { '-' }
	token start {\w+}
	token end   {\w+}
}
grammar NFS {
	rule TOP {<host><space><sep><space><ip><space><sep><space><devs>}
	token sep  {':'}
	token host {\w+}
	token ip   {\d+<dot>\d+<dot>\d+<dot>\d+}
	token dot  {'.'}	      
	token devs {.*}
	token space{\s*}
}



sub MAIN($conf)
{
	my $fh = $conf.IO.open :rw;

	for $fh.lines -> $l {

	    # omit comment
	    # parse hostname
	    # parse ip
	    # parse devs

	    my $m =  NFS.parse($l);
	    #say $m.raku;

	    my $host     =  $m<host>;
	    my $ip       =  $m<ip>;
	    my $devs =  $m<devs>;
	    my @disks    =  parse_comma($devs);
	    say "$host, $ip";
        }

	close $fh;
}