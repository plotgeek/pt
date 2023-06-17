#!/usr/bin/env rakudo

say "start monitoring";

loop {
    my $proxy_pid = qqx/pidof chia_recompute_proxy/;
    if ($proxy_pid) {
      say "chia_recompute_proxy's pid  $proxy_pid";
    } else {
      say "chia_recompute_proxy stoped, restarting it";
      qqx/tmux new -s proxy -d chia_recompute_proxy -n 192.168.5.80 -n 192.168.4.173/;
    }

    sleep(5);
}
