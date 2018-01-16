#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/alert

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X PUT -d '
   <alert version="1">
      <parentObject>
         <name>lima_1</name>
         <id>914a3a72-c24c-424b-b2ff-4ca3901184e1</id>
      </parentObject>
      <relevantRule>
         <name></name>
         <id></id>
      </relevantRule>
      <issued>2012-02-23T10:15:57.754Z</issued>
      <lastUpdated>2012-02-23T10:15:57.754Z</lastUpdated>
      <age>0</age>
      <severity>Warning</severity>
      <category>System</category>
      <state>New</state>
      <description>Unable to connect to Collector using any of its aliases [lima_1, lima-alias-1, 10.64.2.1] (agent.connect.error)</description>
      <count>1</count>
   </alert>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt
echo
echo
rm -rf tmp1.txt
