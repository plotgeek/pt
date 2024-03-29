# chia & spacemesh plots tool

## install
```
sudo apt install rakudo jq 
```
## requirement
all disk's mount point format is like below 
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
bb  [cmds]
```

### pt
```
1)  format -> copy/write  -> umount  
2)  count-> clean -> test 
3)  mount->mount nfs  
4)  add -> add mmx -> add nfs     
5)  nfs -> mount -> add   
6)  log -> stat -> scp 
```
### nossd  
```
1) nossd b-z fpt
2) nossd b-z spt
```
### mmx 

```
1) mmx  nv1   
2) mmx  nv1 copy  
3) mmx  b-z  write  
```
### bb
```
1) bb nv1
2) pt nv1 copy
3) pt nv1 b-z write
```
### nfs
```
1) nfs mount
2) nfs add
```
### smh
```
smh mining mode
1) veth add/set/del
2) smh b-l p1-p4
```
```
smh plot mode
1) smh b 0-7
2) smh b 0-7 333-2559
```









