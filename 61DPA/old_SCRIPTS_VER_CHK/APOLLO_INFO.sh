#!/bin/bash

echo

unzip /opt/emc/dpa/services/applications/apollo.ear -d . META-INF/MANIFEST.MF
cp -rf META-INF/MANIFEST.MF tmp_apollo.txt && rm -rf META-INF
dos2unix tmp_apollo.txt

echo
echo
echo "APOLLO INFORMATION"
echo "=================="
cat tmp_apollo.txt | awk -F: '{print $1,"\t\t",$2}'

rm -rf tmp_apollo.txt 
