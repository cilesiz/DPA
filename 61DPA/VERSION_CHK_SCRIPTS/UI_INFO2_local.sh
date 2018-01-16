#!/bin/bash

echo
chkcfgdpa=`ls -al /etc/init.d/*applnsvc* | wc -l`

if [ x"$chkcfgdpa" == x1 ]; then

wheredpa=`ls -al /etc/init.d/*agent* | grep -i dpa | awk '{print $NF}' | sed -e "s/\/agent\/etc\/dpa//g"`

echo

unzip "$wheredpa"/services/applications/ui.war -d . META-INF/MANIFEST.MF
cp -rf META-INF/MANIFEST.MF tmp_dpa_ui.txt && rm -rf META-INF
dos2unix tmp_dpa_ui.txt

echo
echo "DPA UI INFORMATION"
echo "==============="
cat tmp_dpa_ui.txt | awk -F: '{print $1,"\t\t",$2}'

rm -rf tmp_dpa_ui.txt

else
echo; echo "This server did not run DPA Application"; echo
# exit

fi
