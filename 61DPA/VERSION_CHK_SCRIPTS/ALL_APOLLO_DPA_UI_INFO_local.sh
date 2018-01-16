#!/bin/bash

echo
chkcfgdpa=`ls -al /etc/init.d/*applnsvc* | wc -l`

if [ x"$chkcfgdpa" == x1 ]; then

wheredpa=`ls -al /etc/init.d/*agent* | grep -i dpa | awk '{print $NF}' | sed -e "s/\/agent\/etc\/dpa//g"`

echo

unzip "$wheredpa"/services/applications/apollo.ear -d . META-INF/MANIFEST.MF
cp -rf META-INF/MANIFEST.MF tmp_apollo.txt && rm -rf META-INF
dos2unix tmp_apollo.txt

unzip "$wheredpa"/services/applications/dpa.ear -d . META-INF/MANIFEST.MF
cp -rf META-INF/MANIFEST.MF tmp_dpa.txt && rm -rf META-INF
dos2unix tmp_dpa.txt

unzip "$wheredpa"/services/applications/ui.war -d . META-INF/MANIFEST.MF
cp -rf META-INF/MANIFEST.MF tmp_dpa_ui.txt && rm -rf META-INF
dos2unix tmp_dpa_ui.txt

apollo_ver=`cat tmp_apollo.txt | awk -F: '{print $1,"\t\t",$2}' | grep -i "Build-Job" | awk '{print $2}'`
dpa_ver=`cat tmp_dpa.txt | awk -F: '{print $1,"\t\t",$2}' | grep -i "Build-Job" | awk '{print $2}'`
ui_ver=`cat tmp_dpa_ui.txt | grep -i Implementation-Build-Number | awk '{print $2}'`
builddpaver=`cat tmp_apollo.txt | awk -F: '{print $1,"\t\t",$2}' | grep -i "Implementation-Version" | awk '{print $2}'`

if [ x"$apollo_ver" == x ]; then
apollo_ver=NONE
patchlevel=`cat tmp_apollo.txt | awk -F: '{print $1,"\t\t",$2}' | grep -i "Built-By" | awk '{print "("$2")"}'`
else
patchlevel=`cat tmp_apollo.txt | awk -F: '{print $1,"\t\t",$2}' | grep -i "Patch-Level" | awk '{print $2}'`
fi

if [ x"$dpa_ver" == x ]; then
dpa_ver=NONE
fi

if [ x"$ui_ver" == x ]; then
ui_ver=NONE
fi

echo
echo
echo "DPA SERVER INFO"
echo "==============="
echo "APOLLO VERSION = $apollo_ver"
echo "DPA VERSION    = $dpa_ver"
echo "UI VERSION     = $ui_ver"
echo
echo "INSTALLER = $builddpaver b$patchlevel (Apollo#$apollo_ver, DPA#$dpa_ver, UI#$ui_ver)"
echo

rm -rf tmp_apollo.txt tmp_dpa.txt tmp_dpa_ui.txt

else

echo; echo "This server did not run DPA Application"; echo

fi

