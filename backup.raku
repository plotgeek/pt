#!/usr/bin/env rakudo


sub get_backup_file($log_file, $backup_dir)
{
    my $backup_file = "";	
    my $timestamp = DateTime.now.Str.subst(/T/, '_', :g).subst(/Z/, '', :g);
    if ($log_file ~~ /copy/) {
       $backup_file = "$backup_dir/copy_backup_$timestamp.log";	
    }
    if ($log_file ~~ /write/) {
       $backup_file = "$backup_dir/write_backup_$timestamp.log";	
    }
    if ($log_file ~~ /plot/) {
       $backup_file = "$backup_dir/plot_backup_$timestamp.log";	
    }
    if ($log_file ~~ /mining/) {
       $backup_file = "$backup_dir/mining_backup_$timestamp.log";	
    }
	
    return $backup_file;
}

# 定义备份函数
sub backup_log($log_file, $backup_dir) 
{
    my $max_backups = 10;                                 # 最大保留备份数量

    mkdir $backup_dir unless $backup_dir.IO.e;

    say "开始备份日志文件...";
    # 检查日志文件是否存在
    unless $log_file.IO.e {
        say "日志文件不存在: $log_file";
        return;
    }

    # 创建带时间戳的备份文件名
    my $backup_file = get_backup_file($log_file, $backup_dir);
    say $backup_file;

    # 复制日志文件到备份目录
    try {
        $log_file.IO.copy($backup_file);
        say "日志文件已备份到: $backup_file";
    }
    CATCH {
        say "备份失败: $_";
        return;
    }
    say "empty $log_file";
    spurt($log_file,"");

    # 清理旧备份
    my @backups = $backup_dir.IO.dir.sort({ .modified }).reverse;
    if @backups.elems > $max_backups {
        for @backups[$max_backups .. *] -> $old_backup {
            say "删除旧备份: $old_backup";
            $old_backup.unlink;
        }
    }
}


sub MAIN($log = "m", $backup_dir = "$*HOME/log")
{
    my $log_file = "";
    if ($log ~~ "m") {
        $log_file = "$*HOME/log/mining.log";
    }
    if ($log ~~ "p") {
        $log_file = "$*HOME/log/plot_gpu.log";
    }
    if ($log ~~ "c") {
        $log_file = "$*HOME/log/copy.log";
    }
    if ($log ~~ "w") {
        $log_file = "$*HOME/log/write.log";
    }
    say $log_file;
    say $backup_dir;
    backup_log($log_file, $backup_dir);
}