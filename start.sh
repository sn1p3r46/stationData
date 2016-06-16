#!/bin/bash

sudo killall server.pl
sudo killall dump.pl
sudo killall airodump-ng
sudo ./server.pl -p 7777 &
#./server.pl -p 7778 &
#./server.pl -p 7779 &
#./server.pl -p 7780 &
#./server.pl -p 7781 &
sleep 2
sudo ./dump.pl
