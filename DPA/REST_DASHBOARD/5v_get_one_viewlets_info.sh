#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/viewlettemplates

echo

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > tmp1.txt

echo
cat tmp1.txt | grep -i "<name>" | awk -F">" '{print $2}' | awk -F"<" '{print "#"$1"#"}' > tmp2a.txt
cat tmp1.txt | grep -i "<id>" | awk -F">" '{print $2}' | awk -F"<" '{print "#"$1"#"}' > tmp2b.txt
paste tmp2b.txt tmp2a.txt | awk -F"#" '{print NR"\t"$2"\t"$(NF-1)}'
paste tmp2b.txt tmp2a.txt | awk -F"#" '{print "#"NR"#"$2"#"$(NF-1)"#"}' > tmp2.txt
echo
echo -n "Choose Viewlet Templates to check [ No / ID / Fullname ] : "
read -e agentnak

berapa=`cat tmp2.txt | grep "#$agentnak#" | awk -F"#" '{print $2}'`
siapanya=`cat tmp2.txt | grep "#$agentnak#" | awk -F"#" '{print $4}'`
viewlet_id=`cat tmp2.txt | grep "#$agentnak#" | awk -F"#" '{print $3}'`

rm -rf tmp1.txt tmp2a.txt tmp2b.txt tmp2.txt

echo
echo "Number = $berapa"
echo "LogonName = $siapanya"
echo "ID = $viewlet_id"
echo

if [ $berapa -gt 0 2> /dev/null ]
then

curl -IL -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"/"$viewlet_id"
echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"/"$viewlet_id"
echo
echo

else

echo "WRONG INPUT"
echo

fi
