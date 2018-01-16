#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib

choose_server
listing_url

echo "GET $URL_apollo_log"

tmp1="$tmprundir"/tmp1.txt

echo
curl -k -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_apollo_log" > "$tmp1"

nowlevel=`cat "$tmp1" | grep logger | awk -F"level=" '{print $2}' | awk -F'"' '{print $2}'`

echo
echo "CURRENT SETTING"
echo "==============="
echo
cat "$tmp1"
echo
echo
echo "--> LEVEL = $nowlevel"
echo
echo
echo "Choose new LEVEL of logger"
echo "=========================="
echo
echo "1) FATAL" ; echo "2) ERROR" ; echo "3) WARN" ; echo "4) INFO -- default" ; echo "5) DEBUG"
echo

echo -n "Choose [ 1 - 5 ] : "
read -e level1

if [ $level1 == 1 -o $level1 == FATAL ]
then
sed -i "s/$nowlevel/FATAL/g" "$tmp1"
elif [ $level1 == 2 -o $level1 == ERROR ]
then
sed -i "s/$nowlevel/ERROR/g" "$tmp1"
elif [ $level1 == 3 -o $level1 == WARN ]
then
sed -i "s/$nowlevel/WARN/g" "$tmp1"
elif [ $level1 == 4 -o $level1 == INFO ]
then
sed -i "s/$nowlevel/INFO/g" "$tmp1"
elif [ $level1 == 5 -o $level1 == DEBUG ]
then
sed -i "s/$nowlevel/DEBUG/g" "$tmp1"
else
echo
echo "WRONG INPUT - $level1 is not in the list"
echo
rm -rf "$tmprundir"
exit

fi

echo
echo "INPUT XML"
echo "========="
echo
cat "$tmp1"
echo
echo
curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X PUT -T "$tmp1" "$URL_apollo_log"
echo
echo
echo

rm -rf "$tmprundir"
