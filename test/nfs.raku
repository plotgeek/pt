#!/usr/bin/env rakudo
use lib "../lib/";
use lib "../";
use util;
use Conf;


sub get_pf()
{
    my $conf = Conf.new;
    my $nfs_conf = $conf.nfs_conf;
    my $prefix  = $conf.mount_prefix;
    my @pf      = parse_comma($prefix);
    #say @pf;

    if ($nfs_conf.IO !~~ :e) {
	say "$nfs_conf do not exist,please check it";
	exit(0);
    }
    say "\nusing conf: $nfs_conf\n";
    my $fh = $nfs_conf.IO.open :rw;

    for $fh.lines -> $l {
	next if $l.starts-with('#');
	my ($host,$ip,$devs) = $l.split(':');
	@pf.push($host);
    }
    return @pf.unique;
}

sub MAIN()
{
    my @pf = get_pf();	
    say @pf;
}