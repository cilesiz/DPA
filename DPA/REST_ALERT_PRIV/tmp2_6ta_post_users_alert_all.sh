#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/alert

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
<alert version="1">
   <id>3b4f356f-9b74-4dc5-8812-e1db0d1b7fad</id>
   <link rel="self" href=">
   <parentObject type="Host">
   <name>dummy_host_3348547092703092048</name>
   <id>fe59c68b-5a80-42fa-bb87-fc84462009af</id>
   </parentObject>
   <childObject type="Host">
   <name>dummy_host_3348547092703092048</name>
   <id>fe59c68b-5a80-42fa-bb87-fc84462009af</id>
   </childObject>
   <component>component</component>
   <policy>
   <name>DPA Test Policy for Multiple Rules</name>
   <id>e12304aa-fe9d-4e1e-a16a-04a90274d347</id>
   <type>analysispolicy</type>
   <appliedNodePath/>
   </policy>
   <relevantRule>
   <name>Backup Client Configuration Changed</name>
   <id>02e1a288-d804-4d52-94e4-3f686724471f</id>
   <templateId>02e1a288-d804-4d52-94e4-3f686724471f</templateId>
   </relevantRule>
   <issued>2011-12-15T16:36:39.830+02:00</issued>
   <lastUpdated>2011-12-15T16:36:39.830+02:00</lastUpdated>
   <age>1970-01-01T02:00:00.0+02:00</age>
   <severity>Critical</severity>
   <category>Administrative</category>
   <state>New</state>
   <description>this alert was created by the server for testability reasons</description>
   <resolution>Please resolve, bye now</resolution>
   <message>Backup Client Configuration Changed</message>
   <count>1</count>
</alert> ' "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp1.txt 

