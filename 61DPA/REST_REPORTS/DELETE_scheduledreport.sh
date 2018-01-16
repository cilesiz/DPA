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
-X GET "$URL_dpa_schrpt" > "$tmp1"

echo
echo
xml fo "$tmp1"
echo
echo

xml sel -t -m scheduledReports/scheduledReport \
-v numField -o "#" -v id \
-v numField -o "#" -v report/name \
-v numField -o "#" -v controlPanel/name \
-v numField -o "#" -v description \
-v numField -o "#" -v schedule/name \
-v numField -o "#" \
-n "$tmp1" | grep "#" | sort -t "#" -k 3 | awk -F"#" '{print "#"NR$0}' > "$tmp2"

echo; echo

semua=`cat "$tmp2" | wc -l`

for nombo in `seq 1 1 "$semua"` 
do
chekrpt=`cat "$tmp2" | grep -i "#$nombo#" | awk -F"#" '{print $4}'`
chekpnl=`cat "$tmp2" | grep -i "#$nombo#" | awk -F"#" '{print $5}'`

if [ x"$chekpnl" != x ]; then
cat "$tmp2" | grep -i "#$nombo#" | awk -F"#" '{print $2"  "$3" // SCHCTLPNL="$5" // SCH="$7}'
elif [ x"$chekrpt" != x ]; then
cat "$tmp2" | grep -i "#$nombo#" | awk -F"#" '{print $2"  "$3" // SCHRPT="$4" // SCH="$7}'
else
cat "$tmp2" | grep -i "#$nombo#" | awk -F"#" '{print $2"  "$3" // RPT_N_CTLPNL=NULL // SCH="$7}'
fi
done
# cp "$tmp2" testrosli.xml

echo
echo -n "Choose ScheduleReport TO DELETE [ No / ID ] : "
read -e user_id_nk

user_id_no=`cat "$tmp2" | grep -i "#$user_id_nk#" | awk -F"#" '{print $2}'`

if [ $user_id_no -gt 0 2> /dev/null ]
then

user_id=`cat "$tmp2" | grep -i "#$user_id_nk#" | awk -F"#" '{print $3}'`

echo
curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X DELETE "$URL_dpa_schrpt"/"$user_id" 
echo

else

echo
echo "WRONG CHOICE - $user_id_nk"
echo

fi

rm -rf "$tmprundir"
