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
<node version="1" lastModified="2012-02-21T14:19:09.62Z" type="Celerra">
   <id>1226e7e4-75ae-44b0-b826-c9cb58da4aa5</id>
   <link rel="self" href="http://10.64.213.74:9004/apollo-api/nodes/1226e7e4-75ae-44b0-b826-c9cb58da4aa5"/>
   <name>uncle-mgmt.wysdm.lab.emc.com</name>
   <displayName>uncle-mgmt.wysdm.lab.emc.com</displayName>
   <globalName>uncle-mgmt.wysdm.lab.emc.com</globalName>
   <creatorType>apollo</creatorType>
   <aliases/>
</node>
    </primaryObject>
  </task>
</discoveryJob>

' "$URL1" > tmp1.txt

echo
echo
echo
rm -rf tmp1.txt 
