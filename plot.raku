#!/usr/bin/env rakudo

sub ploter($t1, $t2, $f_dir, $d) {
    my $d2 =  $d;
    
    if $d ~~ /\// {
       $d2 = $d.subst: /\//, '_', :g;
    }
    if $d2 ~~ /\s/ {
       $d2 = $d.subst: /\s/, '', :g;
    }

    my $proc = Proc::Async.new: 'chia', 'plots', 'create', '-k', 32, '-r', 2, '-u','128', '-b', 4520, '-t', $t1,  '-2', $t2,  '-d', $f_dir;
    my $promise = $proc.start;
    my $task = $d => $promise;
    return $task;
}

sub clean(@disks) {
    put "cleaning file t1: ";
    for @disks ->  $d {
	my $t1 = '/' ~ $d ~ '/' ~ 't1';
        if $d ~~ /sda/ {
           $t1 = $*HOME ~ '/' ~ 't1';
        }
	if ($t1.IO ~~ :e) {
	  for dir($t1.IO.absolute) -> $tmp {
	    unlink $tmp;
	  }
	}
    }

    put "cleaning file t2: ";
    for @disks ->  $d {
	my $t2 = '/' ~ $d ~ '/' ~ 't2';
	if $d ~~ /sda/ {
           $t2 = $*HOME ~ '/' ~ 't2';
        }
	if ($t2.IO ~~ :e) {
	  for dir($t2.IO.absolute) -> $tmp {
	    unlink $tmp;
	  }
	}
    }

    put "cleaning file p: ";
    for @disks ->  $d {
	my $p = '/' ~ $d ~ '/' ~ 'p';
	if $d ~~ /sda/ {
	   $p = $*HOME ~ '/' ~ 'p';
	}
	if ($p.IO ~~ :e) {
	  for dir($p.IO.absolute) -> $tmp {
	    unlink $tmp;
	  }
	}	
    }

}

sub install()
{
  #put "args: "	 ~ $args;
  qqx/sed -i'' -e '\$ d'  \/etc\/proxychains4.conf  \/etc\/proxychains4.conf/;
  put qqx/echo socks5 192.168.3.50 1880 >> \/etc\/proxychains4.conf/;
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
   for @disks ->$d {
      qqx/sudo chown  $user.$user  -R  \/$d;
   }
   put "done";
}




sub MAIN($dirs, $op = 'create') {
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

    for @disks -> $d {
       put "dir: $d" ;
       
       my $t1     = '/' ~ $d ~ '/' ~ 't1';
       my $t2     = '/' ~ $d ~ '/' ~ 't2';
       my $f_dir = '/' ~ $d ~ '/' ~ 'plots';
       if $d ~~ /sda/ {
       	  put "home dir: " ~ $*HOME;
	  $t1 = $*HOME ~ '/' ~ 't1';
	  $t2 = $*HOME ~ '/' ~ 't2';
	  $f_dir = $*HOME ~ '/' ~ 'plots';
       }
       my $p = ploter($t1, $t2, $f_dir, $d);
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
	   my $t1    = '/' ~ $d ~ '/' ~ 't1';
           my $t2    = '/' ~ $d ~ '/' ~ 't2';
           my $f_dir = '/' ~ $d ~ '/' ~ 'plots';
	   if $d ~~ /sda/ {
       	     put "home dir: " ~ $*HOME;
	     $t1 = $*HOME ~ '/' ~ 't1';
	     $t2 = $*HOME ~ '/' ~ 't2';
	     $f_dir = $*HOME ~ '/' ~ 'plots';
           }

	   put do given $p.status {
	       when Planned { "Still working on it" }
	       when Kept    { @tasks[$i] = ploter($t1, $t2, $f_dir, $d) }
	       when Broken  { "Error!!!" }    
	   }
	   $i++;
	}
	sleep 5;
    }
}
