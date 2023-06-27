#!/usr/bin/env rakudo
use lib "../lib";
use util;

sub MAIN($h="h.txt")
{
	my $host = "./h.txt";

	for $host.IO.lines() -> $h {
	    say $h;
	    qqx/ssh-copy-id $h@$h/;
	}
}