#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/license

echo
echo "BEFORE ADD LICENSE"
echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > tmp12.txt
cat tmp12.txt
echo
echo
echo "TO DELETE LICENSE"
echo
# lic_id=`cat tmp12.txt | grep -i id | awk -F"<" '{print $2}' | awk -F">" '{print $2}'`

# curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X DELETE "$URL1"/"$lic_id"

echo
echo "CHOOSE LICENSES TO DELETE"
cat tmp12.txt | egrep -i "<id>|<name>" | awk -F"<" '{print $2}' | awk -F">" '{print $2}' | paste - - | cat -n
cat tmp12.txt | egrep -i "<id>|<name>" | awk -F"<" '{print $2}' | awk -F">" '{print "#"$2"#"}' | paste - - | awk -F"#" '{print "#"NR"#"$2"#"$(NF-1)"#"}' > tmp3.txt
echo
echo -n "LICENSE TO DELETE [ No / ID / Full name ] : "
read -e berapa

nombur=`cat tmp3.txt | grep -i "#$berapa#" | awk -F# '{print $2}'`
siapanya=`cat tmp3.txt | grep -i "#$berapa#" | awk -F# '{print $4}'`
system_id=`cat tmp3.txt | grep -i "#$berapa#" | awk -F# '{print $3}'`

if [ $nombur -gt 0 2>/dev/null ]
then

echo
echo "No : $nombur"
echo "Name : $siapanya"
echo "License ID : $system_id"

rm -rf tmp12.txt tmp3.txt

echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X DELETE "$URL1"/"$system_id"

echo
echo "SUCCESSFULLY DELETE LICENSE $system_id "
echo
echo "AFTER DELETE LICENSE"
echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"
echo
echo

else

echo
echo "WRONG INPUT"
echo

fi
