#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/users

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
<user version="1" system="false" hidden="false">
  <displayName>usertest5</displayName> 
  <logonName>usertest5</logonName> 
  <externalName>usertest5</externalName> 
  <password>usertest5</password>
  <authenticationType>PASSWORD</authenticationType> 
  <userRole version="1">
    <id>5bf819ce-f99e-488c-a7f3-eac5fe7684b5</id>
    <name>Engineer</name> 
    <description>UserRole for an Engineer</description> 
  </userRole>
</user>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp1.txt 

