#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL2=http://"$HB_DPA":9004/apollo-api/nodes

echo

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL2" > tmp1.txt

echo
echo "LIST OF NODES IN DPA SERVER $HB_DPA"
echo
cat tmp1.txt | egrep -i "<id>|<name>|<attributeName>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}' | paste - - | cat -n
cat tmp1.txt | egrep -i "<id>|<name>|<attributeName>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}' | paste - - | cat -n | awk '{print "#"$1"#"$2"#"$NF"#"}' > tmp2.txt
echo
echo -n "Choose agent to DELETE [No/Node ID/Node Name] : "
read -e agentnak

cat tmp2.txt | grep -i "#$agentnak#" > tmp3.txt

nombor=`cat tmp3.txt | awk -F# '{print $2}'`
node_id=`cat tmp3.txt | awk -F# '{print $3}'`
namanode=`cat tmp3.txt | awk -F# '{print $4}'`

rm -rf tmp1.txt tmp2.txt tmp3.txt

echo
echo "Number = $nombor"
echo "Node ID = $node_id"
echo "Node name = $namanode"
echo

if [ $nombor -gt 0 2> /dev/null ]
then

echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X DELETE "$URL2"/"$node_id"
echo
echo

else

echo "WRONG INPUT"
echo

fi
