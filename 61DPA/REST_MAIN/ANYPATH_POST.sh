#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib

choose_server
listing_url

echo -n "Give path : "
read -e anypath

URL_req="${URL_base_nossl%/}" 

echo "GET $URL_req""$anypath"
confirmrest

tmp1="$tmprundir"/tmp1.xml

echo -n "XML INPUT TYPE [ file / data ] : "
read -e xmltype

echo -n "ENTER XML INPUT : "
read -e xmlinput
if [ $xmltype == file ]; then
cat "$xmlinput" > "$tmp1"
elif [ $xmltype == data ]; then
echo "$xmlinput" > "$tmp1"
else
echo "
Wrong XML  type
"
rm -rf "$tmprundir"
exit
fi
echo
xml fo "$tmp1"
echo

echo
echo
curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X POST -T "$tmp1" "$URL_req""$anypath" 

echo
echo

rm -rf "$tmprundir"
