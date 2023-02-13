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
has $.pool_key         = "";




has $.disk_avail       = "200G";
has $.type             = "pg"; 


# mmx args
has $.mmx_name         = "cuda_plot_k32";
has $.mmx_level        = 9;