#!/usr/bin/env rakudo
use lib "../lib";
use util;

sub MAIN($hs)
{
	my @all = parse_comma($hs);

	for @all -> $h {
	    say $h;
	    qqx/scp -r ~\/ca $h@$h:~\//;
	}
}