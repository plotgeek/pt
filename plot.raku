#!/usr/bin/env rakudo

grammar Parser {
	rule TOP {<start><sep><end>}
	token sep { '-' }
	token start {\w+}
	token end {\w+}
}

sub ploter($t1, $t2, $f_dir, $d, $f, $pub)
{
    my $d2 =  $d;
    
    if $d ~~ /\// {
       $d2 = $d.subst: /\//, '_', :g;
    }
    if $d2 ~~ /\s/ {
       $d2 = $d.subst: /\s/, '', :g;
    }
    
    my $proc = Proc::Async.new: 'chia_plot', '-n', -1, '-r', 2, '-f', $f, '-p', $pub, '-t', $t1,  '-2', $t2,  '-d', $f_dir;
    my $promise = $proc.start;
    my $task = $d => $promise;
    return $task;
}


sub remove($t) {
   say "cleaning file $t";
   if ($t.IO ~~ :e) {
     for dir($t.IO.absolute) -> $tmp {
       unlink $tmp;
     }
   }
}

sub clean(@disks) {
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

    put "cleaning file t1 & t2: ";
    for @disks ->  $d {
	my $t1 = '/' ~ $d ~ '/' ~ 't1';
	my $t2 = '/' ~ $d ~ '/' ~ 't2';

        if ($d eq 'sda') {
           $t1 = $*HOME ~ '/' ~ 't1';
           $t2 = $*HOME ~ '/' ~ 't2';
        }
	remove($t1);
	remove($t2);
    }
    exit(0);	
}

sub format(@disks) {

   put mkdir("$*HOME/t1");
   put mkdir("$*HOME/t2");
   put mkdir("$*HOME/plots");

   for @disks -> $d {
       put mkdir("/$d");
   } 

   for @disks -> $d {
       #put $d;
       put qqx/parted \/dev\/$d << EOF mklabel gpt mkpart x xfs 0% 100% << EOF/;
   }

   sleep 5;

   put "mkfs ing";
   for @disks -> $d {
       put qqx/mkfs.xfs -f \/dev\/$d/;
   }

   sleep 5;
   put "configuring fstab";
   for @disks -> $d {
       put qqx/echo \/dev\/$d  \/$d xfs defaults 0 0 >> \/etc\/fstab/;
   }

   put "mounting dev.";
   put qqx/mount -a/;

   sleep 5;
   put "configure tmp dir t1 t2";
   for @disks -> $d {
       qqx/mkdir \/$d\/t1/;
       qqx/mkdir \/$d\/t2/;
       qqx/mkdir \/$d\/p/;
       qqx/mkdir \/$d\/plots/;
   }

   sleep 5;
   my $user = $*KERNEL.hostname;
   put "chown for user: " ~ $user;
   #qqx/sudo chown  $user.$user  -R  \/sdb \/sdc \/sdd \/sde \/sdf \/sdg \/sdh \/sdi \/sdj \/sdk \/sdl/;
   for @disks ->$d {
      qqx/sudo chown  $user.$user  -R  \/$d/;
   }
   put "done";
}




sub MAIN($dirs, 
         $op,
         $f='b8184ebe49924b2065f77e13069862f1b663eb4be1b9fa0a2ed1266554511db84c19e4f31d604792a60be96076d75b88', 
         $pub='85af06071c2131ca44e64d9a53392c88981e05e80fce246267abc2b3eb7ae5e16e0961d0a413b29728776c55ebcab568')
{
    my @tasks;
    my @disks = $dirs.chomp.split(',');
    
    if ($op ~~ 'clean') {
       clean(@disks);
       exit(0);
    }

    if ($op ~~ 'format') {
    put "formating disks";
      format(@disks);
      exit(0);
    }

    if ($op ~~ 'chown') {
       for @disks -> $d {
        qqx/chown \$USER.\$USER \/$d/;
        qqx/chown \$USER.\$USER \/$d\/t1/;
        qqx/chown \$USER.\$USER \/$d\/t2/;
        qqx/chown \$USER.\$USER \/$d\/p/;
        qqx/chown \$USER.\$USER \/$d\/plots/;
       }
       exit(0);
    }

    if ($op ~~ 'create')  
    {  
       for @disks -> $d {
       	 put "dir: $d" ;
       
         my $t1     = '/' ~ $d ~ '/' ~ 't1/';
         my $t2     = '/' ~ $d ~ '/' ~ 't2/';
         my $f_dir = '/' ~ $d ~ '/' ~ 'plots/';
         if ($d eq 'sda') {
       	   put "home dir: " ~ $*HOME;
	   $t1 = $*HOME ~ '/' ~ 't1/';
	   $t2 = $*HOME ~ '/' ~ 't2/';
	   $f_dir = $*HOME ~ '/' ~ 'plots/';
         }
         my $p = ploter($t1, $t2, $f_dir, $d, $f, $pub);
         @tasks.push: $p;
       }
    
       loop {
    	 my $n_t = @tasks.elems;
	 my $i = 0;
	 while ($i < $n_t) {
	    my $t  = @tasks[$i];
    	    put "{$n_t}, {$t.key}  = > {$t.value}";

	    my $d     =  $t.key;
	    my $p     =  $t.value;
	    my $t1    = '/' ~ $d ~ '/' ~ 't1/';
            my $t2    = '/' ~ $d ~ '/' ~ 't2/';
            my $f_dir = '/' ~ $d ~ '/' ~ 'plots/';
	    if $d ~~ /sda/ {
       	      put "home dir: " ~ $*HOME;
	      $t1 = $*HOME ~ '/' ~ 't1/';
	      $t2 = $*HOME ~ '/' ~ 't2/';
	      $f_dir = $*HOME ~ '/' ~ 'plots/';
            }

	    put do given $p.status {
	       when Planned { "Still working on it" }
	       when Kept    { @tasks[$i] = ploter($t1, $t2, $f_dir, $d, $f, $pub) }
	       when Broken  { "Error!!!" }    
	    }
	    $i++;
	}
	sleep 5;
     }
    }    
}
