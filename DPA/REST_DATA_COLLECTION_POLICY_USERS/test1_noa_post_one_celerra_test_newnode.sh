#!/bin/bash

HB_DPA=10.64.205.162
user1=dcp_noa
pswd1=dcp_noa

URL1=http://"$HB_DPA":9004/apollo-api/nodes

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
      <node type="Celerra">
        <name>uncle-mgmt.wysdm.lab.emc.com</name>
        <displayName>uncle-mgmt</displayName>
        <creatorType>apollo</creatorType>
      </node>
' "$URL1" > tmp1.txt

echo
echo
echo
rm -rf tmp1.txt 
