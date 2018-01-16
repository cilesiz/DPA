#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.txt

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_dpa_times1" > "$tmp1"

echo
echo
xml fo "$tmp1"
echo
echo
echo "SIMPLIFY RESULT :
================="
xml sel -t -m times/time \
-o "ID=" -v id \
-o " NAME=" -v name \
-n "$tmp1" | grep -i [0-9,a-z] | awk '{print NR"   "$0}'
echo; echo


rm -rf "$tmprundir"
