#!/usr/bin/env rakudo


sub install()
{
    qqx/sed -i'' -e '\$ d'  \/etc\/proxychains4.conf  \/etc\/proxychains4.conf/;
    put qqx/echo socks5 192.168.3.50 1880 >> \/etc\/proxychains4.conf/;
}
      

sub MAIN($dirs, $op = 'create') {
    my @disks = $dirs.chomp.split(',');

    if ($op ~~ "install") {
      install();
      exit(0);
    }

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
	   if $d ~~ /sda/ {
       	     put "home dir: " ~ $*HOME;
	     $t = $*HOME ~ '/' ~ 'plots';
           }
       	   qqx/chia plots add -d $t/
       }
       exit(0);
    }

    if ($op ~~ 'format') {
       for @disks ->$d {
       	   qqx/rakudo .\/plot.raku $d format/
       }
       exit(0);
    }

    for @disks -> $d {
       put "dir: $d";
       qqx/screen -S $d -d -m rakudo .\/plot.raku $d/
    }
}
