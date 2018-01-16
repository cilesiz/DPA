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
-X GET "$URL_dpa_alerts" > "$tmp1"

echo
echo
xml fo "$tmp1"
echo; echo
echo "List of Alerts :"
echo "----------------"
echo

xml sel -t -m alerts/alert \
-v numField -o "#" \
-v id -v numField -o "#" \
-v description -v numField -o "#" \
-v category -v numField -o "#" \
-v severity -v numField -o "#" \
-n "$tmp1" | grep "#" | sort -t "#" -k 3 | awk -F"#" '{print "#"NR$0}' > "$tmp2"

cat "$tmp2" | awk -F"#" '{print $2"\t"$3"\t"$4" ("$5"/"$6")"}'

echo
echo -n "Choose Alert to check [ No / Alert_ID ] : "
read -e agent_id_nk

agent_id_no=`cat "$tmp2" | grep -i "#$agent_id_nk#" | awk -F"#" '{print $2}'`

if [ $agent_id_no -gt 0 2> /dev/null ]
then

agent_id=`cat "$tmp2" | grep -i "#$agent_id_nk#" | awk -F"#" '{print $3}'`

echo
curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_dpa_alerts"/"$agent_id" | xml fo
echo

else

echo
echo "WRONG CHOICE - $agent_id_nk"
echo

fi

rm -rf "$tmprundir"
