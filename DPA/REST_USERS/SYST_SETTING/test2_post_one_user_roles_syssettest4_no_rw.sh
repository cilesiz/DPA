#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/userroles

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
   <userRole version="1">
      <name>SystemSettingsTest4</name>
      <description>UserRole for a SystemSettingsTest4</description>
      <system>true</system>
      <permissions>
         <permission name="apollo.systemsettings.read">false</permission>
         <permission name="apollo.user.readwrite">true</permission>
         <permission name="import.readwrite">false</permission>
         <permission name="apollo.user.read">true</permission>
         <permission name="apollo.systemsettings.readwrite">false</permission>
      </permissions>
   </userRole>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp1.txt 
