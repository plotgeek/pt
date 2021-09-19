unit module util;

grammar Parser {
	rule TOP {<start><sep><end>}
	token sep { '-' }
	token start {\w+}
	token end {\w+}
}

sub dormsys($d) {
   put "sysfile $d";

   my @sys ="bin cdrom etc lib lib64 lost+found mnt proc run sdb sdd sdf sdh sdj sdl srv sys usr lib32 libx32 media opt root sbin sdc sde sdg sdi sdk snap swap.img tmp var boot dev".split(' ');
   my $dir = '/sd' ~ $d;
   my $home = '/sd' ~ $d ~ '/' ~ 'home';

   for @sys -> $t {
       qqx/sudo chown \$USER.\$USER  $dir/;

       my $f = '/sd' ~ $d ~ '/' ~ $t;
       put "rming sysfile $f";
       qqx/sudo rm -rf $f/;
   }

   # movine plots to device's top dir
   # then remove home dir
   if ($home.IO ~~ :e) {
      for dir($home.IO.absolute) -> $tmp {
          my $plots = $tmp ~ '/plots';
	  if ($plots.IO ~~ :e) {
      	     qqx/mv $plots $dir/;
	  } else {
	     put "no plots dir";
	  }
      }
      qqx/sudo rm  -rf $home/;
   }
}


sub rmsys(@disks) is export {
    if @disks.contains('-') {
        my $p = Parser.parse: @disks;
        my $start = $p<start>.chomp;
        my $sep = $p<sep>.chomp;
        my $end = $p<end>.chomp;


	if $start.contains('sd') {
	   $start = $start.substr(2, *);
	}
	if $end.contains('sd') {
	   $end = $end.substr(2, *);
	}

	say "Start: $start, End: $end";
	my $d = $start;
	loop {
	   dormsys($d);
	   $d = $d.succ;	     
	   last if ($d eq $end);
	   LAST {
	      dormsys($d);	      	  
	   }
	}
	
      exit(0);
    }

    for @disks ->  $d {
	dormsys($d);
    }
    exit(0);	
}


sub dormall($d) {
   put "rmall $d";

   my $dir = '/sd' ~ $d;

   if ($dir.IO ~~ :e) {
      my $plots = $dir ~ '/plots';
      for dir($plots.IO.absolute) -> $tmp {
          say "rming $tmp";
          unlink $tmp;
      }
   }
}

sub rmall(@disks) is export {
    if @disks.contains('-') {
        my $p = Parser.parse: @disks;
        my $start = $p<start>.chomp;
        my $sep = $p<sep>.chomp;
        my $end = $p<end>.chomp;


	if $start.contains('sd') {
	   $start = $start.substr(2, *);
	}
	if $end.contains('sd') {
	   $end = $end.substr(2, *);
	}

	say "Start: $start, End: $end";
	my $d = $start;
	loop {
	   dormall($d);
	   $d = $d.succ;	     
	   last if ($d eq $end);
	   LAST {
	      dormall($d);	      	  
	   }
	}
	
      exit(0);
    }

    for @disks ->  $d {
	dormall($d);
    }
    exit(0);	

}



