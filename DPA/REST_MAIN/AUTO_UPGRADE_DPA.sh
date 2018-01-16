#!/bin/bash

pwd1=/root/rosli/DPA
masa=`date +%H_%M_%S`
tmpdpa=/tmp/tmp_dpa_"$masa"

#### DELETE ALL EXISTING INSTALLER FILES / DIRECTORIES

echo
rm -rf "$pwd1"/build/Disk1
rm -rf "$pwd1"/build/install.bin
echo
echo "SUCCESSFULLY DELETE Disk1 & install.bin"
echo

#### COPY AND EXTRACT NEW BUILD FROM uncle.wysdm.lab.emc.com TO INSTALLATION DIRECTORY

mkdir "$tmpdpa"
mount -t cifs //uncle.wysdm.lab.emc.com/build/dpa/stockwell "$tmpdpa" -o user=WYSDM/talibr,pass=irix293
# ln -s "$tmpdpa" /tmp_dpa_stockwell
echo
echo "SUCCESSFULLY MOUNT DPA's stockwell directory"
echo

# newbuild=`ls -rt "$tmpdpa"/linux64 | tail -1`
newbuild=`ls -lrt  "$tmpdpa"/linux64/*/DPA-Server-Linux*tar | tail -1 | awk -F"/" '{print $(NF - 1)}' | awk '{print $NF}'`
echo
echo "NEWBUILD is $newbuild"
buildno=`echo "$newbuild" | cut -db -f2`

cp -rf "$tmpdpa"/linux64/"$newbuild"/DPA-Server*Linux-x64*6.0*"$buildno".tar "$pwd1"/build && \
umount "$tmpdpa" && rmdir "$tmpdpa" 
echo
echo "SUCCESSFULLY COPY NEWBUILD to $pwd1/build"

echo
echo "Extracting $pwd1/build/DPA-Server*Linux-x64*6.0*$buildno.tar"
cd "$pwd1"/build
tar xvf "$pwd1"/build/DPA-Server*Linux-x64*6.0*"$buildno".tar

#### KILL ANY DPA PROCESS 

ps -ef | grep -i /opt/emc/dpa | grep -v grep | awk '{print $2}' | xargs kill -9
echo
echo "SUCCESSFULLY KILL DPA PROCESS ID"
echo

#### UNINSTALL CURRENT RUNNING BUILD COMPLETELY

echo
cd /opt/emc/dpa/_uninst
echo "\r" | ./uninstalldpa
echo
echo "SUCCESSFULLY UNINSTALL CURRENT RUNNING BUILD"
echo

#### INSTALL LATEST BUILD

cd "$pwd1"/build
((for i in `seq 1 1 39`; \
do \
echo "\r" ; \
done); \
echo "Y"; \
echo "1"; \
echo "/opt/emc/dpa"; \
echo "Y"; \
(for i in `seq 1 1 3`; \
do echo "2" ; \
done); \
(for i in `seq 1 1 3`; \
do echo "\r" ; \
done)) | ./install.bin
echo
echo
echo "FINISHED INSTALL LATEST BUILD $buildno"
echo "======================================"
echo
