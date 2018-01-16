#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL2=http://"$HB_DPA":9004/apollo-api/nodes

echo

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
<node version="1">
   <name>uncle-mgmt.wysdm.lab.emc.com</name>
   <displayName>uncle-mgmt.wysdm.lab.emc.com</displayName>
   <globalName>Celerra</globalName>
   <aliases/>
</node>
' "$URL2" > tmp1.txt

echo
echo
cat tmp1.txt 
echo
echo

rm -rf tmp1.txt 
