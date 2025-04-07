unit class Conf;

# nossd args
has $.addr             = "xch1xy4kmhd6avkde5z0h67mefzgakeq9ahnj802tuxjluq7prj9rhjqre2cjj"; # replace with your own addr
has $.num_of_spt_disks = 5;
has $.mem_spt          = "32G";
has $.mem_fpt          = "4G";
has $.p_threads        = 32;
has $.f_threads        = 0;
has $.m_threads        = 4;
has $.nossd_level      = 33;
has $.stop             = "--no-stop"; # "--no-stop" or ""
has $.nossd            = "~/nossd/client";

has $.nossd_mining     = False;
has $.notmp            = True;
has $.use_cpu          = False;


# common args
has $.file_type        = "*.fpt";
has $.disk_avail       = "80G";
has $.type             = "pg"; # pg,og
has $.mount_prefix     = "/"; # eg. '/' or  '/f1' or  'f1,f2,f3' 
has $.plots_dir        = "plots"; # eg. "plots";
has $.tmux_log         = True; # log for tmux sessions.
has $.nfs_conf         = "$*HOME/pt/nfs.conf";

# mmx args
has $.mmx_copy         = "$*HOME/sink/chia_plot_copy";
has $.mmx_sink         = "$*HOME/sink/chia_plot_sink";
has $.mmx_host         = "localhost";
has $.mmx_port         = 8444;     
has $.mmx_single       = False;



