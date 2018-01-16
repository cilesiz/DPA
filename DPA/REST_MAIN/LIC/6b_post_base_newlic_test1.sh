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
   <license>
      <name>DPA base license for EMC (893297) - Rosli</name>
      <code>EMC-DPA-ENT</code>
      <type>SysDM V1.1 License</type>
      <instances>1</instances>
      <expiry>1344156460</expiry>
      <holder>EMC Corporation</holder>
      <featureSet>0</featureSet>
      <sig>MCwCFBnT8zRYOTWXsy3V3CgPhnw52o3NAhQOClTXtQWcdQX6jjgbZkJc6AgSMA==</sig>
   </license>
' -X POST "$URL1"

echo
echo
echo "AFTER ADD LICENSE"
echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"
echo
echo
