#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/userroles

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X PUT -d '
<userRole version="1" lastModified="2012-02-16T10:10:57.870Z">
      <id>36ad0bd5-dfa6-47c3-bf7b-a48140c93a8f</id>
      <name>Administrator</name>
      <description>UserRole for an Administrator</description>
      <system>true</system>
      <permissions>
         <permission name="apollo.scheduledreports.read">false</permission>
         <permission name="apollo.systemsettings.read">false</permission>
         <permission name="apollo.alerts.read">false</permission>
         <permission name="apollo.user.readwrite">false</permission>
         <permission name="apollo.protectionpolicy.read">false</permission>
         <permission name="apollo.datacollectionpolicy.read">false</permission>
         <permission name="apollo.dashboard.readwrite">false</permission>
         <permission name="import.readwrite">false</permission>
         <permission name="apollo.reporttemplate.read">false</permission>
         <permission name="apollo.user.read">false</permission>
         <permission name="apollo.analysispolicy.read">false</permission>
         <permission name="apollo.objectlibrary.readwrite">false</permission>
         <permission name="apollo.alerts.readwrite">false</permission>
         <permission name="apollo.reportqueue.read">false</permission>
         <permission name="apollo.dashboard.read">false</permission>
         <permission name="apollo.chargebackpolicy.read">false</permission>
         <permission name="apollo.chargebackpolicy.assign">false</permission>
         <permission name="apollo.objectlibrary.read">false</permission>
         <permission name="apollo.reporttemplate.readwrite">false</permission>
         <permission name="apollo.datacollectionpolicy.assign">false</permission>
         <permission name="apollo.protectionpolicy.assign">false</permission>
         <permission name="apollo.datacollectionpolicy.readwrite">false</permission>
         <permission name="apollo.analysispolicy.assign">false</permission>
         <permission name="apollo.chargebackpolicy.readwrite">false</permission>
         <permission name="apollo.systemsettings.readwrite">false</permission>
         <permission name="apollo.replicationanalysis.read">false</permission>
         <permission name="apollo.groupmanagement.read">false</permission>
         <permission name="apollo.permissions.list">false</permission>
         <permission name="apollo.scheduledreports.readwrite">false</permission>
         <permission name="apollo.analysispolicy.readwrite">false</permission>
         <permission name="apollo.reportqueue.readwrite">false</permission>
         <permission name="apollo.protectionpolicy.readwrite">false</permission>
         <permission name="apollo.groupmanagement.readwrite">false</permission>
      </permissions>
   </userRole>
' "$URL1"/36ad0bd5-dfa6-47c3-bf7b-a48140c93a8f > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp1.txt 

