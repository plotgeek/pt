# plot_task

## install
```
sudo apt install rakudo
```

## create plot task
```
rakudo main.raku sda,sdb,sdc,sdd,sde,sdf
```

## stop plot task
```
rakudo main.raku sda,sdb,sdc,sdd,sde,sdf stop
or 
rakudo main.raku 3452.sdb stop
rakudo main.raku 4563.sdb stop 
```

## add plots dir
```
rakudo main.raku  sda,sdb,sdc  add
```

## remove plots dir
```
rakudo main.raku  sda,sdb,sdc  remove
```

## clean t1 & t2 & plots
clean t1 t2, and plots dir which file size < 100GB
```
rakudo main.raku sda,sdb,sdc  clean
or
rakudo main.raku sda-sdl clean
or 
rakudo main.raku a-l clean
```

## format disks
```
sudo rakudo main.raku sdb,sdc,sdd format
```

## remove sysfile 
```
rakudo main.raku b-l rmsys
```




