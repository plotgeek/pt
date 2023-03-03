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

sub rm(@disks,$n) is export 
{
    for @disks -> $t {
    	my $d = $t;
	if $t.contains('sd') {
	   $d = $t.substr(2, *);
	}
	dormall($d,$n);
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
    for lines(qqx/df -h -BG  $dev/) -> $l {
	if $l ~~ /^('/dev'|'tmpfs')/ {
            my @p = $l.split(/\s+/);
            return @p[*-3];
        }
    }
}

sub mount($d, $fs) is export
{
    say "mounting " ~ $d;
    my $tdir = '/sd' ~ $d;
    my $tdev = '/dev/sd' ~ $d;
    if ($tdir.IO ~~ :e) {
	qqx/mount -t $fs $tdev $tdir/;
    } else {
	qqx/sudo mkdir $tdir/ ;
	qqx/sudo mount -t $fs $tdev $tdir/;
    }
}

sub mount_nfs($d, $fs, $hostip, $hostname) is export
{

    my $tdir = '/' ~ $hostname ~ '/sd' ~ $d;
    my $sdev = $hostip ~ ':/sd' ~ $d;
    say "$sdev";
    say "mounting nfs $hostname $hostip " ~ $tdir;
    if ($tdir.IO ~~ :e) {
	qqx/sudo mount.nfs -o nolock $sdev $tdir/;
    } else {
	qqx/sudo mkdir -p $tdir/ ;
	qqx/sudo mount.nfs -o nolock $sdev $tdir/;
    }	
}

sub umount($d) is export
{
    say "umounting " ~ $d;
    my $tdir = '/sd' ~ $d;
     if ($tdir.IO ~~ :e) {
	qqx/umount $tdir/;
    }
}

sub get_num($d) is export
{
    my $cnt = 0;
    if ($d.IO ~~ :e) {
       for dir($d.IO.absolute) -> $tmp {
          $cnt++;    			    
       }
    }
    return $cnt;
}

sub set_farmer_peer($ip, $p)  is export
{
   my $fh = $p.IO.open :rw ;

   my $current_pos = 0;
   my @lpos;
   my $harvester_pos = 0;
   my $farmer_peer_pos = 0;
   my $host_pos = 0;

   for $fh.lines -> $l {
       if $l.contains("harvester:") {
	  $harvester_pos = $fh.tell;
       }
       if $l.contains("farmer_peer:") {
	  $farmer_peer_pos = $fh.tell;
	  say $l;
       }
       if $l.contains("host:") {
       }
   }


   #$fh.seek($farmer_peer_pos+6,SeekFromBeginning);
   #my $buf = Buf.new: 0x31,0x39,0x32,0x2e,0x31,0x36,0x38,0x2e,0x31,0x2e,0x31;
   #$fh.write: $buf;

   $fh.seek($farmer_peer_pos,SeekFromBeginning);
   say $fh.readchars(9).Str;

   close $fh;
}


sub format($t, $fs) is export {

   put mkdir("$*HOME/t1");
   put mkdir("$*HOME/t2");
   put mkdir("$*HOME/plots");

   my $d = '/dev/sd' ~ $t;
   my $td = '/sd' ~ $t;
   
   if ($t ~~ 'nvme0n1') {
         $d  = '/dev/'  ~ $t;
         $td = '/sdnv1';
   }
   put mkdir("$td");


   put qqx/parted \/$d << EOF mklabel gpt mkpart x $fs 0% 100% << EOF/;


   sleep 2;

   put "mkfs ing";
   put qqx/mkfs.$fs -f $d/;


   sleep 2;
   put "mounting dev.";
   put qqx/mount -t $fs $d $td/;

   sleep 2;
   put "configure tmp dir t1 t2";
   qqx/mkdir \/$td\/t1/;
   qqx/mkdir \/$td\/t2/;
   qqx/mkdir \/$td\/plots/;


   sleep 2;
   my $user = $*KERNEL.hostname;
   put "chown for user: " ~ $user;
   qqx/chown  $user.$user  -R  \/$td/;

   put "done";
}


sub count_plots($d, $ft)  {
    my $cnt = 0; 
    if ($d.IO ~~ :e ) {
        if ($ft ~~ 'plot') {
           for dir($d.IO.absolute) -> $tmp {
                if ($tmp.basename.match(/.plot$/)) {
	       	   $cnt++;
            	}
           }
	} elsif ($ft ~~ 'fpt') {
           for dir($d.IO.absolute) -> $tmp {
                if ($tmp.basename.match(/.fpt$/)) {
	       	   $cnt++;
            	}
           }
	} elsif ($ft ~~ 'spt') {
           for dir($d.IO.absolute) -> $tmp {
                if ($tmp.basename.match(/.spt$/)) {
	       	   $cnt++;
            	}
           }
	} else {
	  say "wrong file type.";
	}
	
	return $cnt;
    }
}
sub count(@disks, $ft = 'plot') is export {
    my $sum = 0;
    my $num = 0;
    for @disks -> $t {
    	my $d = $t;
	if $t.contains('sd') {
	    $d = $t.substr(2, *);
	}
	my $plots_dir = '/sd' ~ $d ~ '/' ~ 'plots';
	$num = count_plots($plots_dir, $ft);
	$sum += $num;
	say "counting, $plots_dir: $num $ft";
    }
    return $sum;
}



sub clean_plots($p) {
    if ($p.IO ~~ :e ) {
        for dir($p.IO.absolute) -> $tmp {
		my $size = $tmp.IO.s/1024/1024/1024;
		if ($tmp.basename.match(/.fpt$/)) {
			if ($size > 77 && $size < 79)  { next; say "fpt size: $size";}
		}
		if ($tmp.basename.match(/.spt$/)) {
			if ($size > 87 && $size < 89) { next; say "spt size: $size";}	
		}
		if ($tmp.basename.match(/.plot$/)) {
			if ($size > 101 && $size < 102) { next; say "plot size: $size";}
		}
		say "cleaning $tmp";
                unlink $tmp;
        }
    }
}


sub remove($t) {
   say "cleaning file $t";
   if ($t.IO ~~ :e) {
     for dir($t.IO.absolute) -> $tmp {
       unlink $tmp;
     }
   }
}

sub clean(@disks) is export {

    for @disks -> $t {
    	my $d = $t;
        put "cleaningggggggggg";
	if $t.contains('sd') {
	    $d = $t.substr(2, *);
	}
	my $t1 = '/sd' ~ $d ~ '/' ~ 't1';
	my $t2 = '/sd' ~ $d ~ '/' ~ 't2';
	my $plots = '/sd' ~ $d ~ '/' ~ 'plots';
	remove($t1);
	remove($t2);
	clean_plots($plots);
    }
}

sub get_size($size) is export
{
	#say "$size";
	my $t = $size.lc;
	my $s = $t.subst: /g$/,'';
	return $s;
}

sub test(@disks, $op='write', $size = '10G') is export 
{
    for @disks -> $t {
    	my $d = $t;
    	
	if $t.contains('sd') {
	   $d = $t.substr(2, *);
	}
	my $zerofile = '/sd' ~ $d ~ '/' ~ 'zerofile';
	put "testing $d";
	say $zerofile;
	if ($op ~~ 'write') {
	   my $count = get_size($size) * 1024;
	   qqx/dd if=\/dev\/zero of=$zerofile bs=1024k count=$count/;
	}
	if ($op ~~ 'clean') {
	   unlink $zerofile.IO.absolute;
	}
    }
}

sub parse($dirs) is export
{
    my @disks;
    if ($dirs.contains(',')) {	
       @disks = $dirs.chomp.split(',');
    } elsif ($dirs.contains('-')) {
       my $p     = Parser.parse: $dirs;
       my $start = $p<start>.chomp;
       my $sep   = $p<sep>.chomp;
       my $end   = $p<end>.chomp;

       if $start.contains('sd') {
	    $start = $start.substr(2, *);
       }
       if $end.contains('sd') {
	    $end = $end.substr(2, *);
       }

       @disks.push: $start;
       my $t = $start;
       loop {
	  $t = $t.succ;
	  @disks.push: $t;
	  last if ($t eq $end);
       }
    } else {
       @disks.push: $dirs;
    }
    return @disks;
}

sub parse_comma($dirs) is export
{
    my @disks;
    my @disks_tmp;
    if ($dirs.contains(',')) {	
	@disks_tmp = $dirs.chomp.split(',');
    } else {
	@disks_tmp.push: $dirs;
    }

    for @disks_tmp -> $part {
	if ($part.contains('-')) {
	    my $p     = Parser.parse: $part;
	    my $start = $p<start>.chomp;
	    my $sep   = $p<sep>.chomp;
	    my $end   = $p<end>.chomp;

	    if $start.contains('sd') {
		$start = $start.substr(2, *);
	    }
	    if $end.contains('sd') {
		$end = $end.substr(2, *);
	    }

	    @disks.push: $start;
	    my $t = $start;
	    loop {
		$t = $t.succ;
		@disks.push: $t;
		last if ($t eq $end);
	    }
	} else {
	    @disks.push: $part;
	}
    }

    return @disks;
}

sub mmx_copy($host, $dir) is export
{
    my $proc = Proc::Async.new: 'chia_plot_copy', '-d', '-t', $host, '--', $dir;
    return $proc;
}

sub mmx_sink($host, $dir) is export
{
    #my $proc = Proc::Async.new: 'chia_plot_sink', '-d', '-t', $host, $dir;
    #return $proc;
}


