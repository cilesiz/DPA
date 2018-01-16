#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.txt
tmp2="$tmprundir"/tmp2.xml

echo "  <window version=\"1\">
    <name>testroslitwo</name>
    <description>Test Rosli Two</description>
    <startTimeId>954c1c7d-71c5-4c34-91ff-eef07884c2e7</startTimeId>
    <endTimeId>ed2ee63b-d8ca-494e-ad97-acf640ecd2ca</endTimeId>
    <interval>-1</interval>
    <enableTimeZone>true</enableTimeZone>
    <system>false</system>
    <hidden>false</hidden>
  </window> " > "$tmp2"


curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X POST -T "$tmp2" "$URL_dpa_wndows" > "$tmp1"

rm -rf "$tmprundir"
