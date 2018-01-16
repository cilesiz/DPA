#!/bin/bash

HB_DPA=10.64.205.162
user1=usertest4
pswd1=usertest4

URL1=http://"$HB_DPA":9004/apollo-api/users 

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
<user version="1" system="false" hidden="false">
  <displayName>testjerni2</displayName>
  <logonName>testjerni2</logonName>
  <externalName>testjerni2</externalName>
  <password>testjerni2</password>
  <authenticationType>PASSWORD</authenticationType>
</user>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp1.txt 

