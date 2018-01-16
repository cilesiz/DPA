#!/bin/bash

masa=`date +%H_%M_%S`
# tmpdpa=/root/rosli/61DPA/SCRIPTS_VER_CHK/build
tmpdpa=/root
tmp1=/tmp/dpa_ver_info.txt
tmp2=/tmp/dpa_ver_dir1
tmp4=/tmp/tmp_dpa1

echo
echo "Choose Build to check :"
echo "-----------------------"

ls -lrt "$tmpdpa"/*DPA-Server* | awk '{print NR"\t"$NF"\t\t""["$(NF-3)$(NF-2)"_"$(NF-1)"]"}' | awk -F"/" '{print $1" "$NF}'
ls -lrt "$tmpdpa"/*DPA-Server* | awk -F"/" '{print "#"NR"#"$NF"#"}' > "$tmp1"

echo
echo -n "Build choosen [ No / Filename ] : "
read -e buildchk1

filechk2=`cat "$tmp1" | grep -i "#$buildchk1#" | cut -d# -f3`

filechk1=`ls "$tmpdpa"/"$filechk2"`
checkje1=`cat "$tmp1" | grep -i "#$buildchk1#" | cut -d# -f2`

if [ $checkje1 -gt 0 2> /dev/null ]
then

oldtime2=`date +%s`
oldtime1=`date +%H:%M:%S`

echo
echo "Build to check = $filechk1"
echo

mkdir "$tmp4" && \
unzip "$filechk1" -d "$tmp4" '$SERVER_SVN_ROOT$'/installer-layout/target/installer/common/apps/services/applications/apollo.ear
unzip "$filechk1" -d "$tmp4" '$SERVER_SVN_ROOT$'/installer-layout/target/installer/common/apps/services/applications/dpa.ear
unzip "$filechk1" -d "$tmp4" '$SERVER_SVN_ROOT$'/installer-layout/target/installer/common/apps/services/applications/ui.war
mkdir "$tmp2" && \
mv "$tmp4"/'$SERVER_SVN_ROOT$'/installer-layout/target/installer/common/apps/services/applications/apollo.ear "$tmp2" 
mv "$tmp4"/'$SERVER_SVN_ROOT$'/installer-layout/target/installer/common/apps/services/applications/dpa.ear "$tmp2"
mv "$tmp4"/'$SERVER_SVN_ROOT$'/installer-layout/target/installer/common/apps/services/applications/ui.war "$tmp2"
rm -rf "$tmp4" 

echo
echo
unzip "$tmp2"/apollo.ear -d . META-INF/MANIFEST.MF
cp -rf META-INF/MANIFEST.MF tmp_apollo.txt && rm -rf META-INF
dos2unix tmp_apollo.txt
echo
unzip "$tmp2"/dpa.ear -d . META-INF/MANIFEST.MF
cp -rf META-INF/MANIFEST.MF tmp_dpa.txt && rm -rf META-INF
dos2unix tmp_dpa.txt
echo
unzip "$tmp2"/ui.war -d . META-INF/MANIFEST.MF
cp -rf META-INF/MANIFEST.MF tmp_ui.txt && rm -rf META-INF
dos2unix tmp_ui.txt
echo
echo
apollo_ver=`cat tmp_apollo.txt | awk -F: '{print $1,"\t\t",$2}' | grep -i "Build-Job" | awk '{print $2}'`
dpa_ver=`cat tmp_dpa.txt | awk -F: '{print $1,"\t\t",$2}' | grep -i "Build-Job" | awk '{print $2}'`
ui_ver=`cat tmp_ui.txt | grep -i Implementation-Build-Number | awk '{print $2}'`
buildver1=`echo $filechk1 | awk -F"/" '{print $NF}'`
buildful1=`echo $filechk1 | awk -F"-" '{print $NF}' | awk -F".bin" '{print $1}'`

echo "$buildver1"
echo "==============================="
echo "APOLLO VERSION = $apollo_ver"
echo "DPA VERSION    = $dpa_ver"
echo "UI VERSION     = $ui_ver"
echo
echo "FOR REPORT PURPOSE -- Installer $buildful1 (Apollo#$apollo_ver, DPA#$dpa_ver, UI#$ui_ver)"
echo

newtime2=`date +%s`
newtime1=`date +%H:%M:%S`
time1=$(( $newtime2 - $oldtime2 ))
hour1=$((( $time1 / 60 ) / 60 ))
minit1=$((( $time1 / 60 ) - ( $hour1 * 60 )))
second1=$(( $time1 - ( $hour1 * 60 * 60 ) - ( $minit1 * 60 )))

echo "Time taken = from $oldtime1 to $newtime1 = $hour1:$minit1:$second1 "
echo

rm -rf tmp_apollo.txt tmp_dpa.txt tmp_ui.txt "$tmp1" "$tmp2"  

else

rm -rf "$tmp1"
echo
echo "WRONG INPUT - $buildchk1 is not exist in the list"
echo

fi
