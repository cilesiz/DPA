#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib

choose_server
listing_url

echo
echo "BEFORE ADD LICENSE"
echo
curl -k -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_dpa_licens"
echo
echo
echo "ADD LICENSE"
echo

licpwd=/root/rosli/61DPA/REST_LIC
licfile="$licpwd"/licenses_all.xml

for i in `cat "$licfile" | grep "##" | awk -F"##" '{print $NF}'`
do

echo "
ADD LICENSE $i

URL = $URL_dpa_licens
"

tmp1="$tmprundir"/tmp1.xml

awk "/##$i/,/\/licenses>/" "$licfile" | grep -v "##" > "$tmp1"

curl -k -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-T "$tmp1" -X POST "$URL_dpa_licens"

done

echo
echo
echo "AFTER ADD LICENSE"
echo
curl -k -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_dpa_licens"
echo
echo

### SETUPGUIDE section

echo "TICKED LICENSE IN SETUPGUIDE"
echo "----------------------------"
echo

menu_id=c6fea272-a2fb-4dcb-aa57-2c55e4ecd4ec

curl -k -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_dpa_stupgd"/"$menu_id" > "$tmp1"

sed -i "s/false/true/g" "$tmp1"

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X PUT -T "$tmp1" "$URL_dpa_stupgd"/"$menu_id"

echo; echo

rm -rf "$tmprundir"
