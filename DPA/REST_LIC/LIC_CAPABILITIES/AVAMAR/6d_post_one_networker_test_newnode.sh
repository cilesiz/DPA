#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/nodes

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
      <node type="Networker">
        <name>testnetworker.wysdm.lab.emc.com</name>
        <displayName>testnetworker</displayName>
        <creatorType>apollo</creatorType>
      </node>
' "$URL1" 

echo
echo
echo
