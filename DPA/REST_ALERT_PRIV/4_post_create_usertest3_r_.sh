#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/users

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
<user version="1" system="false" hidden="false">
  <displayName>userltest3</displayName> 
  <logonName>usertest3</logonName> 
  <externalName>usertest3</externalName> 
  <authenticationType>PASSWORD</authenticationType> 
  <password>usertest3</password>
  <userRole version="1">
    <name>User</name>
    <id>15084245-2119-4e51-8a52-3dd9e302c5ee</id>
    <description>UserRole for a User</description> 
    <system>true</system> 
  </userRole>
</user>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp1.txt 

