#!/bin/bash

HB_DPA=10.64.205.162
login1=administrator
paswd1=administrator
login2=emc.dpa.agent.logon
paswd2=4BtByG4rTnNcQpZr!

echo

unzip /opt/emc/dpa/services/applications/apollo.ear -d . META-INF/MANIFEST.MF
cp -rf META-INF/MANIFEST.MF tmp_apollo.txt && rm -rf META-INF

echo 

unzip /opt/emc/dpa/services/applications/dpa.ear -d . META-INF/MANIFEST.MF
cp -rf META-INF/MANIFEST.MF tmp_dpa.txt && rm -rf META-INF

echo

curl -u "$login1":"$paswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET http://"$HB_DPA":9004/dpa-api/server/status > tmp_server.txt

echo

curl -u "$login1":"$paswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET http://"$HB_DPA":9004/ui/version.jsp > tmp_ui.txt

if [ -s tmp_ui.txt ]
then

echo
curl -u "$login1":"$paswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET http://"$HB_DPA":9004/ui/version.jsp > tmp_ui.txt

fi

echo
echo
echo "APOLLO INFORMATION"
echo "=================="
cat tmp_apollo.txt | awk -F: '{print $1,"\t\t",$2}'

echo
echo "DPA INFORMATION"
echo "==============="
cat tmp_dpa.txt | awk -F: '{print $1,"\t\t",$2}'

echo
echo "SERVER INFORMATION"
echo "=================="
cat tmp_server.txt | sed -n '/<version/,//p' | awk -F"<" '{print $1,$2}' | awk -F">" '{print $1,"\t",$2}' | grep -v "/version"
echo
echo "UI INFORMATION"
echo "=============="
cat tmp_ui.txt | grep -i title | awk -F">" '{print $2}' | awk -F"</title" '{print $1}'
cat tmp_ui.txt | grep -v thead | egrep -i "Version|Build|Revision" | awk -F">" '{print $3,"\t",$5}' | awk -F"</td" '{print $1, $2}'
echo

rm -rf tmp_apollo.txt tmp_dpa.txt tmp_server.txt tmp_ui.txt
