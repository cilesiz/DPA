#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib
source /root/rosli/61DPA/LIB/listing_id.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.txt
tmp2="$tmprundir"/tmp2.txt

echo -n "Type [ smartgroup / aeruleset / viewlet ] : "
read -e stattype

echo -n "TimeZone [ eg. Europe/London ] : "
read -e timezone

echo -n "Start time [ yyyy-mm-ddThh:mm:ss+hh:mm ] : "
read -e timestart

echo -n "End time [ yyyy-mm-ddThh:mm:ss+hh:mm ] : "
read -e timeend

echo -n "<timePeriod type=\"$stattype\" timeZone=\"$timezone\">
 <startTime relative=\"false\">$timestart</startTime>
 <endTime relative=\"false\">$timeend</endTime>
</timePeriod>" > "$tmp2"

echo "
XML INPUT
---------"
xml fo "$tmp2"
echo; echo

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X POST -T "$tmp2" "$URL_dpa_sptsct" > "$tmp1" 

xml fo "$tmp1"

echo; echo

rm -rf "$tmprundir"
