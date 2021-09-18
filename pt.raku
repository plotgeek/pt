#!/usr/bin/env rakudo

use lib 'lib';
use plot;
use util;

sub MAIN($dirs, $op = 'create', 
         $farmer_pk = 'b8184ebe49924b2065f77e13069862f1b663eb4be1b9fa0a2ed1266554511db84c19e4f31d604792a60be96076d75b88', 
         $pool_pk_or_contract_addr = '85af06071c2131ca44e64d9a53392c88981e05e80fce246267abc2b3eb7ae5e16e0961d0a413b29728776c55ebcab568') 
{
    my @disks = $dirs.chomp.split(',');
    my @tasks;

    if ($op ~~ 'stop') {
         for @disks -> $d {
           put "stoping: $d";
           qqx/screen -S $d -X quit/
         }
	 exit(0);
    } 

    if ($op ~~ 'clean') {
         clean(@disks);
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
       format(@disks);        
       exit(0);
    }

    if ($op ~~ 'rmsys') {
       rmsys(@disks);
       exit(0);
    }
    
    if ($op ~~ 'rmall') {
       rmall(@disks);
       exit(0);
    }

    if ($op ~~ 'create') { 
       for @disks -> $d {
           put "dir: $d";
           put "farmer: $farmer_pk";
	   put "pool:   $pool_pk_or_contract_addr";
	   qqx/screen -S $d -d -m rakudo .\/ploter.raku $d 'create' $farmer_pk $pool_pk_or_contract_addr/;
       }
    }
}
