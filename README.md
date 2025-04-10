# chia plots tool

## install
```
sh install.sh
```
Mount point format:
```
"/sd" + "alphabet"

for example: 
the device "/dev/sdb" 's mount point is "/sdb"

ssd format   :  /sdnv1, /sdnv2, /sdnv3 ...     
             :  /sdnv1/plots, /sdnv2/plots, /sdnv3/plots ...   
hdd format   :  /sdb, /sdc, /sdd ...   
             :  /sdb/plots, /sdc/plots, /sdd/plots ...    
```

## pt cli

Configure files: 
```
Conf.pm 
nfs.conf 
```

The main cmds:
```
pt <dirs/hosts>  [cmds]  [args]  
nossd <dirs> [cmds] [args]  
nfs [cmds]
backup
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
### nfs
```
1) nfs mount/umount/stop/restart
```

### backup
```
1) backup
```




