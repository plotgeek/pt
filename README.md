# chia plots tool

## install
```
sudo apt install tmux rakudo emacs-nox jq unzip gcc g++ cmake make lrzsz  smartmontools nfs-kernel-server nfs-common -y
```
## requirement
Mount point format:
```
"/sd" + "device name"
```
```
e.g "/dev/sdb" mount point is "/sdb"

nvme ssd mount dir:  /sdnv1, /sdnv2, /sdnv3 ...     
                  :  /sdnv1/plots, /sdnv2/plots, /sdnv3/plots ...   
hdd disk mount dir:  /sdb, /sdc, /sdd ...   
                  :  /sdb/plots, /sdc/plots, /sdd/plots ...    
t1 temp dir:         /sdb/t1, /sdc/t1, /sdd/t1 ...   
t2 temp dir:         /sdb/t2, /sdc/t2, /sdd/t2 ...   
```

## [pt commands](https://github.com/plotgeek/pt/blob/memplot/PT.png)   
```
there are two conf files: 
[Conf.pm] is for plotting args.  
[nfs.conf] is for nfs args.  
```
```
pt <dirs/hosts>  [cmds]  [args]  
nossd <dirs> [cmds] [args]  
mmx   <dirs> [cmds] [args]   
nfs [cmds]
```

### pt
```
1)  format -> copy/write  -> umount  
2)  count-> clean -> test 
3)  mount-> mount nfs  
4)  nfs -> mount
5)  log -> stat -> scp 
6)  snum/temp
7)  auth
```
### nossd  
```
1) nossd3 nv0 gpu_index
2) nossd3 b-z gpu_index1,gpu_index2...
```
### mmx 

```
1) mmx  nv1   
2) mmx  nv1 copy  
3) mmx  b-z  write  
```
### nfs
```
1) nfs mount/umount/stop/restart
```







