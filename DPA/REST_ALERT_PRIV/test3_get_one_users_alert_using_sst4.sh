#!/bin/bash

HB_DPA=10.64.205.162
user1=sst4
pswd1=sst4

URL1=http://"$HB_DPA":9004/dpa-api/alert

echo

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > tmp1.txt

echo
cat tmp1.txt | grep -i "dpa-api/alert" | awk -F"/" '{print $6}' | awk -F'"' '{print $1}' > tmp2a.txt
cat tmp1.txt | grep -i "<description>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}' > tmp2b.txt
paste tmp2a.txt tmp2b.txt | cat -n
paste tmp2b.txt tmp2a.txt | cat -n | awk '{print "#"$1"#"$2"#"$NF"#"}' > tmp2.txt
echo
echo -n "Choose Alert to check [ No / ID ] : "
read -e agentnak

cat tmp2.txt | grep -i "#$agentnak#" > tmp3.txt

nombor=`cat tmp3.txt | awk -F# '{print $2}'`
namanya=`cat tmp3.txt | awk -F# '{print $3}'`
system_id=`cat tmp3.txt | awk -F# '{print $4}'`

rm -rf tmp1.txt tmp2a.txt tmp2b.txt tmp2.txt tmp3.txt

echo
echo "Number = $nombor"
echo "LogonName = $namanya"
echo "ID = $system_id"
echo

if [ $nombor -gt 0 2> /dev/null ]
then

echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"/"$system_id"
echo
echo

else

echo "WRONG INPUT"
echo

fi
