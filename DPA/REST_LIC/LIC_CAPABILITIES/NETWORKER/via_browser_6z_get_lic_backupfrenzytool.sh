#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/backupJobsFrenzy

hari=`date +%Y%m%d_%H%M%S`
tmp1=/tmp/tmp1_"$hari".txt
tmp2=/tmp/tmp2_"$hari".txt
tmp3=/tmp/tmp3_"$hari".txt
tmp4=/tmp/tmp4_"$hari".txt

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > "$tmp1"

echo
cat  "$tmp1"
echo

