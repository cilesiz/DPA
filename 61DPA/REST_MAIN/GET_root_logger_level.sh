#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib

choose_server
listing_url

echo "GET $URL_apollo_log"
confirmrest

tmp1="$tmprundir"/tmp1.txt

echo
curl -k -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_apollo_log" > "$tmp1"

nowlevel=`cat "$tmp1" | grep logger | awk -F"level=" '{print $2}' | awk -F'"' '{print $2}'`

echo
echo "CURRENT SETTING"
echo "==============="
echo
cat "$tmp1"
echo
echo
echo "--> LEVEL = $nowlevel"
echo
echo
echo

rm -rf "$tmprundir"
