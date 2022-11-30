unit module plot;

sub plotter($f_dir, $d, $f, $pub) is export
{
    my $d2 =  $d;
    
    my $proc = Proc::Async.new: 'bladebit', '-f', $f, '-c', $pub, $f_dir;
    return $proc;
}

sub nossd($op, $path, $addr) is export
{
    qqx/tmux new -s $op -d  client  $path  -c  5  -a $addr/;
}


