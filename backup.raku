#!/usr/bin/env rakudo

# 配置参数
my $log_file = "$*HOME/log/mining.log";          # 日志文件路径
my $backup_dir = "$*HOME/log";        # 备份目录
my $interval = 3600;                                 # 定时间隔（秒）
my $max_backups = 5;                                 # 最大保留备份数量

# 确保备份目录存在
mkdir $backup_dir unless $backup_dir.IO.e;

# 定义备份函数
sub backup_log() {
    say "开始备份日志文件...";

    # 检查日志文件是否存在
    unless $log_file.IO.e {
        say "日志文件不存在: $log_file";
        return;
    }

    # 创建带时间戳的备份文件名
    my $timestamp = DateTime.now.Str.subst(/T/, '_', :g).subst(/Z/, '', :g);
    my $backup_file = "$backup_dir/logfile_backup_$timestamp.log";

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

# 定时触发备份任务
#say "启动定时备份任务，每隔 {$interval} 秒执行一次...";
#Supply.interval($interval).tap: {
    backup_log();
#};