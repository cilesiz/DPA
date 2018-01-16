#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib
source /root/rosli/61DPA/LIB/listing_id.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.xml
tmp2="$tmprundir"/tmp2.txt

echo

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_dpa_ndmtdt" > "$tmp1"


echo
xml fo "$tmp1"
echo
echo
echo "
SIMPLIFY RESULTS
================
"

xml sel -t -m dpaNodesMetadata/apolloNodeMetadata \
-o "name=" -v name \
-o "  topLevel=" -v topLevel \
-o "  relatedDatamine=" -v relatedDatamineEntities/DPADatamineEntityMetadataXML/name \
-n "$tmp1" > "$tmp2"

cat "$tmp2" | grep -i [0-9,a-z] | awk '{print NR"    "$0}'

echo; echo

rm -rf "$tmprundir"

