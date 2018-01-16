 #!/bin/bash

masa=`date +%H_%M_%S`
tmpdpa=/tmp/tmp_dpa_"$masa"
tmp1=/tmp/dpa_ver_info.txt
tmp2=/tmp/dpa_ver_dir1
tmp3=/tmp/dpa_ver_dir2
tmp4=/tmp/tmp_dpa1

mkdir "$tmpdpa"
mount -t cifs //uncle.wysdm.lab.emc.com/build/dpa/stockwell "$tmpdpa" -o user=WYSDM/talibr,pass=irix293

df_k=`df -k | grep -i "$tmpdpa" | wc -l`
echo
if [ $df_k -gt 0 2> /dev/null ]
then
echo "Successfully mount CIFS //uncle.wysdm.lab.emc.com/build/dpa/stockwell to $tmpdpa"
echo
else
echo "PROBLEM mount uncle.wysdm.lab.emc.com/build/dpa/stockwell to $tmpdpa"
rmdir "$tmpdpa"
echo
exit
fi

echo
echo "Choose Build to check :"
echo "-----------------------"

# ls -lrt "$tmpdpa"/[linu-win]*x64/*/DPA-Server* | grep -vi DebugFiles | awk '{print NR"\t"$NF"\t""["$(NF-3)$(NF-2)"_"$(NF-1)"]"}' | awk -F"/" '{print $1" "$NF}'
# ls -lrt "$tmpdpa"/[linu-win]*x64/*/DPA-Server* | grep -vi DebugFiles | awk -F"/" '{print "#"NR"#"$NF"#"}' > "$tmp1"

ls -lrt "$tmpdpa"/*/*/DPA-Server* | grep -vi DebugFiles | awk '{print NR"\t"$NF"\t\t""["$(NF-3)$(NF-2)"_"$(NF-1)"]"}' | awk -F"/" '{print $1" "$NF}'
ls -lrt "$tmpdpa"/*/*/DPA-Server* | grep -vi DebugFiles | awk -F"/" '{print "#"NR"#"$NF"#"}' > "$tmp1"

echo
echo -n "Build choosen [ No / Filename ] : "
read -e buildchk1

filechk2=`cat "$tmp1" | grep -i "#$buildchk1#" | cut -d# -f3`

# filechk1=`ls "$tmpdpa"/[linu-win]*x64/*/"$filechk2"`

filechk1=`ls "$tmpdpa"/*/*/"$filechk2"`
checkje1=`cat "$tmp1" | grep -i "#$buildchk1#" | cut -d# -f2`

if [ $checkje1 -gt 0 2> /dev/null ]
then

oldtime2=`date +%s`
oldtime1=`date +%H:%M:%S`

echo
echo "Build to check = $filechk1"
cmd1=`echo "$filechk1" | awk -F. '{print $NF}'`
echo

if [ $cmd1 == tar ]
then

mkdir "$tmp2" && tar xvf "$filechk1" --directory "$tmp2" Disk1/InstData/Resource1.zip

elif [ $cmd1 == zip ]
then

mkdir "$tmp4" && unzip "$filechk1" -d "$tmp4" install.exe && \
unzip "$tmp4"/install.exe  -d "$tmp4" InstallerData/Disk1/InstData/Resource1.zip 
rm -rf "$tmp4"/install.exe
mkdir "$tmp2" && mv "$tmp4"/InstallerData/Disk1 "$tmp2"/Disk1 
rm -rf "$tmp4" 

else

echo
echo "Installer build format unknown"
echo

fi

umount "$tmpdpa" && rmdir "$tmpdpa"

echo
unzip "$tmp2"/Disk1/InstData/Resource1.zip -d "$tmp3" '$DPA6_EAR$'/apollo.ear '$DPA6_EAR$'/dpa.ear '$DPA6_EAR$'/ui.war
echo
unzip "$tmp3"/'$DPA6_EAR$'/apollo.ear -d . META-INF/MANIFEST.MF
cp -rf META-INF/MANIFEST.MF tmp_apollo.txt && rm -rf META-INF
dos2unix tmp_apollo.txt
echo
unzip "$tmp3"/'$DPA6_EAR$'/dpa.ear -d . META-INF/MANIFEST.MF
cp -rf META-INF/MANIFEST.MF tmp_dpa.txt && rm -rf META-INF
dos2unix tmp_dpa.txt
echo
unzip "$tmp3"/'$DPA6_EAR$'/ui.war -d . META-INF/MANIFEST.MF
cp -rf META-INF/MANIFEST.MF tmp_ui.txt && rm -rf META-INF
dos2unix tmp_ui.txt
echo
echo
apollo_ver=`cat tmp_apollo.txt | awk -F: '{print $1,"\t\t",$2}' | grep -i "Build-Job" | awk '{print $2}'`
dpa_ver=`cat tmp_dpa.txt | awk -F: '{print $1,"\t\t",$2}' | grep -i "Build-Job" | awk '{print $2}'`
ui_ver=`cat tmp_ui.txt | grep -i Implementation-Build-Job | awk '{print $2}'`
buildver1=`echo $filechk1 | awk -F"/" '{print $(NF-1)}'`
buildful1=`echo $filechk1 | awk -F"-" '{print $NF}' | awk -F".tar" '{print $1}' | awk -F".zip" '{print $1}'`

echo "DPA INSTALLER VERSION $buildful1"
echo "==============================="
echo "APOLLO VERSION = $apollo_ver"
echo "DPA VERSION    = $dpa_ver"
echo "UI VERSION     = $ui_ver"
echo
echo "FOR REPORT PURPOSE -- Installer $buildver1 (Apollo#$apollo_ver, DPA#$dpa_ver, UI#$ui_ver)"
echo

newtime2=`date +%s`
newtime1=`date +%H:%M:%S`
time1=$(( $newtime2 - $oldtime2 ))
hour1=$((( $time1 / 60 ) / 60 ))
minit1=$((( $time1 / 60 ) - ( $hour1 * 60 )))
second1=$(( $time1 - ( $hour1 * 60 * 60 ) - ( $minit1 * 60 )))

echo "Time taken = from $oldtime1 to $newtime1 = $hour1:$minit1:$second1 "
echo

rm -rf tmp_apollo.txt tmp_dpa.txt tmp_ui.txt "$tmp1" "$tmp2" "$tmp3" 

else

rm -rf "$tmp1"
echo
echo "WRONG INPUT - $buildchk1 is not exist in the list"
umount "$tmpdpa" && rmdir "$tmpdpa"
echo

fi
