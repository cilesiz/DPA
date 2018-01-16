#!/bin/bash

#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib

choose_server
listing_url

tmp12="$tmprundir"/tmp12.txt
tmp3="$tmprundir"/tmp3.txt

echo
echo "BEFORE ADD LICENSE"
echo
curl -k -u "$login1":"$paswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL_dpa_licens" > "$tmp12"
xml fo "$tmp12"
echo
echo
echo "TO DELETE LICENSE"
echo
# lic_id=`cat "$tmp12" | grep -i id | awk -F"<" '{print $2}' | awk -F">" '{print $2}'`

# curl -k -u "$login1":"$paswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X DELETE "$URL_dpa_licens"/"$lic_id"

echo
echo "CHOOSE LICENSES TO DELETE"
cat "$tmp12" | egrep -i "<id>|<name>" | awk -F"<" '{print $2}' | awk -F">" '{print $2}' | paste - - | cat -n
cat "$tmp12" | egrep -i "<id>|<name>" | awk -F"<" '{print $2}' | awk -F">" '{print "#"$2"#"}' | paste - - | awk -F"#" '{print "#"NR"#"$2"#"$(NF-1)"#"}' > "$tmp3"
echo
echo -n "LICENSE TO DELETE [ No / ID / Full name ] : "
read -e berapa

nombur=`cat "$tmp3" | grep -i "#$berapa#" | awk -F# '{print $2}'`
siapanya=`cat "$tmp3" | grep -i "#$berapa#" | awk -F# '{print $4}'`
system_id=`cat "$tmp3" | grep -i "#$berapa#" | awk -F# '{print $3}'`

if [ $nombur -gt 0 2>/dev/null ]
then

echo
echo "No : $nombur"
echo "Name : $siapanya"
echo "License ID : $system_id"

rm -rf "$tmprundir"

echo
curl -k -u "$login1":"$paswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X DELETE "$URL_dpa_licens"/"$system_id"

echo
echo "SUCCESSFULLY DELETE LICENSE $system_id "
echo
echo "AFTER DELETE LICENSE"
echo
curl -k -u "$login1":"$paswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL_dpa_licens"
echo
echo
rm -rf "$tmprundir"

else

echo
echo "WRONG INPUT"
echo
rm -rf "$tmprundir"

fi
