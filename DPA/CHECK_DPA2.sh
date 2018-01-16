#!/bin/bash

pwd1=/root/rosli/DPA
HB_DPA=10.64.205.162
login1=administrator
paswd1=administrator

echo

unzip /opt/emc/dpa/services/applications/apollo.ear -d . META-INF/MANIFEST.MF
cp -rf META-INF/MANIFEST.MF tmp_apollo.txt && rm -rf META-INF

echo

unzip /opt/emc/dpa/services/applications/dpa.ear -d . META-INF/MANIFEST.MF
cp -rf META-INF/MANIFEST.MF tmp_dpa.txt && rm -rf META-INF

echo

unzip /opt/emc/dpa/services/applications/ui.war -d . META-INF/MANIFEST.MF
cp -rf META-INF/MANIFEST.MF tmp_dpa_ui.txt && rm -rf META-INF

echo
curl -u "$login1":"$paswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET http://"$HB_DPA":9004/dpa-api/server/status > tmp_server.txt

echo
curl -u "$login1":"$paswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET http://"$HB_DPA":9004/ui/version.jsp > tmp_ui.txt

echo

apollo_ver=`cat tmp_apollo.txt | awk -F: '{print $1,"\t\t",$2}' | grep -i "Build-Job" | awk '{print $2}'`

dpa_ver=`cat tmp_dpa.txt | awk -F: '{print $1,"\t\t",$2}' | grep -i "Build-Job" | awk '{print $2}'`

servr_ver=`cat tmp_server.txt | sed -n '/<version/,//p' | awk -F"<" '{print $1,$2}' | awk -F">" '{print $1,"\t",$2}' | grep -v "/version" | grep -i build | awk '{print $2}'`

ui_ver=`cat tmp_dpa_ui.txt | grep -i Implementation-Build-Job | awk '{print $2}'`

echo "SERVER INFORMATION"
echo "=================="
echo "APOLLO VERSION = $apollo_ver"
echo "DPA VERSION    = $dpa_ver"
echo "SERVER VERSION = $servr_ver"
echo "UI VERSION     = $ui_ver"
echo
echo "SERVER INFORMATION" >> "$pwd1"/ver_info.log
echo "==================" >> "$pwd1"/ver_info.log
echo "DATE" `date +%H:%M:%S_%d/%m/%Y` >> "$pwd1"/ver_info.log
echo "APOLLO VERSION = $apollo_ver" >> "$pwd1"/ver_info.log
echo "DPA VERSION    = $dpa_ver" >> "$pwd1"/ver_info.log
echo "SERVER VERSION = $servr_ver" >> "$pwd1"/ver_info.log
echo "UI VERSION     = $ui_ver" >> "$pwd1"/ver_info.log

rm -rf tmp_apollo.txt tmp_dpa.txt tmp_server.txt tmp_dpa_ui.txt

#### Check Build Installer currently running

# pwd1=`pwd`
# pwd1=/root/rosli/DPA

echo "CURRENT INSTALLER"
echo "================="
current_build=`cat /var/.com.zerog.registry.xml | grep -i version | grep -i /opt/emc/dpa | tail -1 | awk -F"version=" '{print $2}' | awk -F"name=" '{print $1}' | awk -F'"' '{print $2}'`
# echo $current_build
current_build_no=`echo $current_build`
confirm1=`ls "$pwd1"/build/DPA-Server-Linux-x64* | tail -1 | awk -F"-" '{print $5}' | cut -d. -f1,2,3,4`
echo
echo "Installer Running Version = $current_build_no"
if [ $current_build_no == $confirm1 ]
then
echo "CONFIRM.... IN INST DIRECTORY = $confirm1"
else
echo "NOT SURE.... IN INST DIRECTORY $confirm1"
fi
echo
echo "Installer Running Version = $current_build_no" >> "$pwd1"/ver_info.log

### Check Build Installer latest in uncle.wysdm.lab.emc.com

masa=`date +%H_%M_%S`
tmpdpa=/tmp/tmp_dpa_"$masa"

mkdir "$tmpdpa"
mount -t cifs //uncle.wysdm.lab.emc.com/build/dpa/stockwell "$tmpdpa" -o user=WYSDM/talibr,pass=irix293
ln -s "$tmpdpa" /tmp_dpa

# newbuild=`ls -rt /tmp_dpa/linux64 | tail -1`
newbuild=`ls -lrt  /tmp_dpa/linux64/*/DPA-Server-Linux*tar | tail -1 | awk -F"/" '{print $(NF - 1)}' | awk '{print $NF}'`
newbuildno=`echo "$newbuild" | cut -db -f2`

echo "LATEST INSTALLER"
echo "================"
echo "Installer Latest Build = $newbuild"
echo "Installer Version = 6.0.0.$newbuildno"
echo "Installer Latest Build = $newbuild" >> "$pwd1"/ver_info.log
echo "Installer Version = 6.0.0.$newbuildno" >> "$pwd1"/ver_info.log
echo >> "$pwd1"/ver_info.log
echo

umount "$tmpdpa" && rmdir "$tmpdpa" && rm /tmp_dpa
