#!/usr/bin/env rakudo

use lib 'lib';
use lib '.';
use plot;
use util;
use Conf;

sub MAIN($dirs, $src_dir = "nv0")
{
    my $conf   = Conf.new;	
    my $prefix = $conf.mount_prefix;
    my $plots_dir = $conf.plots_dir;
    #my $file_type = $conf.file_type;
    my $sink   = $conf.mmx_sink;
    say $prefix;
    say $plots_dir;
    my @disks  = parse_comma($dirs);
    my $target = ""; 
    my $log    = $*HOME ~ "/log";
    for @disks -> $d {
	my $tmp_dir   = $prefix ~ '/sd' ~ $d ~ '/' ~ $plots_dir;
	if ($tmp_dir.IO ~~ :e) {
	    $target = $target ~ "  " ~ $tmp_dir;
	} else {
	    say "$tmp_dir dosen't exist, need to create!!";
	}
    }
    say $target;
    my $sname = "write_" ~ $dirs; 
    qqx/tmux new -s $sname -d $sink $target/;
    if ($conf.tmux_log) {
       say "clear write log";
       qqx/rakudo backup.raku w/;
       say "loging for write session $sname";
       if ($log.IO.e) {
           say "log dir $log";
       } else {
	   say "createing $log";
           $log.IO.mkdir;
       }
       qqx/tmux pipe-pane -t $sname "cat >> ~\/log\/write.log"/;
    }

    say "start copy plot file from $src_dir";
    qqx/rakudo copy.raku $src_dir/;
}
