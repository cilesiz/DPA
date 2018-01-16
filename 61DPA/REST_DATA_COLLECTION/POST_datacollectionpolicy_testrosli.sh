#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib
source /root/rosli/61DPA/LIB/listing_id.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.txt
tmp2="$tmprundir"/tmp2.txt



curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X POST -d '
<dataCollectionPolicy version="1" system="false" hidden="false">
    <name>DataCollectionPolicyRosli</name>
    <description>Data Collection Policy Rosli</description>
    <enabled>true</enabled>
    <requests>
      <request version="1">
         <module>puredisk</module>
         <function>occupancy</function>
         <frequency type="Period">
            <period>3600</period>
         </frequency>
         <agent type="Local"/>
         <options/>
         <enabled>true</enabled>
      </request>
      <request version="1">
         <module>celerra</module>
         <function>status</function>
         <frequency type="Period">
            <period>900</period>
         </frequency>
         <agent type="Local"/>
         <options/>
         <enabled>true</enabled>
      </request>
    </requests>
</dataCollectionPolicy>
' "$URL_dpa_dtcltn" > "$tmp1"

echo
echo
xml fo "$tmp1"
echo
echo

rm -rf "$tmprundir"
