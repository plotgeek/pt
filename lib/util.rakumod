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


sub dormall($d,$n) {
   put "rmall $d";

   my $dir = '/sd' ~ $d;
   my $t1 = $dir ~ '/t1';
   my $t2 = $dir ~ '/t2';

   if ($dir.IO ~~ :e) {
      my $plots = $dir ~ '/plots';
      my $cnt = 1;
      if ($plots.IO ~~ :e) {
      	for dir($plots.IO.absolute) -> $tmp {
          last if ($cnt++ > $n);
          say "rming $tmp";
          unlink $tmp;
      	}
      }
      if ($t1.IO ~~ :e) {
      	for dir($t1.IO.absolute) -> $tmp {
          say "rming $tmp";
          unlink $tmp;
      	}
      }
      if ($t2.IO ~~ :e) {
      	for dir($t2.IO.absolute) -> $tmp {
          say "rming $tmp";
          unlink $tmp;
      	}
      }
   }
}

sub rmall(@disks,$n) is export {
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
	   dormall($d,$n);
	   $d = $d.succ;	     
	   last if ($d eq $end);
	   LAST {
	      dormall($d,$n);	      	  
	   }
	}
	
      exit(0);
    }

    if (@disks.elems == 1) {
        my $d = @disks;

	if $d.contains('sd') {
            $d = $d.substr(2, *);
        }
	dormall($d,$n);
	exit(0);
    }
	
}


sub get_sys_part() is export
{
    my $fstab = "/etc/fstab";
    my $fh = $fstab.IO.open;
    my $l;
    my $sys_part;

    for $fh.lines() -> $l {
	if $l ~~ /^\/dev/ {
	    my @tl = $l.split(/\s+/);
	    if (@tl[*-5] eq '/') {
		if @tl[0].IO ~~ :l {
		    $sys_part = @tl[0].IO.resolve;
		}
	    }
	}
    }
    return $sys_part.Str; 	
}

sub get_part_size($dev) is export
{
    for lines(qqx/df -h $dev/) -> $l {
	if $l ~~ /^\/dev/ {
            my @p = $l.split(/\s+/);
            return @p[*-3];
        }
    }
}


sub mount($d) is export
{
    say "mounting " ~ $d;
    my $tdir = '/sd' ~ $d;
    my $tdev = '/dev/sd' ~ $d;
    if ($tdir.IO ~~ :e) {
	qqx/mount -t xfs $tdev $tdir/;
    } else {
	qqx/sudo mkdir $tdir/ ;
	qqx/sudo mount -t xfs $tdev $tdir/;
    }
}



