#!/bin/bash

masa=`date +%H_%M_%S`
tmpdpa=/tmp/tmp_dpa_"$masa"

mkdir "$tmpdpa"
mount -t cifs //uncle.wysdm.lab.emc.com/build/dpa "$tmpdpa" -o user=WYSDM/talibr,pass=irix293
echo
echo "SUCCESSFULLY MOUNT DPA's directory to $tmpdpa"
echo
# ls /tmp/tmp_dpa_13_44_50/*/*/*/DPA-Server*Linux-x86_64*[0-9].bin

newbuild=`ls -lrt  "$tmpdpa"/*/*/*/DPA-Server*Linux-x86_64*[0-9].bin | grep -v Patch | tail -1 | awk -F"/" '{print $(NF-1)"/"$NF}' | awk '{print $NF}'`
echo
echo "NEWBUILD is $newbuild"
echo
echo
echo "DPA's stockwell mounted"
echo "-----------------------"
df | grep -i /tmp/tmp_dpa | awk '{print NR"\t"$NF}' 
echo
