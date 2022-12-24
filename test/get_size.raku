#!/usr/bin/env rakudo

use lib '../lib';
use lib '..';
use util;
use Conf;


my $conf  = Conf.new;
my $avail = get_part_size("/dev/sda2");
say $avail;
if (get_size($avail) > get_size($conf.disk_avail)) {
   say "yes";
}