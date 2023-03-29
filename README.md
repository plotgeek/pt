# plots management tool


All disks mounted at dir  "/sd" + "disk name", eg. "/dev/sdb" mounted at dir "/sdb"  
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
pt <dir/hosts>  [cmds]  [args]  
  
disks mount point： /sdx  
/sdb  
/sdb/plots  
/sdb/t1  
/sdb/t2  

/sdnv1  
/sdnv1/plots  
/sdnv1/t1  
/sdnv1/t2  


pt: management tool  
1)  format/mount -> copy/write  -> umount  
2)  add->add mmx  
3)  nfs -> mount nfs  
4)  count-> clean -> test  
5)  log  

nossd plot   
nossd b-z fpt/spt  

mmx plot  
mmx  nv1   
mmx  nv1 copy  
mmx  b-z  write  
```



## install
```
sudo apt install rakudo
```





