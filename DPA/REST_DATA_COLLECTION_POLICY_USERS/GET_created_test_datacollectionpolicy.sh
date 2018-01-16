#!/bin/bash

HB_DPA=10.64.213.59
user1=administrator
pswd1=administrator

URL1=https://"$HB_DPA":9002/dpa-api/policies/datacollection

echo
echo
curl -k -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp1.txt 

