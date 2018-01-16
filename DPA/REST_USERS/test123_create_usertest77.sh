#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/users

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
<user version="1" system="true" hidden="false">
  <displayName>usertest77</displayName> 
  <logonName>usertest77</logonName> 
  <externalName>usertest77</externalName> 
  <authenticationType>PASSWORD</authenticationType> 
  <password>usertest77</password>
</user>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp1.txt 

