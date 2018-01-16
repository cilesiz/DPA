#!/bin/bash

masa=`date +%H_%M_%S`
tmpdpa=/tmp/tmp_dpa_"$masa"

current_build=`cat /var/.com.zerog.registry.xml | grep -i version | grep -i /opt/emc/dpa | tail -1 | awk -F"version=" '{print $2}' | awk -F"name=" '{print $1}' | awk -F'"' '{print $2}'`

#### COPY AND EXTRACT NEW BUILD FROM uncle.wysdm.lab.emc.com TO INSTALLATION DIRECTORY

mkdir "$tmpdpa"
mount -t cifs //uncle.wysdm.lab.emc.com/build/dpa/stockwell "$tmpdpa" -o user=WYSDM/talibr,pass=irix293

# echo
# echo "SUCCESSFULLY MOUNT DPA's stockwell directory"
# echo

newbuild=`ls -lrt  "$tmpdpa"/linux64/*/DPA-Server-Linux*tar | tail -1 | awk -F"/" '{print $(NF - 1)}'`
timenewbuild=`ls -lrt "$tmpdpa"/linux64/*/DPA-Server-Linux*tar | tail -1 | awk '{print $(NF-3)$(NF-2)"_"$(NF-1)}'`
newbuildqa=`ls -lrt "$tmpdpa"/winx64/qab*/DPA-Server*Windows-x64*zip | tail -1 | awk -F"/" '{print $(NF - 1)}'`
timenewbuildqa=`ls -lrt "$tmpdpa"/winx64/qab*/DPA-Server*Windows-x64*zip | tail -1 | awk '{print $(NF-3)$(NF-2)"_"$(NF-1)}'`

echo
echo "RUNNING BUILD = $current_build"
echo
echo "LATEST BUILD  = $newbuild ( $timenewbuild ) and $newbuildqa ( $timenewbuildqa )"
echo
umount "$tmpdpa" && rmdir "$tmpdpa"
