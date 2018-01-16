#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib
source /root/rosli/61DPA/LIB/listing_id.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.txt

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X POST "$URL_dpa_sptzip" > "$tmp1" 2>&1

cat "$tmp1"
echo
dos2unix "$tmp1"
echo; echo

ziplocation=`cat "$tmp1" | grep -i Location | grep -i http | awk '{print $NF}'`
echo
echo -n "Download from $ziplocation
"
echo -n "
Give output file name : "
read -e outputfile
confirmrest

if [ x"$outputfile" != x ]; then
curl -k -v -u "$login1":"$paswd1" --output "$outputfile" "$ziplocation"
else
curl -k -v -u "$login1":"$paswd1" --output `echo "$dpaserver" | sed -e "s/\./\_/g"`_"$masa".zip "$ziplocation"
fi

echo; echo

rm -rf "$tmprundir"
