#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/settings/agents

echo

curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > tmp1.txt

echo
echo
echo "LIST OF ALL AGENTS BEFORE CHANGE"
echo

cat tmp1.txt | egrep -i "<name>|<id>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}' | paste - - | cat -n
cat tmp1.txt | egrep -i "<name>|<id>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}' | paste - - | cat -n | awk '{print ":"$1":"$2":"$NF":"}' > tmp2.txt
echo
echo -n "Choose agent to change [No/Hostname/id] : "
read -e agentnak

cat tmp2.txt | grep -i ":$agentnak:" > tmp3.txt

nombor=`cat tmp3.txt | awk -F: '{print $2}'`
namanya=`cat tmp3.txt | awk -F: '{print $3}'`
system_id=`cat tmp3.txt | awk -F: '{print $4}'`

echo
echo "Number = $nombor"
echo "Hostname = $namanya"
echo "ID = $system_id"
echo

if [ $nombor -gt 0 2> /dev/null ]
then

echo
echo "EXISTING CONF FOR $namanya"
echo "================================"
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"/"$system_id"
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"/"$system_id" > tmp4.txt

echo
echo "VALUE FOR $namanya"
echo "====================================="
echo
cat tmp4.txt | grep -v agentSettings | awk -F"</" '{print $1}' | awk -F"<" '{print $2}' | awk -F">" '{print $1"\t\t"$2}' | cat -n
echo
cat tmp4.txt | grep -v agentSettings | awk -F"</" '{print $1}' | awk -F"<" '{print $2}' | awk -F">" '{print $1"\t\t"$2}' | cat -n | awk '{print "#"$1"#"$2"#"$NF"#"}' > tmp5.txt

echo
echo -n "Choose value to check [No/VariableName/Value] : "
read -e valuenak
echo
echo -n "Choose new value : "
read -e newvaluenak

cat tmp5.txt | grep -i "#$valuenak#" > tmp6.txt

nombor=`cat tmp6.txt | awk -F# '{print $2}'`
varianame=`cat tmp6.txt | awk -F# '{print $3}'`
value_id=`cat tmp6.txt | awk -F# '{print $4}'`

cat tmp4.txt | sed -e "s/<$varianame>.*/<$varianame>$newvaluenak</$varianame>/g" > tmp7.txt

# rm -rf tmp1.txt tmp2.txt tmp3.txt tmp4.txt

else

echo "WRONG INPUT"
echo

fi
