#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib
source /root/rosli/61DPA/LIB/listing_id.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.txt

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_apollo_crd" > "$tmp1"

echo
echo
xml fo "$tmp1"
echo
echo

listing_jer "$URL_apollo_crd" /credentials/credential/id credential "$tmp1" id name cred/type description 

echo
echo -n "Choose credential [ No / ID ] : "
read -e credtl_nk

credtl_no=`cat "$tmp1" | grep -i "#$credtl_nk#" | awk -F"#" '{print $2}'`

if [ $credtl_no -gt 0 2> /dev/null ]
then

credtl=`cat "$tmp1" | grep -i "#$credtl_nk#" | awk -F"#" '{print $3}'`

echo
curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_apollo_crd"/"$credtl" | xml fo
echo

else

echo
echo "WRONG CHOICE - $credtl_nk"
echo

fi

rm -rf "$tmprundir"
