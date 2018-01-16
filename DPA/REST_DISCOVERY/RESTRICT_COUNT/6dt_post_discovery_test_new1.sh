#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/discovery/tests

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
 <test type="ping" version="1">
  <names>
    <name>uncle-mgmt.wysdm.lab.emc.com</name>
    <name>uncle-mgmt</name>
    <name>10.64.205.18</name>
  </names>
</test> 
' "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp1.txt 
