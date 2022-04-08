unit module plot;

grammar Parser {
	rule TOP {<start><sep><end>}
	token sep { '-' }
	token start {\w+}
	token end {\w+}
}

sub ploter($t1, $t2, $f_dir, $d, $f, $pub) is export
{
    my $d2 =  $d;
    
    if $d ~~ /\// {
       $d2 = $d.subst: /\//, '_', :g;
    }
    if $d2 ~~ /\s/ {
       $d2 = $d.subst: /\s/, '', :g;
    }
    
    my $proc = Proc::Async.new: 'chia_plot', '-r', 2, '-f', $f, '-c', $pub, '-t', $t1,  '-2', $t2,  '-d', $f_dir;
    my $promise = $proc.start;
    my $task = $d => $promise;
    return $task;
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

sub format($t) is export {

   put mkdir("$*HOME/t1");
   put mkdir("$*HOME/t2");
   put mkdir("$*HOME/plots");

   my $d = '/dev/sd' ~ $t;
   put mkdir("$d");

   put qqx/parted \/dev\/$d << EOF mklabel gpt mkpart x xfs 0% 100% << EOF/;


   sleep 2;

   put "mkfs ing";
   put qqx/mkfs.xfs -f \/dev\/$d/;


   sleep 2;
   put "configuring fstab";
   put qqx/echo \/dev\/$d  \/$d xfs defaults 0 0 >> \/etc\/fstab/;

   put "mounting dev.";
   put qqx/mount -a/;

   sleep 2;
   put "configure tmp dir t1 t2";
   qqx/mkdir \/$d\/t1/;
   qqx/mkdir \/$d\/t2/;
   qqx/mkdir \/$d\/p/;
   qqx/mkdir \/$d\/plots/;


   sleep 2;
   my $user = $*KERNEL.hostname;
   put "chown for user: " ~ $user;
   #qqx/sudo chown  $user.$user  -R  \/sdb \/sdc \/sdd \/sde \/sdf \/sdg \/sdh \/sdi \/sdj \/sdk \/sdl/;

   qqx/sudo chown  $user.$user  -R  \/$d/;

   put "done";
}
