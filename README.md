# plots management tool


All disk's mount point format are  "/sd" + "devcie name", eg. "/dev/sdb" mount point is "/sdb"  
```
nvme ssd mount dir:  /sdnv1, /sdnv2, /sdnv3 ...     
                  :  /sdnv1/plots, /sdnv2/plots, /sdnv3/plots ...   
hdd disk mount dir:  /sdb, /sdc, /sdd ...   
                  :  /sdb/plots, /sdc/plots, /sdd/plots ...    
t1 temp dir:         /sdb/t1, /sdc/t1, /sdd/t1 ...   
t2 temp dir:         /sdb/t2, /sdc/t2, /sdd/t2 ...   
```

[PT commands](https://github.com/plotgeek/pt/blob/memplot/PT.png)  
```
pt <dirs/hosts>  [cmds]  [args]  
nossd <dirs> [cmds] [args]  
mmx   <dirs> [cmds] [args]   
nfs [cmds]
```

$\mathbf{pt}$  
```
1)  format -> copy/write  -> umount  
2)  count-> clean -> test 
3)  mount->mount nfs  
4)  add -> add mmx -> add nfs     
5)  nfs -> mount -> add   
6)  log -> stat -> scp 
```
$\mathbf{nossd}$  
```
1) nossd b-z fpt
2) nossd b-z spt
```
$\mathbf{mmx}$ 

```
1) mmx  nv1   
2) mmx  nv1 copy  
3) mmx  b-z  write  
```
$\mathbf{nfs}$ 
```
1) nfs mount
2) nfs add
```


## install
```
sudo apt install rakudo
```





