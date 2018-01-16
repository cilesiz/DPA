#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.txt
tmp2="$tmprundir"/tmp2.txt

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_apollo_nod" > "$tmp1"

echo
echo
xml fo "$tmp1"
echo
echo
echo "
SIMPLY RESULTS
==============
"
xml sel -t -m 'nodes/node[@type="Group"]' \
-o "NAME=" -v displayName \
-o "  ID=" -v id \
-n "$tmp1" > "$tmp2"

cat "$tmp2" | grep -i [0-9,a-z] | awk '{print NR"    "$0}'

echo; echo


rm -rf "$tmprundir"
