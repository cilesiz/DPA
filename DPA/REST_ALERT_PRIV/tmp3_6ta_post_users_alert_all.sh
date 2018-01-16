#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/alert

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
<alert version="1">
   <parentObject type="Host">
   <name>dummy_host_3348547092703092048</name>
   </parentObject>
   <childObject type="Host">
   <name>dummy_host_3348547092703092048</name>
   </childObject>
   <component>component</component>
   <policy>
   <name>DPA Test Policy for Multiple Rules</name>
   <type>analysispolicy</type>
   </policy>
   <relevantRule>
   <name>Backup Client Configuration Changed</name>
   <templateId>02e1a288-d804-4d52-94e4-3f686724471f</templateId>
   </relevantRule>
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

