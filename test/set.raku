#!/usr/bin/env rakudo

use lib 'lib';
use plot;
use util;

sub MAIN($conf = "$*HOME/.chia/mainnet/config/config.yaml")
{
    set_farmer_peer($conf);
}

