#!/usr/bin/env rakudo

use lib 'lib';
use plot;
use util;


sub MAIN($d, $mem = '8G')
{

    my $sname   = 'fpt_' ~ $d;
    my $f_dir   = '/sd' ~ $d ~ '/plots';
    my $path    = "$f_dir";
    my $proc    = nossd_fpt($sname, $path, $mem);
    my $promise = $proc.start;

    loop {
        put do given $promise.status {
            when Planned { "Planned " }
            when Kept    { $proc = nossd_fpt($sname, $path, $mem); $promise = $proc.start;}
            #when Kept   { "Kept" }
            when Broken  {"Error !!!"}
        }
        sleep 1;
    }
}