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
<name>1 Celerra NS480 licenses for EMC (142773)</name>
<code>DPA-FSRV-1</code>
<type>SysDM V1.1 License</type>
<instances>1</instances>
<expiry>1342447200</expiry>
<holder>EMC Corporation</holder>
<featureSet>0</featureSet>
<sig>MCwCFA+C6VpvAJ6cgsWvRcWpl/YEYNXBAhRbIopw3M3CfYrcJk2mkyobJ1ZqNA==</sig>
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
