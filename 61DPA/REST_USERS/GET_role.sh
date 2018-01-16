#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib
source /root/rosli/61DPA/LIB/listing_id.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.txt

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_apollo_rol" > "$tmp1"

echo
echo
xml fo "$tmp1"
echo
echo

listing_jer "$URL_apollo_rol" /userRoles/userRole/id userRole "$tmp1" id name description none 

echo
echo -n "Choose Agents [ No / ID ] : "
read -e user_id_nk

user_id_no=`cat "$tmp1" | grep -i "#$user_id_nk#" | awk -F"#" '{print $2}'`

if [ $user_id_no -gt 0 2> /dev/null ]
then

user_id=`cat "$tmp1" | grep -i "#$user_id_nk#" | awk -F"#" '{print $3}'`

echo
curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_apollo_rol"/"$user_id" | xml fo
echo

else

echo
echo "WRONG CHOICE - $user_id_nk"
echo

fi

rm -rf "$tmprundir"
