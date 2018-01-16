#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/users

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
<user version="1" system="true" hidden="true">
  <displayName>userltest4</displayName> 
  <logonName>usertest4</logonName> 
  <externalName>usertest4</externalName> 
  <authenticationType>PASSWORD</authenticationType> 
  <password>usertest4</password>
  <userRole version="1">
   <id>6b31f2a8-9955-49ce-878d-2fa242bb639b</id>
    <name>Amorii</name>
    <description>UserRole for an Amorii</description> 
    <system>true</system> 
    <permissions>
         <permission name="apollo.userattribute.read">true</permission> 
         <permission name="apollo.userrole.read">true</permission> 
         <permission name="apollo.userrole.readwrite">true</permission> 
         <permission name="apollo.userattribute.readwrite">true</permission> 
         <permission name="apollo.scheduledreports.read">true</permission>
         <permission name="apollo.systemsettings.read">true</permission>
         <permission name="apollo.alerts.read">true</permission>
         <permission name="apollo.user.readwrite">true</permission>
         <permission name="apollo.protectionpolicy.read">true</permission>
         <permission name="apollo.datacollectionpolicy.read">true</permission>
         <permission name="apollo.dashboard.readwrite">true</permission>
         <permission name="import.readwrite">true</permission>
         <permission name="apollo.reporttemplate.read">true</permission>
         <permission name="apollo.user.read">true</permission>
         <permission name="apollo.analysispolicy.read">true</permission>
         <permission name="apollo.objectlibrary.readwrite">true</permission>
         <permission name="apollo.alerts.readwrite">true</permission>
         <permission name="apollo.reportqueue.read">true</permission>
         <permission name="apollo.dashboard.read">true</permission>
         <permission name="apollo.chargebackpolicy.read">true</permission>
         <permission name="apollo.chargebackpolicy.assign">true</permission>
         <permission name="apollo.objectlibrary.read">true</permission>
         <permission name="apollo.reporttemplate.readwrite">true</permission>
         <permission name="apollo.datacollectionpolicy.assign">true</permission>
         <permission name="apollo.protectionpolicy.assign">true</permission>
         <permission name="apollo.datacollectionpolicy.readwrite">true</permission>
         <permission name="apollo.analysispolicy.assign">true</permission>
         <permission name="apollo.chargebackpolicy.readwrite">true</permission>
         <permission name="apollo.systemsettings.readwrite">true</permission>
         <permission name="apollo.replicationanalysis.read">true</permission>
         <permission name="apollo.groupmanagement.read">true</permission>
         <permission name="apollo.permissions.list">true</permission>
         <permission name="apollo.scheduledreports.readwrite">true</permission>
         <permission name="apollo.analysispolicy.readwrite">true</permission>
         <permission name="apollo.reportqueue.readwrite">true</permission>
         <permission name="apollo.protectionpolicy.readwrite">true</permission>
         <permission name="apollo.groupmanagement.readwrite">true</permission>

    </permissions>
  </userRole>
</user>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp1.txt 

