#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib
source /root/rosli/61DPA/LIB/listing_id.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.txt
tmp2="$tmprundir"/tmp2.txt
tmp3="$tmprundir"/tmp3.txt

echo
curl -k -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_apollo_usr" > "$tmp2"
echo

echo
echo "CHOOSE USER/PASSWD TO USE IN SETUPGUIDE SERVICES"

echo
cat "$tmp2" | egrep -i "apollo-api|<logonName>" | paste - - | grep -v "agent:" | awk -F"/" '{print $(NF-1)"#"$(NF-2)}' | awk -F"<logonName>"  '{print $NF}' | awk -F"<"  '{print $1$2}' | awk -F'"' '{print NR"#"$1}' | awk -F"#" '{print $1"\t"$2"\t""\t""\t"$3}'
cat "$tmp2" | egrep -i "apollo-api|<logonName>" | paste - - | grep -v "agent:" | awk -F"/" '{print $(NF-1)"#"$(NF-2)}' | awk -F"<logonName>"  '{print $NF}' | awk -F"<"  '{print $1$2}' | awk -F'"' '{print "#"NR"#"$1"#"}' > "$tmp3"
echo
echo -n "Choose User to LOGIN/USE [No/LogonName/ID] : "
read -e usernak

nombor=`cat "$tmp3" | grep -i "#$usernak#" | awk -F# '{print $2}'`
usernya=`cat "$tmp3" | grep -i "#$usernak#" | awk -F# '{print $3}'`

echo

if [ $nombor -gt 0 2> /dev/null ]
then

echo "CHOOSEN : No = $nombor / LogonName = $usernya"

if [ $usernya != administrator ]
then

echo
echo -n "Password for $usernya : "
read -e pswdnya

else
pswdnya=administrator
fi

echo
curl -k -v -u "$usernya":"$pswdnya" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_dpa_stupgd" > "$tmp1"

echo
echo
xml fo "$tmp1"
echo
echo

else

echo
echo "WRONG INPUT"
echo

fi

rm -rf "$tmprundir"
