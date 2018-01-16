#!/bin/bash

dpaserver="$1"
texthelp="Usage : [ ./POST_credential.sh or sh POST_credential.sh ] <DPA_server>"

if [ -n "$dpaserver" ]; then

URL=http://"$dpaserver":9004/dpa-api/license
login1=administrator
paswd1=administrator

tmprundir=/tmp/tmp_license
mkdir "$tmprundir"

echo
echo "BEFORE ADD LICENSE"
echo
curl -k -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL"
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

URL = $URL
"

tmp1="$tmprundir"/tmp1.xml

awk "/##$i/,/\/licenses>/" "$licfile" | grep -v "##" > "$tmp1"

curl -k -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-T "$tmp1" -X POST "$URL"

done

echo
echo
echo "AFTER ADD LICENSE"
echo
curl -k -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL"
echo
echo

rm -rf "$tmprundir"

else
echo; echo
echo "$texthelp"
echo; echo
fi
