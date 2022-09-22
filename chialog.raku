#!/usr/local/bin/env raku

say "hello world";


my $log = "./t.log";
my $fh = $log.IO.open;
my $l;

my %devs;

for $fh.lines() -> $l {
    if ($l ~~ /\/(sd(\w+)*)\/plots/) {
       my $d = $0;
       %devs.append($d, 'plots');
    }
}


#say %devs.keys;

for  %devs.keys -> $t {

     my $file = "test";
     if  qqx/touch \/$t\/$file/ ~~ /Input\/output/ {
     	 say $t;
     }
}

