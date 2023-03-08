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
	if ($tmp_dir.IO ~~ :e) {
	   $target = $target ~ "  " ~ $tmp_dir;
	} else {
	   say "$tmp_dir dosen't exist, need to create!!";
	}
    }
    say $target;
    my $sname = "mmx_write_" ~ $dirs;
    qqx/tmux new -s $sname -d chia_plot_sink $target/;
}
