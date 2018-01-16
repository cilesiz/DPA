#!/bin/bash

HB_DPA=10.64.205.162
user1=dcp_nor
pswd1=dcp_nor

URL1=http://"$HB_DPA":9004/dpa-api/policies/datacollection

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
<dataCollectionPolicy version="1" system="false" hidden="false">
    <name>Data Collection Policy Rosli NOR</name>
    <description>Data Collection Policy Rosli NOR</description>
    <enabled>true</enabled>
    <requests>
      <request version="1">
         <module>puredisk</module>
         <function>occupancy</function>
         <frequency type="Period">
            <period>3600</period>
         </frequency>
         <agent type="Local"/>
         <options/>
         <enabled>true</enabled>
      </request>
      <request version="1">
         <module>celerra</module>
         <function>status</function>
         <frequency type="Period">
            <period>900</period>
         </frequency>
         <agent type="Local"/>
         <options/>
         <enabled>true</enabled>
      </request>
    </requests>
</dataCollectionPolicy>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp1.txt 

