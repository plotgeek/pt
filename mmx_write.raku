#!/usr/bin/env rakudo

use lib 'lib';
use lib '.';
use plot;
use util;
use Conf;

sub MAIN($dirs) 
{
    my $conf   = Conf.new;	
    my @disks  = parse($dirs);
    my $target = ""; 
    for @disks -> $d {
        my $tmp_dir   = '/sd' ~ $d ~ '/' ~ "plots/";
	$target = $target ~ "  " ~ $tmp_dir;
    }
    say $target;
}
