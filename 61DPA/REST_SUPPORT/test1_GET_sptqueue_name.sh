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
-X GET "$URL_dpa_sptque"/names > "$tmp1"

echo
echo
xml fo "$tmp1"
xml sel -t -m queues/queue -v numField -o "#" -v @name -v numField -o "#" -n "$tmp1" | grep "#" | awk -F"#" '{print "#"NR$0}' > "$tmp2"
echo
echo "
Choose which name that you want to use : 
"
cat "$tmp2" | awk -F"#" '{print $2"\t"$3"\t"$4}'
echo -n "
Name [ No / Name ] = "
read -e namenk

nameid=`cat "$tmp2" | grep -i "#$namenk#" | awk -F# '{print $3}'`

rm -rf "$tmprundir"

if [ x"$nameid" != x ]; then

echo "
URL = $URL_dpa_sptque?name=$nameid
"

for i in `seq 1 1 1000`
do

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_dpa_sptque?name=$nameid"

sleep 1
echo; echo
done

else
echo "
WRONG CHOICE = $namenk
"
rm -rf "$tmprundir"
fi
