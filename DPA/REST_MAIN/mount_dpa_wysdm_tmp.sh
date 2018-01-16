#!/bin/bash

masa=`date +%H_%M_%S`
tmpdpa=/tmp/tmp_dpa_"$masa"

mkdir "$tmpdpa"
mount -t cifs //uncle.wysdm.lab.emc.com/wysdm "$tmpdpa" -o user=WYSDM/talibr,pass=irix293
echo
echo "SUCCESSFULLY MOUNT DPA's wysdm directory to $tmpdpa"
echo

echo
echo "DPA's wysdm mounted"
echo "-----------------------"
df | grep -i /tmp/tmp_dpa | awk '{print NR"\t"$5}' 
echo
