#!/usr/bin/env rakudo

use lib 'lib';
use lib '.';
use plot;
use util;
use Conf;

sub MAIN($dirs) 
{
    say "$dirs";
    qqx/tmux new -s $dirs -d rakudo plotter.raku $dirs /;
}
