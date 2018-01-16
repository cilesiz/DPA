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
-X GET "$URL_dpa_sptque"/functions > "$tmp1"

echo
echo
xml fo "$tmp1"
xml sel -t -m functions/function -o "#" -v name -o "#" -n "$tmp1" | grep "#" | awk -F"#" '{print "#"NR$0}' > "$tmp2"
echo
echo
echo "
Choose which function that you want to use :
"
cat "$tmp2" | awk -F"#" '{print $2"\t"$3}'
echo -n "
Function [ No / Name ] = "
read -e ofunctnk

functid=`cat "$tmp2" | grep -i "#$ofunctnk#" | awk -F# '{print $3}'`

if [ x"$functid" != x ]; then

echo "
URL = $URL_dpa_sptque?function=$functid
"

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_dpa_sptque?function=$functid"

echo; echo

else
echo "
WRONG CHOICE = $ofunctnk
"
fi

rm -rf "$tmprundir"
