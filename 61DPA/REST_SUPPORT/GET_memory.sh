#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib
source /root/rosli/61DPA/LIB/listing_id.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.txt
tmp2="$tmprundir"/tmp2.txt

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_dpa_sptmem"?unit=GB > "$tmp1"

echo
echo
xml fo "$tmp1"
echo
echo "
SIMLIFY ( unit=GB) :
====================
"
xml sel -t -m memory-pool/memory \
-o "max=" -v max \
-o "   used=" -v used \
-o "   free=" -v free \
-o "   name=" -v name \
-n "$tmp1" > "$tmp2"

cat "$tmp2" | grep -i [0-9,a-z] | awk '{print NR"   "$0}'

echo; echo

rm -rf "$tmprundir"
