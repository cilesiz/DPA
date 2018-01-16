#!/bin/bash

HB_DPA=10.64.205.107
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/scheduledreport

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
 <scheduledReport version="1">
      <description>99 test7</description>
      <report>
         <id>873c016e-5a09-429e-b91d-8ff2197d0d3a</id>
         <name>Backup Active Clients</name>
      </report>
      <window>
         <id>dfad23d2-3d8f-4ded-a12e-fc8bc68200cb</id>
         <name>Nine To Five</name>
      </window>
      <schedule>
         <id>4f7bca2a-8982-4704-b1ad-3ff511e9ce69</id>
         <name>rt_test1</name>
      </schedule>
      <user>
         <id>46c9a9d5-a645-4dcb-b288-3d30ff930ad7</id>
         <logonName>administrator</logonName>
      </user>
      <generateIfEmpty>false</generateIfEmpty>
      <enabled>true</enabled>
      <publications>
         <publication>
            <publicationMethod>file</publicationMethod>
            <formatType>PDF</formatType>
            <pageOrientation>Portrait</pageOrientation>
            <pageSize>A4</pageSize>
            <fitContent>false</fitContent>
            <fileName>AA_test1</fileName>
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
                  <child type="Group">
                     <id>307c9831-e611-453d-bbb8-89ff3e0248b7</id>
                     <name>Servers</name>
                     <child type="Group">
                        <id>c5723b8f-c5b7-4237-af29-b689203fbc44</id>
                        <name>Backup Servers</name>
                        <child type="Group">
                           <id>24d28b90-0601-465e-9878-9b8ac6ee9a44</id>
                           <name>EMC NetWorker</name>
                        </child>
                     </child>
                  </child>
               </child>
            </child>
         </nodeLink>
         <nodeLink type="Group">
            <id>00000000-0000-0000-0000-000000000001</id>
            <name>Root</name>
            <child type="Group">
               <id>00000000-0000-0000-0000-000000000010</id>
               <name>Groups</name>
               <child type="Group">
                  <id>8ad04346-9abd-4466-8bd8-05306b63519d</id>
                  <name>Configuration</name>
                  <child type="Group">
                     <id>307c9831-e611-453d-bbb8-89ff3e0248b7</id>
                     <name>Servers</name>
                     <child type="Group">
                        <id>c5723b8f-c5b7-4237-af29-b689203fbc44</id>
                        <name>Backup Servers</name>
                        <child type="Group">
                           <id>a58abe61-ad35-4365-ab91-b53afa54e294</id>
                           <name>EMC Avamar</name>
                        </child>
                     </child>
                  </child>
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

