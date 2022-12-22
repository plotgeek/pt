unit module plot;

sub plotter($f_dir, $d, $f, $pub) is export
{
    my $d2 =  $d;
    
    my $proc = Proc::Async.new: 'bladebit', '-f', $f, '-c', $pub, $f_dir;
    return $proc;
}

sub nossd($s, $path, $addr, $mem = '32G', $p_threads = 8, $m_threads = 4) is export
{
    my $log = 'log/' ~ $s;
    my $hostname = $*KERNEL.hostname;
    qqx/tmux new -s $s -d  client  $path -s $log  -m $mem  --p-threads $p_threads --m-threads $m_threads -c  5  -a $addr -w $hostname/;	
}

sub nossd_fpt($sname, $path, $mem = '4G', $p_threads = 8, $m_threads = 4) is export
{
    my $log  = 'log/' ~ $sname;
    my $proc = Proc::Async.new: 'client', '-d,tf', $path, '--p-threads', $p_threads, '--m-threads', $m_threads, '-c', 5, '-m', $mem, '-s', $log;
    return $proc;
}


