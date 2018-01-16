#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib

choose_server
listing_url

echo "POST $URL_svr_setshp"

tmp1="$tmprundir"/tmp1.txt
tmp2="$tmprundir"/tmp2.xml
tmp3="$tmprundir"/tmp3.txt

echo -n "
SharePoint URL sites (eg http://192.0.2.0/sites )
URL : "
read -e sharepointurl

echo -n "
SharePoint username : "
read -e username

echo -n "
SharePoint password : "
read -e passwd

echo -n "<serverSettings>
<sharepointSiteURL>$sharepointurl</sharepointSiteURL>
<sharepointUsername>$username</sharepointUsername>
<sharepointPassword>$passwd</sharepointPassword>
</serverSettings> " > "$tmp2"

echo
echo "XML INPUT"
echo "---------"
xml fo "$tmp2"
echo
curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-T "$tmp2" -X POST "$URL_svr_setshp"/validation-request > "$tmp1" 2>&1

dos2unix "$tmp1"
echo
urlresult=`cat "$tmp1" | grep -i validation-request | grep -i result | awk -F"http" '{print "http"$2}' | awk -F"result" '{print $1"result"}'`

echo
echo "RESULT URL = $urlresult"
echo

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$urlresult" > "$tmp3"


echo; echo
xml fo "$tmp3"
echo; echo
rm -rf "$tmprundir"

