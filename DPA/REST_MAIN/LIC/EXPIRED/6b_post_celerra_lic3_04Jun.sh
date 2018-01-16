#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/license

echo
echo "BEFORE ADD LICENSE"
echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"
echo
echo
echo "ADD LICENSE"
echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -d '
   <license lastModified="2012-04-23T12:45:14.538Z">
      <name>1 Celerra NS960 licenses for EMC (822300)</name>
      <code>DPA-FSRV-1</code>
      <type>SysDM V1.1 License</type>
      <instances>1</instances>
      <expiry>1338800340</expiry>
      <holder>EMC Corporation</holder>
      <featureSet>0</featureSet>
      <sig>MC0CFQCQ7m972ibpf0E8+czb9N3pkijO/AIUSTqRK/2jaGnURd+MICgB7mZgBe4=</sig>
   </license>
' -X POST "$URL1"

echo
echo
echo "AFTER ADD LICENSE"
echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"
echo
echo

#       <id>ca78dc5c-5bec-4069-bce8-5216ab4a09c5</id>
