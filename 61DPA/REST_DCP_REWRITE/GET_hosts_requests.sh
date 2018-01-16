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

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_apollo_nod" > "$tmp1"

xml sel -t -m 'nodes/node[@type="Host"]' -v numField -o "#" -v id -v numField -o "#" -v displayName -v numField -o "#" -n "$tmp1" | grep "#" | sort -t "#" -k 3 | awk -F"#" '{print "#"NR$0}' > "$tmp2"

echo; echo

cat "$tmp2" | awk -F"#" '{print $2"\t"$3"\t"$4}'

echo
echo -n "Choose NODE to check [No/Node ID/Display Name] : "
read -e agentnak

cat "$tmp2" | grep -i "#$agentnak#" > "$tmp3"

nombor=`cat "$tmp3" | awk -F# '{print $2}'`
node_id=`cat "$tmp3" | awk -F# '{print $3}'`
namanode=`cat "$tmp3" | awk -F# '{print $4}'`

if [ $nombor -gt 0 2> /dev/null ]
then

echo
echo "Number = $nombor"
echo "Node ID = $node_id"
echo "Display Name = $namanode"
echo

echo 
echo "URL = $URL_dpa_nodes"/"$node_id"/requests
echo; echo

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_dpa_nodes"/"$node_id"/requests > "$tmp1"

echo
echo
xml fo "$tmp1"
echo; echo

echo "
SIMPLY RESULTS
==============
" 
echo "Node ID = $node_id"
echo "Display Name = $namanode"
echo

# xml sel -t -m effectiveRequests/effectiveRequest \
# -o "agtnod=" -v agent/node/id \
# -o "  Rmt/Lcl=" -v 'agent[@type]' \
# -o "  module=" -v module \
# -o "  functn=" -v function \
# -o "  frqprd=" -v frequency/period \
# -o "  retention=" -v retention \
# -n "$tmp1" > "$tmp2"

xml sel -t -m effectiveRequests/effectiveRequest \
-o "  AGT_LESS=" -v 'agent[@type="None"]/node/name' \
-o "  AGT_LOCAL=" -v 'agent[@type="Local"]/node/name' \
-o "  AGT_REMOTE=" -v 'agent[@type="Remote"]/node/name' \
-o "  module=" -v module \
-o "  functn=" -v function \
-o "  frqprd=" -v frequency/period \
-o "  retention=" -v retention \
-n "$tmp1" > "$tmp2"

cat "$tmp2" | grep -i [0-9,a-z] | awk '{print NR"    "$0}'

echo; echo

rm -rf "$tmprundir"

else

echo
echo "WRONG INPUT = $agentnak "
echo
rm -rf "$tmprundir"

fi
