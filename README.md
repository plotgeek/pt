# memplot tool
PT is designed for bladebit

nvme mount at: /sdnv1, /sdnv2, /sdnv3 ...  
plots at: /sdnv1/plots, /sdnv2/plots, /sdnv3/plots ... 


## install
```
sudo apt install rakudo
```

## create plot task
```
rakudo ploter.raku nv1,nv2,nv3 create
or 
rakudo ploter.raku nv1,nv2,nv3
or 
rakudo ploter.raku nv1,nv2,nv3  create b838e026155f6c1484b719820c2de2d8f4181f5fd5741be80b00c405d0a16865c877ce9f6e47a306dc6225cc6f3cefb5  xch1grt0qhtttrm04pts5v0lzzgc7kdysu775472k6agptnfdvpmhvvs020tmd
```

to view plot task
```
tmux ls  
```

## stop plot task
```
rakudo pt.raku b stop
or 
rakudo pt.raku b-l stop
```

## add plots dir
```
rakudo pt.raku  b-l  add
```

## clean t1 & t2 & plots
clean t1 t2, and plots dir which file size < 100GB
```
rakudo pt.raku a-l clean
```

## format disks
```
sudo rakudo pt.raku b-l format
```


## rmall
rmall op default delete 2 plots, or use the args
```
rakudo pt.raku b-l rmall
or
rakudo pt.raku b rmall
or 
rakudo pt.raku b rmall 5
```


## misc op
remove sysfile 
```
rakudo pt.raku b-l rmsys
```



