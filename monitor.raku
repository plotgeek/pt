#!/usr/bin/env rakudo

say "start monitoring";

loop {
    my $server_pid = qqx/pidof chia_recompute_server/;
    if ($server_pid) {
      say "chia_recompute_server's pid  $server_pid";
    } else {
      say "chia_recompute_server stoped, restarting it";
      qqx/tmux new -s monitor -d chia_recompute_server/;
    }

    sleep(5);
}
