#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.txt
tmp2="$tmprundir"/tmp2.txt

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_dpa_aerlst"?type=ScheduledBasedRule > "$tmp1"

echo
echo
xml fo "$tmp1"
echo
echo
echo "
SIMPLIFY
========
"
xml sel -t -m aeRulesets/AERuleset \
-o "NAME=" -v name \
-o "  SCHNAME=" -v schedule/name \
-o "  RPTNAME=" -v reportName \
-n "$tmp1" > "$tmp2"

cat "$tmp2" | grep -i [0-9,a-z] | awk '{print NR"    "$0}'

rm -rf "$tmprundir"
