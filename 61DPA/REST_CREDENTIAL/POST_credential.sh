#!/bin/bash

credtype="$1"
credname="$2"
creduser="$3"
credpswd="$4"
creddsct="$5"
texthelp="Usage : [ ./POST_credential.sh or sh POST_credential.sh ] <Type=Standard> <GivenName> <Username> <Password> <Description>"

if [ x"$credtype" == Standard ]||[ -n "$credname" ]||[ -n "$creduser" ]||[ -n "$credpswd" ]; then

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib
source /root/rosli/61DPA/LIB/listing_id.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.txt
tmp2="$tmprundir"/tmp2.xml

echo '<credential version="1">' > "$tmp2"
echo "  <name>$credname</name>
  <description>$creddsct</description>
  <cred>
    <type>$credtype</type>
    <standard>
      <username>$creduser</username>
      <password>$credpswd</password>
    </standard>
  </cred>
</credential> " >> "$tmp2"

echo "
XML INPUT
========="
xml fo "$tmp2"
echo; echo

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X POST -T "$tmp2" "$URL_apollo_crd" > "$tmp1"

echo
echo
xml fo "$tmp1"
echo
echo

rm -rf "$tmprundir"

else
echo; echo
echo "$texthelp"
echo; echo
fi
