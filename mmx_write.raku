#!/usr/bin/env rakudo

use lib 'lib';
use lib '.';
use plot;
use util;
use Conf;

sub MAIN($dirs) 
{
    my $conf   = Conf.new;	
    my @disks  = parse_comma($dirs);
    my $target = ""; 
    for @disks -> $d {
        my $tmp_dir   = '/sd' ~ $d ~ '/' ~ "plots/";
	$target = $target ~ "  " ~ $tmp_dir;
    }
    say $target;
    qqx/tmux new -s "mmx_write" -d chia_plot_sink $target/
}
