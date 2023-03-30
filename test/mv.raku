#!/usr/bin/env rakudo
use lib "../lib/";
use util;


sub MAIN($dirs)
{
	my @disks;
	@disks = parse_comma($dirs);
	for @disks -> $d {
	    my $f = '/sd' ~ $d ~ '/' ~ '/plots/*';
	    my $t = '/sd' ~ $d ~ '/'; 
	    say "mving $f to $t";
	    qqx/mv $f $t/;
	}
}