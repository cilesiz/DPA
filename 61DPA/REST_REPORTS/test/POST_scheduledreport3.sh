#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib
source /root/rosli/61DPA/LIB/listing_id.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.txt
tmp2="$tmprundir"/tmp2.txt
tmp4="$tmprundir"/tmp4.xml

## Reports
echo -n "#1#Backup All Jobs#0c789587-e0fa-40cd-bd2c-15b48a6a7985#
#2#Backup Client Schedule#ad95f64d-c1ab-4417-b9d0-2311ac32ffb3#
#3#Clone Operations#0bbf36b1-c4a1-47cf-ba8b-3e30112d9094#
#4#Backup Job Forecast versus Actual#b4f77a93-3d5e-4a90-8738-eed7978e6c5a#
#5#All Clients#af8b5a13-1de7-464f-81d5-6a9b1acc65db#
#6#Backup Server Configuration#a636e3d5-b96a-408b-86b0-7f0442d22feb#
#7#Media Details#b5c1c95c-43fe-41ec-a02f-ed3645784995#
#8#Client Occupancy#45317d11-991f-4d65-92e2-a442f5cfcee1#
#9#TSM Client Occupancy#7d07c75d-aad5-47bf-98f4-be0b9606983a#
#10#TSM Client Filespaces#47027f10-44a0-45be-8892-15ec4a1f6390#" > "$tmp2"

masa=`date +%Y%m%d_%H%M%S`

echo -n "<scheduledReport version=\"1\" >
         <description>TUKARROSLIDESC</description>
      <report>
         <name>TUKARROSLINAME</name>
      </report>
      <window>
         <name>Last Day</name>
      </window>
      <schedule>
         <!-- <name>everyHalfHour</name> -->
         <name>9am every day</name>
      </schedule>
      <user>
         <logonName>administrator</logonName>
      </user>
      <generateIfEmpty>true</generateIfEmpty>
      <enabled>true</enabled>
      <publications>
         <publication>
            <publicationMethod>file</publicationMethod>
            <formatType>HTML</formatType>
            <pageOrientation>Portrait</pageOrientation>
            <pageSize>A4</pageSize>
            <fitContent>false</fitContent>
            <fileName>test$masa</fileName>
            <notifyByMail>false</notifyByMail>
         </publication>
      </publications>
      <nodeLinks>
         <nodeLink type=\"Group\">
            <name>Root</name>
            <child type=\"Group\">
               <name>Groups</name>
               <child type=\"Group\">
                  <name>Configuration</name>
               </child>
            </child>
         </nodeLink>
      </nodeLinks>
   </scheduledReport> " > "$tmp4"

cat "$tmp2" | awk -F"#" '{print $2"\t"$3}'
echo; echo -n "Choose Schedule Report [ 1 - 10 ] : "
read -e schnak

if [ $schnak -le 10 2> /dev/null ]; then

tkrid=`cat "$tmp2" | grep -i "#$schnak#" | awk -F"#" '{print $4}'`
tkrname=`cat "$tmp2" | grep -i "#$schnak#" | awk -F"#" '{print $3}'`
echo; echo -n "Description : "
read -e descrpt

sed -i "s/TUKARROSLIDESC/$descrpt/g" "$tmp4"
sed -i "s/TUKARROSLINAME/$tkrname/g" "$tmp4"

echo "
XML INPUT
---------"
xml fo "$tmp4"
echo; echo

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X POST -t "$tmp4" "$URL_dpa_schrpt" 

echo
echo

rm -rf "$tmprundir"

else
echo "
Wrong choice
"
rm -rf "$tmprundir"
fi

