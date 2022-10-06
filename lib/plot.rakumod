unit module plot;

grammar Parser {
	rule TOP {<start><sep><end>}
	token sep { '-' }
	token start {\w+}
	token end {\w+}
}

sub ploter($f_dir, $d, $f, $pub) is export
{
    my $d2 =  $d;
    
    my $proc = Proc::Async.new: 'bladebit', '-f', $f, '-c', $pub, $f_dir;
    return $proc;
}


sub clean_plots($p) {
    if ($p.IO ~~ :e ) {
        for dir($p.IO.absolute) -> $tmp {
            if ($tmp.IO.s/1024/1024/1024 < 100) {
		say "cleaning $tmp";
                unlink $tmp;
            }
        }
    }
}

sub count_plots($p)  {
    my $cnt = 0; 
    if ($p.IO ~~ :e ) {
        for dir($p.IO.absolute) -> $tmp {
            if ($tmp.IO.s/1024/1024/1024 > 100) {
	        $cnt++;
            }
        }
	return $cnt;
    }
}


sub remove($t) {
   say "cleaning file $t";
   if ($t.IO ~~ :e) {
     for dir($t.IO.absolute) -> $tmp {
       unlink $tmp;
     }
   }
   
   say "cleaning plots";
   my $plots = $t.subst(/t1 || t2/, "plots");
   if ($plots.IO ~~ :e) {
      say "plots dir is $plots";
      clean_plots($plots);
   }
}

sub clean(@disks) is export {
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
	   my $t1 = '/sd' ~ $d ~ '/' ~ 't1';
	   my $t2 = '/sd' ~ $d ~ '/' ~ 't2';
	   remove($t1);
	   remove($t2);

	   $d = $d.succ;	     
	   last if ($d eq $end);
	   LAST {
	      $t1 = '/sd' ~ $d ~ '/' ~ 't1';
	      $t2 = '/sd' ~ $d ~ '/' ~ 't2';
	      remove($t1);	      	  
	      remove($t2);	      	  
	   }
	}
	
      exit(0);
    }

    if (@disks.elems == 1) {
        my $d = @disks;

        if $d.contains('sd') {
            $d = $d.substr(2, *);
        }
   	my $t1 = '/sd' ~ $d ~ '/' ~ 't1';
        my $t2 = '/sd' ~ $d ~ '/' ~ 't2';
        remove($t1);
        remove($t2);
        exit(0);
    }
    
    for @disks -> $t {
    	my $d = $t;
        put "cleaningggggggggg";
	if $t.contains('sd') {
	    $d = $t.substr(2, *);
	}
	my $t1 = '/sd' ~ $d ~ '/' ~ 't1';
	my $t2 = '/sd' ~ $d ~ '/' ~ 't2';
	remove($t1);
	remove($t2);
    }
}

sub count(@disks) is export {
    		  
    my $sum = 0;
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
	   my $plots_dir = '/sd' ~ $d ~ '/' ~ 'plots';
	   $sum += count_plots($plots_dir);
	   $d = $d.succ;	     
	   last if ($d eq $end);
	   LAST {
	      $plots_dir = '/sd' ~ $d ~ '/' ~ 'plots';
	      $sum += count_plots($plots_dir);
	   }
	}
      
      return $sum;	
    }

    if (@disks.elems == 1) {
        my $d = @disks;

        if $d.contains('sd') {
            $d = $d.substr(2, *);
        }
   	my $plots_dir = '/sd' ~ $d ~ '/' ~ 'plots';
        $sum = count_plots($plots_dir);

	return $sum;
    }
    
    for @disks -> $t {
    	my $d = $t;
        put "countingggggggggg";
	if $t.contains('sd') {
	    $d = $t.substr(2, *);
	}
	my $plots_dir = '/sd' ~ $d ~ '/' ~ 'plots';
	$sum += count_plots($plots_dir);
    }
    return $sum;
}

sub format($t) is export {

   put mkdir("$*HOME/t1");
   put mkdir("$*HOME/t2");
   put mkdir("$*HOME/plots");

   my $d = '/dev/sd' ~ $t;
   my $td = '/sd' ~ $t;
   put mkdir("$d");

   put qqx/parted \/$d << EOF mklabel gpt mkpart x xfs 0% 100% << EOF/;


   sleep 2;

   put "mkfs ing";
   put qqx/mkfs.xfs -f \/$d/;


   sleep 2;
   put "mounting dev.";
   put qqx/mount -t xfs $d $td/;

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
