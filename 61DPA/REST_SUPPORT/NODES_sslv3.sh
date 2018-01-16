#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib
source /root/rosli/61DPA/LIB/listing_id.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.xml
tmp2="$tmprundir"/tmp2.txt
tmp3="$tmprundir"/tmp3.txt

echo

curl -k -v --sslv3 -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_apollo_nod" > "$tmp1"

xml sel -t -m nodes/node \
-v numField -o "#" \
-v id -v numField -o "#" \
-v globalName -v numField -o "#" \
-v displayName -v numField -o "#" \
-n "$tmp1" | grep "#" | sort -t "#" -k 3 | awk -F"#" '{print "#"NR$0}' > "$tmp2"

echo; echo

for ii in `cat "$tmp2" | awk -F"#" '{print $2}'`
do
namaglobal=`cat "$tmp2" | grep -i "#$ii#" | awk -F"#" '{print $4}' | wc -m`
namadsplay=`cat "$tmp2" | grep -i "#$ii#" | awk -F"#" '{print $5}' | wc -m`

if [ $namaglobal -ge $namadsplay ]; then
cat "$tmp2" | grep -i "#$ii#" | awk -F"#" '{print $2"\t"$3"\t"$4}'
else
cat "$tmp2" | grep -i "#$ii#" | awk -F"#" '{print $2"\t"$3"\t"$5}'
fi

done

echo
echo -n "Choose NODE to check [No/Node ID/Display Name] : "
read -e agentnak

cat "$tmp2" | grep -i "#$agentnak#" > "$tmp3"

nombor=`cat "$tmp3" | awk -F# '{print $2}'`
node_id=`cat "$tmp3" | awk -F# '{print $3}'`
namanode=`cat "$tmp3" | awk -F# '{print $4}'`

rm -rf "$tmprundir"

if [ $nombor -gt 0 2> /dev/null ]
then

echo
echo "Number = $nombor"
echo "Node ID = $node_id"
echo "Display Name = $namanode"
echo

curl -k -IL --sslv3 -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_apollo_nod"/"$node_id"
echo
curl -k --sslv3 -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_apollo_nod"/"$node_id"
echo
echo

else

echo
echo "WRONG INPUT = $agentnak "
echo
rm -rf "$tmprundir"

fi
