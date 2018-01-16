#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib
source /root/rosli/61DPA/LIB/listing_id.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.txt
tmpinfo="$tmprundir"/tmpinfo.txt
tmpinfo2="$tmprundir"/tmpinfo2.txt

################### HARD CODED VALUE ###############
echo "#Enter DPA License Key#1#c6fea272-a2fb-4dcb-aa57-2c55e4ecd4ec#" > "$tmpinfo"
echo "#Set Password for defaults Users#2#af5668c5-733d-4caa-b82e-193efada65a2#" >> "$tmpinfo"
echo "#Discover the Environment [Howto Inst Data Collectn Agnts/Run Disc Wizard]#3#8ddbd837-0b8d-4c91-90de-037b7801cb0b#" >> "$tmpinfo"
echo "#Configure Users Security [Define Extnl Authtn (eg.LDAP)/Define Roles/Create Users]#4#f48f9245-ebed-4424-ab13-4eb96d97b7a1#" >> "$tmpinfo"
echo "#Create Groups of objects#5#e15882fb-2eb6-4082-a501-17fc31c1b45a#" >> "$tmpinfo"
echo "#Configure Alerting [Understand Analysis Policies/Best Practices fr Alrtg/Review Deflt Analysis Policy]#6#ac129e7b-a870-427a-8b63-38dcac162a9a#" >> "$tmpinfo"
echo "#How to Customise Dashboards#7#8aeeab31-36b7-456a-85e3-1db0c4cb0f96#" >> "$tmpinfo"
####################################################
###########################################################################################
echo "#Enter DPA License Key#1#c6fea272-a2fb-4dcb-aa57-2c55e4ecd4ec#c964dc98-4309-471a-bd24-9da544aae4aa#" > "$tmpinfo2"
echo "#Set Password for defaults Users#2#af5668c5-733d-4caa-b82e-193efada65a2#b9234fef-bac8-4c8a-9a6e-6adb025db977#" >> "$tmpinfo2"
echo "#How to Install Data Collection Agents#3#8ddbd837-0b8d-4c91-90de-037b7801cb0b#7aa8422d-d0e5-4845-97cc-12dcc1f10e81#" >> "$tmpinfo2"
echo "#Run the Discovery Wizard#3#8ddbd837-0b8d-4c91-90de-037b7801cb0b#055377df-6028-4119-99e8-f9006fbcf48d#" >> "$tmpinfo2"
echo "#Define External Authentication (e.g. LDAP)#4#f48f9245-ebed-4424-ab13-4eb96d97b7a1#8df82904-b0dd-49c7-a7f3-aa9f20bd8d4b#" >> "$tmpinfo2"
echo "#Define Roles#4#f48f9245-ebed-4424-ab13-4eb96d97b7a1#02d17336-f5b8-48b9-a161-18c1f627c1b0#" >> "$tmpinfo2"
echo "#Create Users#4#f48f9245-ebed-4424-ab13-4eb96d97b7a1#de90ef39-2f7d-4627-bd27-49f6e8046252#" >> "$tmpinfo2"
echo "#Create Groups of objects#5#e15882fb-2eb6-4082-a501-17fc31c1b45a#8209ba93-27f5-4daf-b8e4-5cf5411f87db#" >> "$tmpinfo2"
echo "#Understand Analysis Policies#6#ac129e7b-a870-427a-8b63-38dcac162a9a#435745c6-79cf-4cff-ace9-3f106b2a2fcd#" >> "$tmpinfo2"
echo "#Best Practices for Alerting#6#ac129e7b-a870-427a-8b63-38dcac162a9a#7e00acda-7ae8-46c6-a96e-9cfaf0363638#" >> "$tmpinfo2"
echo "#Review the Default Analysis Policy#6#ac129e7b-a870-427a-8b63-38dcac162a9a#d36bb17e-6572-48d2-b499-4f662f227135#" >> "$tmpinfo2"
echo "#How to Customise Dashboards#7#8aeeab31-36b7-456a-85e3-1db0c4cb0f96#f820eb9a-f084-4584-b3f2-c53ac48aba70#" >> "$tmpinfo2"
###########################################################################################

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_dpa_stupgd" > "$tmp1"

echo
echo
xml fo "$tmp1"
echo
echo

########## FROM OLD SCRIPTS

echo
echo "LIST OF SETUPGUIDE ITEMS :"
echo "=========================="
echo

tmp4="$tmprundir"/tmp4.txt

i=1
echo -n > "$tmp4"
for grp_id in `cat "$tmp1" | grep -i "href=" | awk -F'"' '{print $(NF-1)}' | awk -F'/' '{print $NF}'`
do
echo -n "$i"
cat "$tmpinfo" | grep "#$grp_id#" | awk -F"#" '{print " - "$2" - (ID) "$4}'
echo -n "#$i#" >> "$tmp4"
cat "$tmpinfo" | grep "#$grp_id#" | awk -F"#" '{print $2"#"$4"#"}' >> "$tmp4"
i=$((i + 1))
done

echo
echo -n "Choose SETUPGUID ITEM to CHECK [ No / Fullname / ID ] : "
read -e stpgd

nombur=`cat "$tmp4" | grep "#$stpgd#" | awk -F"#" '{print $2}'`
namanya=`cat "$tmp4" | grep "#$stpgd#" | awk -F"#" '{print $3}'`
menu_id=`cat "$tmp4" | grep "#$stpgd#" | awk -F"#" '{print $4}'`

echo
echo "No = $nombur // Desciptn = $namanya // ID = $menu_id"
echo

if [ $nombur -gt 0 2> /dev/null ]
then

echo
echo
curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_dpa_stupgd"/"$menu_id" > "$tmp1"

echo
echo
xml fo "$tmp1"
echo
echo

echo
echo
echo "SIMPLIFY"
echo "========"
# echo
# cat "$tmp1" | awk "/<setupGuideItem /,/<\/ticked>/" | grep -v "<setupGuideItem" | awk -F"</" '{print $1}' | awk -F">" '{print $2}' | paste - - | awk '{print "#"NR"#"$1"#"$2"#"}'
echo
for pilihan in `cat "$tmp1" | awk "/<setupGuideItem /,/<\/ticked>/" | grep -v "<setupGuideItem" | awk -F"</" '{print $1}' | awk -F">" '{print $2}' | paste - - | awk '{print "#"NR"#"$1"#"$2"#"}' | awk -F"#" '{print $3}'`
do

cat "$tmpinfo2" | grep "#$pilihan#" | awk -F"#" '{print "ITEM = "$2}'
echo "ITEM_ID = $pilihan"
echo "STATUSTICK = `cat "$tmp1" | awk "/<setupGuideItem /,/<\/ticked>/" | grep -v "<setupGuideItem" | awk -F"</" '{print $1}' | awk -F">" '{print $2}' | paste - - | awk '{print "#"NR"#"$1"#"$2"#"}' | grep "#$pilihan#" | awk -F"#" '{print $4}'`"
echo

done

echo
echo

else

echo
echo "WRONG INPUT - SETUPGUID ITEM SECTION"
echo

fi

rm -rf "$tmprundir"
