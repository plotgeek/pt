#/usr/bin/env rakudo



grammar HOST {
    rule TOP { <pre><ind><host>}
    token ind {':'}
    token pre {<alpha>}
    token host {[<h><sep>*]+}
    token h {<digit>}
    token sep {'/'}
}

grammar SHOST {
    rule TOP {<start><sep><end>}
    token start {<pre><host>}
    token end {<pre><host>}
    token pre {<alpha>}
    token host {<digit>}
    token sep {'-'}
}



sub MAIN($host)
{
    my $p  = HOST.parse: $host;
    if ($p) {
	my $pre = $p<pre>.chomp;
	my $hs  = $p<host>;
	my $h   = $hs<h>.chomp;
	say $pre;
	for $h -> $t {
	    say $t;
	}
    }

    say "SHOST";
    my $sp = SHOST.parse: $host;
    if ($sp) {
	say "yes";
	my $start = $sp<start>;
	my $end   = $sp<end>;
	say $start<pre>.chomp;
	say $start<host>.chomp;
	say $end<pre>.chomp;
	say $end<host>.chomp;
    }
}
