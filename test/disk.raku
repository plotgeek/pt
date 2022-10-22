#!/usr/bin/env raku

say @*ARGS[0];

sub get_part_size($dev) 
{
    for lines(qqx/df -h $dev/) -> $l {
	if $l ~~ /^\/dev/ {
            my @p = $l.split(/\s+/);
            return @p[1];
        }
    }
}

my $disk_part = @*ARGS[0];
if ($disk_part) {
   say get_part_size($disk_part);
}




