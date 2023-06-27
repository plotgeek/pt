#!/usr/bin/env rakudo

use lib "../lib";
use util;

sub MAIN($cmd, $f = "./c8.txt")
{
	my $host = $f;
	for $host.IO.lines() -> $h {
	    say "-------- start host: $h --------";
	    if ($cmd.contains("sudo")) {
	      say qqx/ssh $h@$h "echo $h | $cmd"/;
	    } else {
	      say qqx/ssh  $h@$h $cmd/;
	    }
	    say "-------- end host: $h --------";
	}
}