#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.txt
tmp2="$tmprundir"/tmp2.txt
tmp3="$tmprundir"/tmp3.txt

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_dpa_ctlpnl" > "$tmp1"

echo
echo
xml fo "$tmp1"
echo
echo "
SIMPLIFY RESULT :
================="
echo
xml sel -t -m controlPanels/controlPanel \
-o "ID=" -v id \
-o " NAME=" -v name \
-n "$tmp1" | grep -i [0-9,a-z] | awk '{print NR"   "$0}'
echo; echo

xml sel -t -m controlPanels/controlPanel -v numField -o "#" -v id -v numField -o "#" -v name -v numField -o "#" -n "$tmp1" | grep "#" | awk -F"#" '{print "#"NR$0}' > "$tmp2"

echo -n "Choose ControlPanel to display [ No / controlPanel_ID / Name ] : "
read -e rptnak

cat "$tmp2" | grep -i "#$rptnak#" > "$tmp3"

nombor=`cat "$tmp3" | awk -F# '{print $2}'`
rptmenu_id=`cat "$tmp3" | awk -F# '{print $3}'`

if [ $nombor -gt 0 2> /dev/null ]
then

echo
echo "Number = $nombor"
echo "ControlPanelID = $rptmenu_id"
echo

echo
curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_dpa_ctlpnl"/"$rptmenu_id" > "$tmp1"
echo
xml fo "$tmp1"
echo; echo
rm -rf "$tmprundir"

else

echo
echo "WRONG INPUT = $rptnak "
echo
rm -rf "$tmprundir"

fi
