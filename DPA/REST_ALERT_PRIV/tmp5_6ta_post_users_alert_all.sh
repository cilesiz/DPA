#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/alert

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
<alert version="1">
   <parentObject type="type">
      <name>node name</name>
      <id>307c9831-e611-453d-bbb8-89ff3e0248b7</id>
   </parentObject>
   <childObject type="type">
      <name>node name</name>
      <id>8517c56a-1953-46c6-88ef-13afdda734f1</id>
   </childObject>
   <policy>
      <name>demo policy</name>
      <id>1b218bf1-26ba-4f2c-aa58-e703afdb01bf</id>
      <type>analysispolicy</type>
      <appliedNodePath/>
   </policy>
   <relevantRule>
      <name>Not implemented, yet</name>
      <id>82f802d0-7305-49dc-9c46-cd93a2d50a72</id>
      <templateId>e514576a-18d8-4f34-b317-9c2ae9bf355b</templateId>
   </relevantRule>
   <issued>2011-10-02T11:18:37.511+02:00</issued>
   <lastUpdated>2011-10-02T11:18:37.511+02:00</lastUpdated>
   <severity>Warning</severity>
   <category>Configuration</category>
   <state>New</state>
   <description>alert description per node</description>
   <resolution>alert resolution per node</resolution>
   <message>alert message per node</message>
   <count>1</count>
</alert
' "$URL1" > tmp1.txt

echo
cat tmp1.txt
echo
echo
rm -rf tmp1.txt
