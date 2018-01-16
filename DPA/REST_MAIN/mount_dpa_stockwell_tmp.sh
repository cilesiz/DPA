#!/bin/bash

masa=`date +%H_%M_%S`
tmpdpa=/tmp/tmp_dpa_"$masa"

mkdir "$tmpdpa"
mount -t cifs //uncle.wysdm.lab.emc.com/build/dpa/stockwell "$tmpdpa" -o user=WYSDM/talibr,pass=irix293
echo
echo "SUCCESSFULLY MOUNT DPA's stockwell directory to $tmpdpa"
echo

newbuild=`ls -lrt  "$tmpdpa"/linux64/*/DPA-Server-Linux*tar | tail -1 | awk -F"/" '{print $(NF - 1)}' | awk '{print $NF}'`
echo
echo "NEWBUILD is $newbuild"
echo
echo
echo "DPA's stockwell mounted"
echo "-----------------------"
df | grep -i /tmp/tmp_dpa | awk '{print NR"\t"$NF}' 
echo
