#!/bin/bash

HB_DPA=10.64.205.162
user1=user_norw_1
pswd1=user_norw_1

URL1=http://"$HB_DPA":9004/dpa-api/dashboards

echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp1.txt 

