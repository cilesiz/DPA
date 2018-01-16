#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib
source /root/rosli/61DPA/LIB/listing_id.lib

choose_server
listing_url

tmp11="$tmprundir"/tmp11.txt

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X POST -d '<user version="1" system="false" hidden="false">
  <displayName>blankuser</displayName>
  <logonName>blankuser</logonName>
  <externalName>blankuser</externalName>
  <password></password>
  <authenticationType>PASSWORD</authenticationType>
  <userRole version="1">
	<name>Engineer</name>
  </userRole>
</user> ' "$URL_apollo_usr" > "$tmp11"

echo
xml fo "$tmp11"
echo

rm -rf "$tmprundir"
