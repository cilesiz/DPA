#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/scheduledreport

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
 <scheduledReport version="1">
      <id>e2e1935c-b612-48ab-86b0-5e7c1168979a</id>
      <link rel="self" href="http://10.64.213.74:9004/dpa-api/scheduledreport/e2e1935c-b612-48ab-86b0-5e7c1168979a"/>
      <description>test2</description>
      <report>
         <id>e1aab2a6-cc8a-46e3-9e39-ab61fc0d091f</id>
         <name>Process CPU Utilization</name>
      </report>
      <window>
         <id>dfad23d2-3d8f-4ded-a12e-fc8bc68200cb</id>
         <name>Nine To Five</name>
      </window>
      <schedule>
         <id>e250ee29-3397-43d8-bbc2-9d5bc3eaa3fa</id>
         <name>always</name>
      </schedule>
      <user>
         <id>6e05d84e-74af-4008-b073-f6d5919f6266</id>
         <logonName>ss_rw2</logonName>
      </user>
      <generateIfEmpty>true</generateIfEmpty>
      <publications>
         <publication>
            <publicationMethod>file</publicationMethod>
            <formatType>XML</formatType>
            <pageOrientation>Portrait</pageOrientation>
            <pageSize>A4</pageSize>
            <fileName>test2fileoutput.xml</fileName>
            <notifyByMail>false</notifyByMail>
         </publication>
         <publication>
            <publicationMethod>email</publicationMethod>
            <formatType>HTML</formatType>
            <pageOrientation>Portrait</pageOrientation>
            <pageSize>A4</pageSize>
            <mailTo>vasya@pupkin.com</mailTo>
            <notifyByMail>false</notifyByMail>
         </publication>
      </publications>
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
</scheduledReports>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp1.txt 

