#!/usr/bin/env rakudo

use lib '../lib';
use util;

grammar NFS {
	rule TOP {<host><space><sep><space><ip><space><sep><space><devs>}
	token sep  {':'}
	token host {\w+}
	token ip   {\d+<dot>\d+<dot>\d+<dot>\d+}
	token dot  {'.'}	      
	token devs {.*}
	token space{\s*}
}

grammar COMMENT {
	rule TOP      {<start><space><comment>}
	token start   {^'#'}
	token space   {\s*}
	token comment {.*}
}



sub MAIN($conf)
{
	my $fh = $conf.IO.open :rw;

	for $fh.lines -> $l {

	    # omit comment
	    my $c = COMMENT.parse($l);
	    my $s = $c<start>;
	    if ($s ~~ '#') {
	        next;
	    }

	    # parse hostname
	    # parse ip
	    # parse devs
	    my $m =  NFS.parse($l);
	    #say $m.raku;
	    my $sep = $m<sep>[0];
	    if ($sep ~~ ':') {
		my $host     =  $m<host>;
		my $ip       =  $m<ip>;
		my $devs     =  $m<devs>;
		#my @disks    =  parse_comma($devs);
		say "$host, $ip, $devs";
		say "mounting $host@$ip:$devs";
		#qqx/sudo rakudo ../pt $devs mount nfs $ip $host/;
		say "adding plots dir: $devs";
		#qqx/rakudo ../pt $devs add mmx $host/;
	    }
        }
	
	close $fh;
}
