unit module plot;

sub ploter($f_dir, $d, $f, $pub) is export
{
    my $d2 =  $d;
    
    my $proc = Proc::Async.new: 'bladebit', '-f', $f, '-c', $pub, $f_dir;
    return $proc;
}




