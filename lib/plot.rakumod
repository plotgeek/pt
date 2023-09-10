unit module plot;

sub plotter($f_dir, $d, $f, $pub) is export
{
    my $d2 =  $d;
    
    my $proc = Proc::Async.new: 'bladebit', '-f', $f, '-c', $pub, $f_dir;
    return $proc;
}


sub mmx($d, $gpu, $mmx_name, $x, $level, $t, $f, $pool_key, $pool_contract) is export
{
    my $f_dir   = '/sd' ~ $d ~ '/' ~ 'plots/';
    my $tmp_dir = '/sd' ~ $d ~ '/' ~ 't1/';
    if ($t ~~ 'pg') {
       say "pg";
       my $proc = Proc::Async.new: $mmx_name, '-C', $level, '-x', $x, '-g', $gpu, '-f', $f, '-c', $pool_contract, "-t", $tmp_dir, "-d", $f_dir;
       return $proc;
    } elsif ($t ~~ 'og') {
       say "og";
       my $proc = Proc::Async.new: $mmx_name, '-C', $level, '-x', $x, '-g', $gpu, '-f', $f, '-p', $pool_key, "-t", $tmp_dir, "-d", $f_dir;
       return $proc;
    }
}

sub bb($f_dir, $t1, $type, $f, $pool_key, $pool_contract, $media, $level, $bb) is export
{
    if ($type ~~ 'pg') {
       say "pg";
       my $proc = Proc::Async.new: $bb, '-f', $f, '-c', $pool_contract, '-z', $level, $media, '-t1', $t1, $f_dir;
       return $proc;
    } elsif ($type ~~ 'og') {
       say "og";
       my $proc = Proc::Async.new: $bb, '-f', $f, '-p', $pool_key, '-z', $level, $media, '-t1', $t1, $f_dir;
       return $proc;
    }
}

sub nossd($s, $path, $addr, $mem = '32G', $p_threads = 8, $m_threads = 4) is export
{
    my $log = 'log/' ~ $s;
    my $hostname = $*KERNEL.hostname;
    qqx/tmux new -s $s -d  client  $path -s $log  -m $mem --no-benchmark --p-threads $p_threads --m-threads $m_threads -c  5  -a $addr -w $hostname/;	
}

sub nossd_fpt($sname, $path, $mem = '4G', $f_threads = 8, $m_threads = 4) is export
{
    my $log  = 'log/' ~ $sname;
    my $proc;
    if ($f_threads == 0 ) {
       say "at nodssd_fpt,f_threads: 0";
       $proc = Proc::Async.new: 'client', '-d,tf', $path, '--no-benchmark', '--m-threads', $m_threads, '-c', 5, '-m', $mem, '-s', $log;
    } else {
       say "at nossd_fpt, f_threads: " ~ $f_threads;
       $proc = Proc::Async.new: 'client', '-d,tf', $path, '--no-benchmark', '--p-threads', $f_threads, '--m-threads', $m_threads, '-c', 5, '-m', $mem, '-s', $log;
    }
    return $proc;
}

sub nossd2($dir, $level, $addr) is export
{
    say $dir, $addr, $level;
    qqx/tmux new -s nossd2 -d client $dir -c $level -a $addr --no-gpu-mining/;
}
