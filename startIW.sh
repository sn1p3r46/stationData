#!/bin/bash

sudo killall serverIW.pl
sudo killall dump.pl
sudo killall airodump-ng
./serverIW.pl -p 7777 &
./serverIW.pl -p 7778 &
./serverIW.pl -p 7779 &
./serverIW.pl -p 7780 &
./serverIW.pl -p 7781 &
#sudo ./dump.pl
