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
    <permissions>
         <permission name="apollo.userattribute.read">true</permission> 
         <permission name="apollo.userrole.read">true</permission> 
         <permission name="apollo.userrole.readwrite">false</permission> 
         <permission name="apollo.userattribute.readwrite">false</permission> 
         <permission name="apollo.scheduledreports.read">false</permission>
         <permission name="apollo.systemsettings.read">false</permission>
         <permission name="apollo.alerts.read">true</permission>
         <permission name="apollo.user.readwrite">false</permission>
         <permission name="apollo.protectionpolicy.read">false</permission>
         <permission name="apollo.datacollectionpolicy.read">false</permission>
         <permission name="apollo.dashboard.readwrite">false</permission>
         <permission name="import.readwrite">false</permission>
         <permission name="apollo.reporttemplate.read">true</permission>
         <permission name="apollo.user.read">true</permission>
         <permission name="apollo.analysispolicy.read">false</permission>
         <permission name="apollo.objectlibrary.readwrite">false</permission>
         <permission name="apollo.alerts.readwrite">false</permission>
         <permission name="apollo.reportqueue.read">true</permission>
         <permission name="apollo.dashboard.read">true</permission>
         <permission name="apollo.chargebackpolicy.read">true</permission>
         <permission name="apollo.chargebackpolicy.assign">false</permission>
         <permission name="apollo.objectlibrary.read">true</permission>
         <permission name="apollo.reporttemplate.readwrite">false</permission>
         <permission name="apollo.datacollectionpolicy.assign">false</permission>
         <permission name="apollo.protectionpolicy.assign">false</permission>
         <permission name="apollo.datacollectionpolicy.readwrite">false</permission>
         <permission name="apollo.analysispolicy.assign">false</permission>
         <permission name="apollo.chargebackpolicy.readwrite">false</permission>
         <permission name="apollo.systemsettings.readwrite">false</permission>
         <permission name="apollo.replicationanalysis.read">true</permission>
         <permission name="apollo.groupmanagement.read">true</permission>
         <permission name="apollo.permissions.list">true</permission>
         <permission name="apollo.scheduledreports.readwrite">false</permission>
         <permission name="apollo.analysispolicy.readwrite">false</permission>
         <permission name="apollo.reportqueue.readwrite">false</permission>
         <permission name="apollo.protectionpolicy.readwrite">false</permission>
         <permission name="apollo.groupmanagement.readwrite">false</permission>

    </permissions>
  </userRole>
</user>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp1.txt 

