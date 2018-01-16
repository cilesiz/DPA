#!/bin/bash

HB_DPA=10.64.205.162
user1=sst4
pswd1=sst4

URL1=http://"$HB_DPA":9004/apollo-api/users 

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
<user version="1" system="false" hidden="false">
  <displayName>testjerni1</displayName>
  <logonName>testjerni1</logonName>
  <externalName>testjerni1</externalName>
  <password>testjerni1</password>
  <authenticationType>PASSWORD</authenticationType>
</user>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp1.txt 

