#!/bin/bash

HB_DPA=10.64.205.162
user1=user_norw
pswd1=user_norw

URL1=http://"$HB_DPA":9004/dpa-api/alert

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
<alert version="1" lastModified="2011-12-02T11:18:37.511+02:00">
   <parentObject type="type">
      <name>Parent Object Name Satu</name>
      <id>aaaaaaaa-bbbb-cccc-dddd-123456789abc</id>
   </parentObject>
   <childObject type="type">
      <name>Child Object Name Dua</name>
      <id>abcdef12-abcd-ef12-3456-789abcdef123</id>
   </childObject>
   <policy>
      <name>Policy Tiga</name>
      <id>aaaaaaaa-bbbb-cccc-3456-789abcdef123</id>
      <type>analysispolicy</type>
      <appliedNodePath/>
   </policy>
   <relevantRule>
      <name>Not implemented, yet</name>
      <id>aaaaaaaa-abcd-ef12-3456-789abcdef123</id>
      <templateId>abcdef12-bbbb-cccc-dddd-123456789abc</templateId>
   </relevantRule>
   <issued>2011-12-02T11:18:37.511+02:00</issued>
   <lastUpdated>2011-12-02T11:18:37.511+02:00</lastUpdated>
   <age>0</age>
   <severity>Warning</severity>
   <category>System</category>
   <state>New</state>
   <description>Unable to connect to Collector using any of its aliases [hantu_1, hantu-alias-1, 10.64.212.18] (agent.connect.error)</description>
   <resolution>alert resolution per node</resolution>
   <message>alert message per node</message>
   <count>1</count>
</alert>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt
echo
echo
rm -rf tmp1.txt
