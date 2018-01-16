#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/credentials

echo

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > tmp1.txt

echo
cat tmp1.txt | egrep -i "<name>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}' > tmp11.txt 
cat tmp1.txt | egrep -i "<id>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}' > tmp12.txt
paste tmp11.txt tmp12.txt | cat -n
paste tmp11.txt tmp12.txt | cat -n | awk '{print "#"$1"#"$2"#"$NF"#"}' > tmp2.txt 
echo
echo -n "Choose agent to check [No/id] : "
read -e agentnak

cat tmp2.txt | grep -i "#$agentnak#" > tmp3.txt

berapa=`cat tmp3.txt | awk -F# '{print $2}'`
siapanya=`cat tmp3.txt | awk -F# '{print $3}'`
system_id=`cat tmp3.txt | awk -F# '{print $4}'`

rm -rf tmp1.txt tmp11.txt tmp12.txt tmp2.txt tmp3.txt

echo
echo "Number = $berapa"
echo "Hostname = $siapanya"
echo "ID = $system_id"
echo

if [ $berapa -gt 0 2> /dev/null ]
then

curl -IL -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"/"$system_id"
echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"/"$system_id"
echo
echo

else

echo "WRONG INPUT"
echo

fi
