#!/usr/bin/env rakudo

use lib "../lib";
use util;

sub MAIN($dirs)
{
    say "hello";
    my @disks;
    @disks = parse_comma($dirs);
    for @disks -> $d {
	my $dev = '/dev/sd' ~ $d;
	say $dev;
	say "repairing ";
	qqx/sudo xfs_repair -L $dev/;
	say "new uuid";
	qqx/sudo xfs_admin -U generate $dev/;
    }
}
