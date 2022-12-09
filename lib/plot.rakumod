unit module plot;

sub plotter($f_dir, $d, $f, $pub) is export
{
    my $d2 =  $d;
    
    my $proc = Proc::Async.new: 'bladebit', '-f', $f, '-c', $pub, $f_dir;
    return $proc;
}

sub nossd($s, $path, $addr, $mem = '32G') is export
{
    #say "tmux new -s $s -d  client  $path -s $s  -m 32G -c  5  -a $addr";	
    my $log = 'log/' ~ $s;
    qqx/tmux new -s $s -d  client  $path -s $log  -m $mem  -c  5  -a $addr/;	
}

sub nossd_fpt($sname, $path, $mem = '4G') is export
{
    my $log  = 'log/' ~ $sname;
    my $proc = Proc::Async.new: 'client', '-d,tf', $path, '-c', 5, '-m', $mem, '-s', $log;
    return $proc;
}


