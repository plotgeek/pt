#!/usr/bin/sh
sudo apt install rakudo -y
git clone https://github.com/plotmanager/pt
sudo cp -r pt /usr/local/pt
echo 'export PERL6LIB="/usr/local/pt/lib"' >>  ~/.bashrc
source  ~/.bashrc
sudo ln -s /usr/local/pt/plotter.raku  /usr/local/bin/plotter
sudo ln -s /usr/local/pt/pt.raku /usr/local/bin/pt
sudo chmod a+rwx /usr/local/bin/plotter
sudo chmod a+rwx /usr/local/bin/pt
