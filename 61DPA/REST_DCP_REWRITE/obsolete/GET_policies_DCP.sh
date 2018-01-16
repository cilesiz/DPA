#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib
source /root/rosli/61DPA/LIB/listing_id.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.txt
tmp2="$tmprundir"/tmp2.txt

curl -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_dpa_dtcltn" > "$tmp1"

echo
echo
xml fo "$tmp1"
echo
echo

listing_jer "$URL_dpa_dtcltn" /dataCollectionPolicies/dataCollectionPolicy/id dataCollectionPolicy "$tmp1" id name enabled description 

echo
echo -n "Choose protectionPolicy [ No / ID ] : "
read -e dcp_id_nk

dcp_id_no=`cat "$tmp1" | grep -i "#$dcp_id_nk#" | awk -F"#" '{print $2}'`

if [ $dcp_id_no -gt 0 2> /dev/null ]
then

dcp_id=`cat "$tmp1" | grep -i "#$dcp_id_nk#" | awk -F"#" '{print $3}'`

echo
curl -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_dpa_dtcltn"/"$dcp_id" > "$tmp2"
echo
xml fo "$tmp2"
echo; echo
echo "
Simplify DCP
============"

xml sel -t -m  dataCollectionPolicy/requests/request \
-o "module=" -v module \
-o "      function=" -v function \
-o "      enabled=" -v enabled \
-n "$tmp2" > "$tmp1"

cat "$tmp1" | grep -i [0-9,a-z] | awk '{print NR"    "$0}'

echo; echo

# module function <agent type="Local"> enabled

else

echo
echo "WRONG CHOICE - $dcp_id_nk"
echo

fi

rm -rf "$tmprundir"
