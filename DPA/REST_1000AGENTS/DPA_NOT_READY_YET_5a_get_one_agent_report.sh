#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/users
URL2=http://"$HB_DPA":9004/dpa-api/agent

echo

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > tmp1.txt

echo
cat tmp1.txt | egrep -i "<displayName>|<logonName>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}' | paste - - | grep -i agent | cat -n
cat tmp1.txt | egrep -i "<displayName>|<logonName>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}' | paste - - | grep -i agent | cat -n | awk '{print "#"$1"#"$2"#"$NF"#"}' > tmp2.txt
echo
echo -n "Choose agent to check [No/Hostname/Agent] : "
read -e agentnak

cat tmp2.txt | grep -i "#$agentnak#" > tmp3.txt

nombor=`cat tmp3.txt | awk -F# '{print $2}'`
namanya=`cat tmp3.txt | awk -F# '{print $3}'`
system_id=`cat tmp3.txt | awk -F# '{print $4}' | awk -F: '{print $2}'`

rm -rf tmp1.txt tmp2.txt tmp3.txt

echo
echo "Number = $nombor"
echo "Hostname = $namanya"
echo "ID = $system_id"
echo

if [ $nombor -gt 1 2> /dev/null ]
then

curl -IL -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.dpa.agent-v1+xml" -H "Content-Type: application/vnd.emc.dpa.agent-v1+xml" -X GET "$URL2"/"$system_id"/report
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.dpa.agent-v1+xml" -H "Content-Type: application/vnd.emc.dpa.agent-v1+xml" -X GET "$URL2"/"$system_id"/report
echo
echo

else

echo "WRONG INPUT"
echo

fi
