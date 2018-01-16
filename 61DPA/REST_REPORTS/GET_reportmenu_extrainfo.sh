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
-X GET "$URL_dpa_rptmnu" > "$tmp1"

echo
echo
xml fo "$tmp1"
echo
echo
echo "SIMPLIFY RESULT :
================="
xml sel -t -m reportMenus/reportMenu \
-o "ID=" -v id \
-o " # NAME=" -v name \
-o " # LABEL=" -v menu/label \
-n "$tmp1" | grep -i [0-9,a-z] | awk '{print NR"   "$0}'

echo

xml sel -t -m reportMenus/reportMenu -v numField -o "#" -v id -v numField -o "#" -v name -v numField -o "#" -n "$tmp1" | grep "#" | sort -t "#" -k 3 | awk -F"#" '{print "#"NR$0}' > "$tmp2"

echo -n "Choose ReportMenu [ No / ReportMenu_ID / Name ] : "
read -e rptnak

cat "$tmp2" | grep -i "#$rptnak#" > "$tmp3"

nombor=`cat "$tmp3" | awk -F# '{print $2}'`
rptmenu_id=`cat "$tmp3" | awk -F# '{print $3}'`
rptmenu_name=`cat "$tmp3" | awk -F# '{print $4}'`

if [ $nombor -gt 0 2> /dev/null ]
then

echo
echo "Number = $nombor"
echo "ReportMenuID = $rptmenu_id"
echo "Name = $rptmenu_name"
echo



echo -n "Choose extra info to look :
1) users
2) reports
3) control-panels

Choose [ 1 - 3 ] : "
read -e dependnk

if [ x"$dependnk" = x1 ]; then
urlext="users"
elif [ x"$dependnk" = x2 ]; then
urlext="reports"
elif [ x"$dependnk" = x3 ]; then
urlext="control-panels"
else
urlext=""
fi


curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_dpa_rptmnx"/"$rptmenu_id"/"$urlext" > "$tmp1"
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
