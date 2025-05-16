#!/usr/bin/env rakudo

use lib 'lib';
use lib '.';
use plot;
use util;
use Conf;

sub MAIN($dirs)
{
    my $conf  = Conf.new;
    my $sname = "copy_" ~ $dirs; 
    my $log   = $conf.log_dir;
    qqx/tmux new -s $sname -d .\/mmx_copy.raku $dirs/;
    if ($conf.tmux_log) {
       say "clear copy log";
       qqx/rakudo backup.raku c/;
       say "loging for copy session $sname";
       if ($log.IO.e) {
           say "log dir $log";
       } else {
	   say "createing $log";
           $log.IO.mkdir;
       }
       qqx/tmux pipe-pane -t $sname "cat >> ~\/log\/copy.log"/;
    }
}
