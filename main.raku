#!/usr/bin/env rakudo




sub MAIN($dirs, $op = 'create', 
         $f = 'b8184ebe49924b2065f77e13069862f1b663eb4be1b9fa0a2ed1266554511db84c19e4f31d604792a60be96076d75b88', 
         $pub = '85af06071c2131ca44e64d9a53392c88981e05e80fce246267abc2b3eb7ae5e16e0961d0a413b29728776c55ebcab568') 
{
    my @disks = $dirs.chomp.split(',');

    if ($op ~~ 'stop') {
         for @disks -> $d {
           put "dir: $d";
           qqx/screen -S $d -X quit/
         }
	 exit(0);
    } 

    if ($op ~~ 'clean') {
         for @disks -> $d {
           put "dir: $d";
           qqx/rakudo .\/plot.raku $d clean/
         }
	 exit(0);
    } 

    if ($op ~~ 'remove') {
       for @disks -> $d {
           my $t = '/' ~ $d ~ '/' ~ 'plots';
	   put "plots dir: $t";
       	   qqx/chia plots remove -d $t/
       }
       exit(0);
    }

    if ($op ~~ 'add') {
       for @disks -> $d {
           my $t = '/' ~ $d ~ '/' ~ 'plots';
	   put "plots dir: $t";
	   if $d.contains('sda') && $d.chars == 3 {
       	     put "home dir: " ~ $*HOME;
	     $t = $*HOME ~ '/' ~ 'plots';
           }
       	   qqx/chia plots add -d $t/
       }
       exit(0);
    }

    if ($op ~~ 'format') {
       for @disks -> $d {
          qqx/sudo rakudo .\/plot.raku $d format/;
       }
       exit(0);
    }

    for @disks -> $d {
       put "dir: $d";
       put "farmer: $f";
       put "pool:   $pub";
       qqx/screen -S $d -d -m rakudo .\/plot.raku $d 'create' $f $pub/;
    }
}
