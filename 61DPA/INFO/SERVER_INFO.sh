#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp_server.xml

echo
echo "GET $URL_svr_status"

confirmrest

curl -u "$login1":"$paswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL_svr_status" > "$tmp1"

echo
echo "SERVER INFORMATION"
echo "=================="
echo 
xml sel -T -t -m serverStatus/version -o "DPA_version = " -v major -o "." -v minor -o "." -v maintenance -o "." -v build "$tmp1"
echo
echo

rm -rf "$tmprundir"  
