# plots management tool


requirements:    
all disks mounted at dir  "/sd" + "disk name", eg. "/dev/sdb" mounted at dir "/sdb"  
```
nvme ssd mount dir:  /sdnv1, /sdnv2, /sdnv3 ...     
                  :  /sdnv1/plots, /sdnv2/plots, /sdnv3/plots ...   
hdd disk mount dir:  /sdb, /sdc, /sdd ...   
                  :  /sdb/plots, /sdc/plots, /sdd/plots ...    
t1 temp dir:         /sdb/t1, /sdc/t1, /sdd/t1 ...   
t2 temp dir:         /sdb/t2, /sdc/t2, /sdd/t2 ...   
```

![PT操作步骤](https://github.com/plotgeek/pt/blob/memplot/PT.png)


## install
```
sudo apt install rakudo
```





