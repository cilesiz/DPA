#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/users

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
<user version="1" system="false" hidden="false">
  <displayName>usertest2</displayName> 
  <logonName>usertest2</logonName> 
  <externalName>usertest2</externalName> 
  <password>usertest2</password>
  <authenticationType>PASSWORD</authenticationType> 
  <userRole version="1">
   <id>82223d80-3584-4725-af8c-af952b7c34d3</id>
    <name>Rosli</name> 
    <description>UserRole for an Rosli</description> 
  </userRole>
</user>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp1.txt 

