#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/loggers/root
tmp1=/tmp/tmplevel1.xml

echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > "$tmp1"

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
rm -rf "$tmp1"
exit

fi

echo
echo "INPUT XML"
echo "========="
echo
cat "$tmp1"
echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X PUT -T "$tmp1" "$URL1"
echo
echo
echo

rm -rf "$tmp1"
