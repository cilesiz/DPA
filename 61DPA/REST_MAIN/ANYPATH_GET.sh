#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib

choose_server
listing_url

echo -n "Give path : "
read -e anypath

URL_req="${URL_base_nossl%/}" 

echo "GET $URL_req""$anypath"
confirmrest

tmp1="$tmprundir"/tmp1.txt

echo
echo
curl -k -v -u "$login1":"$paswd1" \
-H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_req""$anypath" > "$tmp1"

echo
echo
xml fo "$tmp1"
echo
echo

rm -rf "$tmprundir"

