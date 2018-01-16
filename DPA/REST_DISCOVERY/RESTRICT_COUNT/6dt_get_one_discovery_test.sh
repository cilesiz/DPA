#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator
# test_dis_id=118b1eb0-e193-4288-943a-eaea1bb73f3e
test_dis_id=e95250d0-3732-44b4-9691-77c86d73c18d

URL1=http://"$HB_DPA":9004/dpa-api/discovery/tests


echo

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"/"$test_dis_id" > tmp1.txt

echo
cat tmp1.txt
rm -rf tmp1.txt
echo
echo
