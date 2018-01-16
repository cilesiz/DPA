#!/bin/bash

HB_DPA=10.64.205.162
login1=administrator
paswd1=administrator

echo

curl -u "$login1":"$paswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET http://"$HB_DPA":9004/dpa-api/server/status > tmp_server.txt

echo
echo "SERVER INFORMATION"
echo "=================="
cat tmp_server.txt | sed -n '/<version/,//p' | awk -F"<" '{print $1,$2}' | awk -F">" '{print $1,"\t",$2}' | grep -v "/version"
echo

rm -rf tmp_server.txt 
