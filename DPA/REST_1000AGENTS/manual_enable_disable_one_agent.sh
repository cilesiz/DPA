#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/agents

echo

curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > tmp1.txt

echo
echo
echo "LIST OF ALL AGENTS TO ENABLE / DISABLE"
echo

cat tmp1.txt | egrep -i "<name>|<id>|<status>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}' | paste - - - | cat -n
cat tmp1.txt | egrep -i "<name>|<id>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}' | paste - - | cat -n | awk '{print ":"$1":"$2":"$NF":"}' > tmp2.txt
echo
echo -n "Choose agent to enable/disable [No/Hostname/id] : "
read -e agentnak

cat tmp2.txt | grep -i ":$agentnak:" > tmp3.txt

berapa=`cat tmp3.txt | awk -F: '{print $2}'`
siapanya=`cat tmp3.txt | awk -F: '{print $3}'`
system_id=`cat tmp3.txt | awk -F: '{print $4}'`

echo
echo "Number = $berapa"
echo "Hostname = $siapanya"
echo "ID = $system_id"
cur_status=`cat tmp1.txt | egrep -i "<name>|<status>" | paste - - | grep ">$siapanya<" | awk '{print $2}' |awk -F">" '{print $2}' | awk -F"<" '{print $1}'`
echo
echo
echo "Current STATUS for agent $siapanya : $cur_status"
echo
echo "Enable or Disable Agent :"
echo "1) Enable"
echo "2) Disable"
echo -n "Your choice [1/2] : "
read -e en_disable
echo

if [ $en_disable -gt 0 -a $en_disable -eq 1 2> /dev/null ]
then
en_disable1=enabled
en_disable2=ENABLED
elif [ $en_disable -gt 0 -a $en_disable -eq 2 2> /dev/null ]
then
en_disable1=disabled
en_disable2=DISABLED
else
echo
echo "WRONG INPUT"
echo
exit
fi

if [ $berapa -gt 0 2> /dev/null ]
then

echo
echo "START TO $en_disable2 AGENT $siapanya"
echo "================================"
echo

curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"/"$system_id"/settings > tmp5.xml

now_status=`cat tmp5.xml | grep -i status | awk -F">" '{print $2}' | awk -F"<" '{print $1}'`

sed -i "s/$now_status/$en_disable2/g" tmp5.xml

echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X PUT -T tmp5.xml "$URL1"/"$system_id"/settings

echo
echo
echo "SUCCESSFULLY $en_disable2 AGENT $siapanya"
echo "====================================="
echo

curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > tmp4.txt

echo
echo
echo "LIST OF ALL AGENTS "
echo
cat tmp4.txt | egrep -i "<name>|<id>|<status>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}' | paste - - - | cat -n
echo

rm -rf tmp1.txt tmp2.txt tmp3.txt tmp4.txt tmp5.xml

else

echo "WRONG INPUT"
echo

fi
