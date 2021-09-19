# plot_task

## install
```
sudo apt install rakudo
```

## create plot task
```
rakudo pt.raku b 
or 
rakudo pt.raku b-l
or 
rakudo pt.raku b-l  create b838e026155f6c1484b719820c2de2d8f4181f5fd5741be80b00c405d0a16865c877ce9f6e47a306dc6225cc6f3cefb5  xch1grt0qhtttrm04pts5v0lzzgc7kdysu775472k6agptnfdvpmhvvs020tmd
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

## remove plots dir
```
rakudo pt.raku b-l  remove
```

## clean t1 & t2 & plots
clean t1 t2, and plots dir which file size < 100GB
```
rakudo pt.raku sda,sdb,sdc  clean
or
rakudo pt.raku sda-sdl clean
or 
rakudo pt.raku a-l clean
```

## format disks
```
sudo rakudo pt.raku sdb,sdc,sdd format
```

## remove sysfile 
```
rakudo pt.raku b-l rmsys
```


## remove all 
```
rakudo pt.raku b-l rmall
```




