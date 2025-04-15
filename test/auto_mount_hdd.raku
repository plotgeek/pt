use v6;

# 定义常量
constant $LSBLK_CMD = 'lsblk -o NAME,MOUNTPOINT -n';
constant $MOUNT_BASE_DIR = '/';  # 挂载点基础目录

# 获取硬盘信息
sub get-disk-info() {
    my @disks;
    my $output = run(:out, $LSBLK_CMD.split(' ')).out.slurp;
    for $output.lines -> $line {
        my ($name,$mountpoint) = $line.words;
        next if $name ~~ /^loop/;  # 忽略 loop 设备

        @disks.push: {
            name       => "/dev/$name",
            mountpoint => $mountpoint // '',
        };
    }
    return @disks;
}

# 创建挂载点目录
sub create-mount-point(Str $mount-dir --> Bool) {
    unless $mount-dir.IO.d {
        shell("mkdir -p $mount-dir");
        return True;
    }
    return False;
}

# 动态挂载硬盘
sub mount-disks() {
    my @disks = get-disk-info();
    unless @disks.elems {
        say "未检测到任何可用硬盘！";
        return;
    }

    for @disks -> %disk {
    	say %disk<name>;
        #next if %disk<mountpoint>;  # 忽略已挂载的分区

	
        # 确定挂载点
        my $mount-dir = "/" ~ %disk<name>.IO.basename;

	say $mount-dir;
        # 创建挂载点
        #create-mount-point($mount-dir);

        # 尝试挂载
        #my $cmd = "mount -t %disk<fstype> $identifier $mount-dir";
        #my $result = shell($cmd);
        #if $result.exitcode == 0 {
        #    say "成功挂载 %disk<name> 到 $mount-dir";
        #} else {
        #    say "挂载失败：%disk<name>";
        #}
    }
}

# 主程序
sub MAIN() {
    say "正在检测并挂载硬盘...";
    mount-disks();
}