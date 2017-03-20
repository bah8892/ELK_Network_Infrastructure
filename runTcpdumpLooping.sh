#!/bin/sh
while :
do
echo "Press [CTRL+C] to stop.."
tcpdump -i enp2s0f1 -c 200000 -s 65535 -w /home/capture/pcap/day3/capture_$(date +%Y-%M-%d-%H:%M:%S).pcap

done
