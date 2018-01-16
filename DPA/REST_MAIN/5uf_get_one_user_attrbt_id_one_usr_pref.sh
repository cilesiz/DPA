#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/users

echo

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > tmp1.txt

echo
cat tmp1.txt | egrep -i "apollo-api|<logonName>" | paste - - | awk -F"/" '{print $(NF-1)"#"$(NF-2)}' | awk -F"<logonName>"  '{print $NF}' | awk -F"<"  '{print $1$2}' | awk -F'"' '{print NR"#"$1}' | awk -F"#" '{print $1"\t"$2"\t""\t""\t"$3}'
cat tmp1.txt | egrep -i "apollo-api|<logonName>" | paste - - | awk -F"/" '{print $(NF-1)"#"$(NF-2)}' | awk -F"<logonName>"  '{print $NF}' | awk -F"<"  '{print $1$2}' | awk -F'"' '{print "#"NR"#"$1"#"}' > tmp2.txt

echo
echo -n "Choose agent to check [No/LogonName/ID] : "
read -e agentnak

cat tmp2.txt | grep -i "#$agentnak#" > tmp3.txt

berapa=`cat tmp3.txt | awk -F# '{print $2}'`
siapanya=`cat tmp3.txt | awk -F# '{print $3}'`
system_id=`cat tmp3.txt | awk -F# '{print $4}'`

rm -rf tmp1.txt tmp2.txt tmp3.txt

echo
echo "Number = $berapa"
echo "LogonName = $siapanya"
echo "ID = $system_id"
echo

if [ $berapa -gt 0 2> /dev/null ]
then

echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"/"$system_id"/attributes > tmp1.txt
echo
# cat tmp4.txt
echo "List of preferences for user $siapanya"
echo "-----------------------------------"
cat tmp1.txt | grep -i "<name>" | awk -F"<name>" '{print $NF}' | awk -F"</name>" '{print NR"\t"$1}' 
cat tmp1.txt | grep -i "<name>" | awk -F"<name>" '{print $NF}' | awk -F"</name>" '{print "#"NR"#"$1"#"}' > tmp2.txt
echo
echo -n "Choose Preferences to check [ No / Preference ] : "
read -e prefnak

cat tmp2.txt | grep -i "#$prefnak#" > tmp3.txt

nombur=`cat tmp3.txt | awk -F# '{print $2}'`
siapaanya=`cat tmp3.txt | awk -F# '{print $3}'`

if [ $nombur -gt 0 2> /dev/null ]
then

echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"/"$system_id"/attributes/"$siapaanya" 
echo
rm -rf tmp1.txt tmp2.txt tmp3.txt
echo

else

echo
echo "WRONG INPUT FOR PREFERENCES"
echo
echo "LIST ALL PREFERENCES (IF ANY) "
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"/"$system_id"/attributes
echo
echo

fi

else

echo "WRONG INPUT"
echo

fi
