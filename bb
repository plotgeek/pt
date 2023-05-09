#!/usr/bin/env rakudo

use lib 'lib';
use lib '.';
use plot;
use util;
use Conf;

sub MAIN($dirs) 
{
    say "$dirs";
    my $sname = "bb_" ~ $dirs;
    qqx/tmux new -s $sname -d rakudo plotter.raku $dirs /;
}
