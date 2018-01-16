#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.txt

echo
echo "GET $URL_base_nossl"
echo
curl -k \
-X GET "$URL_base_nossl" > "$tmp1"

echo
echo
xml fo "$tmp1"
echo
echo "=================================================="
echo
echo
dpaver=`cat "$tmp1" | grep -i var | grep -i " version " | awk -F"=" '{print $NF}' | awk -F'"' '{print $2}'`
dpabld=`cat "$tmp1" | grep -i var | grep -i " buildNumber " | awk -F"=" '{print $NF}' | awk -F'"' '{print $2}'`

echo "DPA server version = $dpaver.$dpabld"

echo
echo

rm -rf "$tmprundir"
