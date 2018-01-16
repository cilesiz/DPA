#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/discovery

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
<discoveryJob>
  <task>
    <primaryObject exists="false">
      <node version="1" type="Celerra">
      <name>uncle-mgmt.wysdm.lab.emc.com</name>
      <displayName>uncle-mgmt.wysdm.lab.emc.com</displayName>
      <globalName>uncle-mgmt.wysdm.lab.emc.com</globalName>
      <creatorType>apollo</creatorType>
      </node>
      <dataCollectionParameter>
        <hostMonitoring>false</hostMonitoring>
        <replicationMonitoring>false</replicationMonitoring>
        <agent local="true"/>
      </dataCollectionParameter>
    </primaryObject>
  </task>
</discoveryJob>
' "$URL1" > tmp1.txt

echo
echo
echo
rm -rf tmp1.txt 
