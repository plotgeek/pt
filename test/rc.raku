#!/usr/bin/env rakudo

use lib "../lib";
use util;

sub MAIN($hs, $cmd)
{
	my @all = parse_comma($hs);

	for @all -> $h {
	    say "-------- start host: $h --------";
	    if ($cmd.contains("sudo")) {
	      say qqx/ssh $h@$h "echo $h | $cmd"/;
	    } else {
	      say qqx/ssh  $h@$h $cmd/;
	    }
	    say "-------- end host: $h --------";
	}
}