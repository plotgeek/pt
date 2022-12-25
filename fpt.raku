#!/usr/bin/env rakudo

use lib 'lib';
use lib '.';
use plot;
use util;
use Conf;

sub MAIN($d)
{
    my $conf    = Conf.new;
    say "f_threads:" ~ $conf.f_threads;       
    my $sname   = 'fpt_' ~ $d;
    my $f_dir   = '/sd' ~ $d ~ '/plots';
    my $path    = "$f_dir";
    my $proc    = nossd_fpt($sname, $path, $conf.mem_fpt, $conf.f_threads, $conf.m_threads);
    my $promise = $proc.start;

    loop {
        put do given $promise.status {
            when Planned { "Planned " }
            when Kept    { $proc = nossd_fpt($sname, $path, $conf.mem_fpt, $conf.f_threads, $conf.m_threads); $promise = $proc.start;}
            #when Kept   { "Kept" }
            when Broken  {"Error !!!"}
        }
        sleep 1;
    }
}
