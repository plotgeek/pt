#!/usr/bin/env rakudo

use lib "../lib";
use util;

sub MAIN($dirs)
{
    say "hello";
    my @disks;
    @disks = parse_comma($dirs);
    @disks = @disks (|) @disks;
    for @disks -> $d {
	my $plots_dir = '/sd' ~ $d ~ '/' ~ 'plots';
	if ($plots_dir.IO ~~ :e) {
	   say "dir: $d";
	}
    }
}
