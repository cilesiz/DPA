#!/bin/bash

echo

unzip /opt/emc/dpa/services/applications/dpa.ear -d . META-INF/MANIFEST.MF
cp -rf META-INF/MANIFEST.MF tmp_dpa.txt && rm -rf META-INF
dos2unix tmp_dpa.txt

echo
echo "DPA INFORMATION"
echo "==============="
cat tmp_dpa.txt | awk -F: '{print $1,"\t\t",$2}'

rm -rf tmp_dpa.txt
