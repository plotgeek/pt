
use lib "../lib";
use util;

sub MAIN($hs)
{
	my @all = parse_comma($hs);

	for @all -> $h {
	    qqx/ssh-copy-id $h@$h/;
	}
}