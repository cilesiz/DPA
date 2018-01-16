#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/agents

#### TEMPORARY FILES SECTION
masa=`date +%Y%m%d_%H%M%S`
tmp1=/tmp/tmp1_"$masa".xml
tmp2=/tmp/tmp2_"$masa".xml
tmp3=/tmp/tmp3_"$masa".xml
tmp4=/tmp/tmp4_"$masa".xml

echo

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > "$tmp1"

echo
cat "$tmp1" | egrep -i "<name>|<id>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}' | paste - - | cat -n
cat "$tmp1" | egrep -i "<name>|<id>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}' | paste - - | cat -n | awk '{print ":"$1":"$2":"$NF":"}' > "$tmp2"
echo
echo -n "Choose agent to check [No/Hostname/id] : "
read -e agentnak

cat "$tmp2" | grep -i ":$agentnak:" > "$tmp3"

berapa=`cat "$tmp3" | awk -F: '{print $2}'`
siapanya=`cat "$tmp3" | awk -F: '{print $3}'`
system_id=`cat "$tmp3" | awk -F: '{print $4}'`

rm -rf "$tmp1" "$tmp2" "$tmp3"

echo
echo "Number = $berapa"
echo "Hostname = $siapanya"
echo "ID = $system_id"
echo

if [ $berapa -gt 0 2> /dev/null ]
then

echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"/"$system_id"/settings
echo
echo

else

echo "WRONG INPUT"
echo

fi
