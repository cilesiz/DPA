#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib
source /root/rosli/61DPA/LIB/listing_id.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.txt
tmp2="$tmprundir"/tmp2.xml

echo -n "
Report Description : "
read -e reportdesc

echo -n "
Report filename : "
read -e reportfile

echo -n "<scheduledReport version=\"1\" >
         <description>$reportdesc</description>
      <report>
         <name>Backup All Jobs</name>
      </report>
      <window>
         <name>Last Week</name>
      </window>
      <schedule>
         <name>always</name>
      </schedule>
      <user>
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
            <fitContent>false</fitContent>
            <fileName>$reportfile</fileName>
            <notifyByMail>false</notifyByMail>
         </publication>
      </publications>
      <nodeLinks>
         <nodeLink type=\"Group\">
            <id>00000000-0000-0000-0000-000000000001</id>
            <name>Root</name>
            <child type=\"Group\">
               <id>00000000-0000-0000-0000-000000000010</id>
               <name>Groups</name>
               <child type=\"Group\">
                  <name>Configuration</name>
		  <child type=\"Group\">
			<child type=\"Group\">
			<name>Servers</name>
				<child type=\"Group\">
				<name>Backup Servers</name>
				</child>		
			</child>
		  </child>
               </child>
            </child>
         </nodeLink>
      </nodeLinks>
   </scheduledReport> " > "$tmp2"

echo "
XML INPUT
---------"
xml fo "$tmp2"
echo; echo

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X POST -T "$tmp2" "$URL_dpa_schrpt" > "$tmp1"

echo
echo
xml fo "$tmp1"
echo
echo


rm -rf "$tmprundir"
