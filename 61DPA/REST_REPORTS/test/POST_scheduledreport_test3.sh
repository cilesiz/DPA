#!/bin/bash

HB_DPA=10.64.213.59
user1=administrator
pswd1=administrator

URL1=https://"$HB_DPA":9002/dpa-api/scheduledreport

echo
echo
curl -k -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
<scheduledReport version="1">
   <description>ROSLI TEST 2</description>
   <report>
      <name>Process CPU Utilization</name>
   </report>
   <window>
      <name>Last Hour</name>
   </window>
   <schedule>
      <name>always</name>
   </schedule>
   <user>
      <logonName>ss_rw</logonName>
   </user>
   <generateIfEmpty>false</generateIfEmpty>
   <nodeLinks>
      <nodeLink type="Group">
         <id>00000000-0000-0000-0000-000000000001</id>
         <name>Root</name>
         <child type="Group">
            <id>00000000-0000-0000-0000-000000000010</id>
            <name>Groups</name>
            <child type="Group">
               <id>8ad04346-9abd-4466-8bd8-05306b63519d</id>
               <name>Configuration</name>
            </child>
         </child>
      </nodeLink>
   </nodeLinks>
</scheduledReport>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp1.txt 

