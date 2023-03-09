#!/usr/bin/rakudo

my $fh = "er.txt".IO.open;

for $fh.lines() -> $l {
    say $l;
    unlink $l.IO.absolute;
}