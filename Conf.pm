unit class Conf;

# nossd args
has $.addr             = "xch1xy4kmhd6avkde5z0h67mefzgakeq9ahnj802tuxjluq7prj9rhjqre2cjj";
has $.num_of_spt_disks = 5;
has $.mem_spt          = "32G";
has $.mem_fpt          = "4G";
has $.p_threads        = 20;
has $.f_threads        = 0;
has $.m_threads        = 4;



# pg args 
has $.farmer_key       = "9199c10ad809158231f81e00f3c4887119daa6706e683bda95dcc5bd8b19c618c4efcbb1a4ca1a94d7d94295a2718a2b";
has $.pool_contract    = "xch10shgem5afu0ft2rrsquwrs8qc07j987k6qne9vydcw990n6hldyq7vfyuj";
# og args
has $.pool_key         = "987e0cd0ffc600cc910d69a6a55021e290080da04506f4023bb04dc30f12311f7702a5def764c2064f60fae4cc19d7a9";



# common args
has $.disk_avail       = "80G";
has $.type             = "pg"; # pg,og
has $.mount_prefix     = "/z47";

# bb args
has $.bb               = "bladebit_cuda"; # bladebit,bladebit_cuda
has $.media            = "cudaplot"; # diskplot,ramplot,cudaplot
has $.bb_level         = 7;

# mmx args
has $.mmx_name         = "cuda_plot_k32";
has $.mmx_copy         = "chia_plot_copy";
has $.mmx_sink         = "chia_plot_sink";
has $.mmx_host         = "localhost";
has $.mmx_level        = 8;
has $.mmx_port         = 8444;     


# spacemesh args

    
has $.smh_root_path    ="~/squashfs-root";
has $.smh_numunits     = 4;
