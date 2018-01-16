#!/bin/bash

pwd1=/root/rosli/61DPA
masa=`date +%H_%M_%S`
tmpdpa=/tmp/tmp_dpa_"$masa"

#### DELETE ALL EXISTING INSTALLER FILES / DIRECTORIES

echo
# rm -rf "$pwd1"/build/Disk1
# rm -rf "$pwd1"/build/install.bin
# echo
# echo "SUCCESSFULLY DELETE Disk1 & install.bin"
# echo

#### COPY AND EXTRACT NEW BUILD FROM uncle.wysdm.lab.emc.com TO INSTALLATION DIRECTORY

mkdir "$tmpdpa"
# mount -t cifs //uncle.wysdm.lab.emc.com/build/dpa/trunk/server "$tmpdpa" -o user=WYSDM/talibr,pass=irix293
mount -t cifs //uncle.wysdm.lab.emc.com/build/dpa/trunk "$tmpdpa" -o user=WYSDM/talibr,pass=irix293
echo
echo "SUCCESSFULLY MOUNT DPA's trunk 6.1.0/server directory"
echo

newbuild=`ls -lrt  "$tmpdpa"/*/server/DPA-Server*Linux-x86_64*[0-9].bin | grep -v Patch | tail -1 | awk -F"/" '{print $(NF - 1)}' | awk '{print $NF}'`
newinstaller=`ls -lrt  "$tmpdpa"/*/server/DPA-Server*Linux-x86_64*[0-9].bin | grep -v Patch | tail -1 | awk -F"/" '{print $NF}'`
echo
echo "NEWBUILD is $newbuild"
buildno=`echo "$newbuild" | cut -db -f2`

cp -rf "$tmpdpa"/"$newbuild"/"$newinstaller" "$pwd1"/build && \
umount "$tmpdpa" && rmdir "$tmpdpa" 
echo
echo "SUCCESSFULLY COPY NEWBUILD to $pwd1/build"

echo

#### KILL ANY DPA PROCESS 

ps -ef | grep -i /opt/emc/dpa | grep -v grep | awk '{print $2}' | xargs kill -9
echo
echo "SUCCESSFULLY KILL DPA PROCESS ID"
echo

#### UNINSTALL CURRENT RUNNING BUILD COMPLETELY

echo
cd /opt/emc/dpa/_uninstall
echo "\r" | ./Uninstall_Data_Protection_Advisor
echo
echo "SUCCESSFULLY UNINSTALL CURRENT RUNNING BUILD"
echo

#### INSTALL LATEST BUILD

cd "$pwd1"/build
((for i in `seq 1 1 63`; \
do \
echo "\r" ; \
done); \
echo "Y"; \
echo "3"; \
echo "/opt/emc/dpa"; \
echo "Y"; \
(for i in `seq 1 1 3`; \
do echo "\r" ; \
done)) | ./"$newinstaller"

echo -n "BUILD $buildno - $newinstaller at " >> "$pwd1"/INFO_DPA_SVR.txt
date "+%d/%m/%Y %H:%M:%S" >> "$pwd1"/INFO_DPA_SVR.txt

echo
echo
echo "FINISHED INSTALL LATEST BUILD $buildno - $newinstaller"
echo "======================================"
echo
