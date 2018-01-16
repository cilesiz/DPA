#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/users

echo
curl -IL -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"
echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
<user version="1" system="false" hidden="false">
  <displayName>userldap1</displayName> 
  <logonName>userldap1</logonName> 
  <externalName>userldap1</externalName> 
  <authenticationType>LDAP</authenticationType> 
  <userRole version="1">
    <name>Administrator</name> 
    <description>UserRole for an Administrator</description> 
    <system>true</system> 
    <permissions>
      <permission name="apollo.userattribute.read">true</permission> 
      <permission name="apollo.user.read">true</permission> 
      <permission name="apollo.user.readwrite">true</permission> 
      <permission name="apollo.permissions.list">true</permission> 
      <permission name="apollo.userrole.read">true</permission> 
      <permission name="apollo.userrole.readwrite">true</permission> 
      <permission name="apollo.userattribute.readwrite">true</permission> 
      <permission name="import.readwrite">false</permission> 
    </permissions>
  </userRole>
</user>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp1.txt 

