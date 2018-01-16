#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/scheduledreport

echo
echo

for i in `seq 1 1 500`
do

echo ' <scheduledReport version="1"> ' > tmp2.txt
echo "      <description>testabc $i abcdef $i</description> " >> tmp2.txt
echo '      <report>
         <id>873c016e-5a09-429e-b91d-8ff2197d0d3a</id>
         <name>Backup Active Clients</name>
      </report>
      <window>
         <id>bd199743-a6af-4350-9d14-0d7f308d3e3f</id>
         <name>Last Week</name>
      </window>
      <schedule>
         <id>640f2456-2293-46fc-aba0-d684e375f4d0</id>
         <name>9am every day</name>
      </schedule>
      <user>
         <id>46c9a9d5-a645-4dcb-b288-3d30ff930ad7</id>
         <logonName>administrator</logonName>
      </user>
      <generateIfEmpty>true</generateIfEmpty>
      <enabled>true</enabled>
      <publications>
         <publication>
            <publicationMethod>file</publicationMethod>
            <formatType>PDF</formatType>
            <pageOrientation>Portrait</pageOrientation>
            <pageSize>A4</pageSize>
            <fitContent>false</fitContent> ' >> tmp2.txt

echo "            <fileName>test_abcdef_xyz$i</fileName> " >> tmp2.txt

echo '            <notifyByMail>false</notifyByMail>
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
      </nodeLinks>
   </scheduledReport>
' >> tmp2.txt

echo "XML INPUT"
cat tmp2.txt

curl -v -u "$user1":"$pswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X POST -T tmp2.txt "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp1.txt tmp2.txt

done

