#!/bin/bash


sudo cpan JSON

sudo apt-get install -y libssl-dev ethtool libnl-genl-3-dev git

wget http://download.aircrack-ng.org/aircrack-ng-1.2-rc4.tar.gz
tar -xvf aircrack-ng-1.2-rc4.tar.gz
cd aircrack-ng-1.2-rc4
sudo make
sudo make install
cd ..
mkdir server
cd server
git clone https://github.com/sn1p3r46/stationData.git
cd ..
