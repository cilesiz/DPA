#!/bin/bash

HB_DPA=10.64.205.162
login1=administrator
paswd1=administrator
login2=emc.dpa.agent.logon
paswd2=4BtByG4rTnNcQpZr!

echo

unzip /opt/emc/dpa/services/applications/apollo.ear -d . META-INF/MANIFEST.MF
cp -rf META-INF/MANIFEST.MF tmp_apollo.txt && rm -rf META-INF

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
cat tmp_apollo.txt
echo
cat tmp_dpa.txt
echo
cat tmp_server.txt
echo
echo
cat tmp_ui.txt
echo
echo



rm -rf tmp_apollo.txt tmp_dpa.txt tmp_server.txt tmp_ui.txt
