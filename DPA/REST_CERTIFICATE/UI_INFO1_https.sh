#!/bin/bash

HB_DPA=10.64.205.162
login1=administrator
paswd1=administrator
port1=9002

echo
echo
portuse="$port1"
echo

curl -v -u "$login1":"$paswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET https://"$HB_DPA":"$portuse"/ui/version.jsp > tmp_ui.txt

echo
echo "UI INFORMATION"
echo "=============="
cat tmp_ui.txt | grep -i title | awk -F">" '{print $2}' | awk -F"</title" '{print $1}'
cat tmp_ui.txt | grep -v thead | egrep -i "Version|Build|Revision" | awk -F">" '{print $3,"\t",$5}' | awk -F"</td" '{print $1, $2}'
echo
echo

rm -rf tmp_ui.txt
