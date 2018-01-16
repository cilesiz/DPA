#!/bin/bash

echo

unzip /opt/emc/dpa/services/applications/ui.war -d . META-INF/MANIFEST.MF
cp -rf META-INF/MANIFEST.MF tmp_dpa_ui.txt && rm -rf META-INF

echo
echo "DPA UI INFORMATION"
echo "==============="
cat tmp_dpa_ui.txt | awk -F: '{print $1,"\t\t",$2}'

rm -rf tmp_dpa_ui.txt
