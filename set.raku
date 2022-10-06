#!/usr/bin/env rakudo

use lib 'lib';
use plot;
use util;

sub MAIN($conf)
{
    set_farmer_peer($conf);
}

