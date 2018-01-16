#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator
reportid=28561921-e5f2-48b8-a02e-40d8ce9ec86c

URL1=http://"$HB_DPA":9004/dpa-api/report

echo
echo
curl -v -u "$user1":"$pswd1" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"/result/"$reportid" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp1.txt 

