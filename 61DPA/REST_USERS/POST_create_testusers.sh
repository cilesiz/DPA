#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib
source /root/rosli/61DPA/LIB/listing_id.lib

choose_server
listing_url

userfile=testusers.xml
rolefile=testroles.xml

tmp11="$tmprundir"/tmp11.txt

for i in `cat "$rolefile" | grep "##" | awk -F"##" '{print $NF}'`
do

echo "
ADD USERROLE $i"

tmp1="$tmprundir"/tmp1.xml

awk "/##$i/,/\/userRole>/" "$rolefile" | grep -v "##" > "$tmp1"

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X POST -T "$tmp1" "$URL_apollo_rol" > "$tmp11"

echo
xml fo "$tmp11"
roleid=`xml sel -T -t -m userRole -v id "$tmp11"`
echo "

ROLE ID $i = $roleid"
echo

echo "
ADD USER $i
"

awk "/##$i/,/\/user>/" "$userfile" | grep -v "##" > "$tmp1"

sed -i "s/<id><\/id>/<id>$roleid<\/id>/g" "$tmp1"

echo "XML INPUT
---------"
xml fo "$tmp1"
echo

confirmrest

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X POST -T "$tmp1" "$URL_apollo_usr" > "$tmp11"

echo
xml fo "$tmp11"
echo
done

rm -rf "$tmprundir"
