#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/userroles

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X PUT -d '
   <userRole version="1" lastModified="2012-02-10T00:39:55.595Z">
      <id>36ad0bd5-dfa6-47c3-bf7b-a48140c93a8f</id>
      <name>Administrator</name>
      <description>UserRole for an Administrator</description>
      <system>true</system>
      <permissions>
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
' "$URL1"/36ad0bd5-dfa6-47c3-bf7b-a48140c93a8f > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp1.txt 

