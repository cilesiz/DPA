#!/bin/bash

HB_DPA=10.64.205.162
user1=usr4
pswd1=usr4

URL2=http://"$HB_DPA":9004/apollo-api/nodes

echo

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL2" > tmp1.txt

echo
# cat tmp1.txt | egrep -i "<id>|<name>|<attributeName>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}' | paste - - | cat -n
# cat tmp1.txt | egrep -i "<id>|<name>|<attributeName>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}' | paste - - | cat -n | awk '{print "#"$1"#"$2"#"$NF"#"}' > tmp2.txt

# cat tmp1.txt | egrep -i "href=|<name>" | grep -vi assignedAttributes | awk -F"/" '{print $(NF-1)}' | awk -F'"' '{print $1}' | paste - - | awk -F"<name>" '{print $2,$1}' | awk -F"<" '{print $1"\t"$2}' | cat -n
# cat tmp1.txt | egrep -i "href=|<name>" | grep -vi assignedAttributes | awk -F"/" '{print $(NF-1)}' | awk -F'"' '{print $1}' | paste - - | awk -F"<name>" '{print $2,$1}' | awk -F"<" '{print $1,$2}' |  awk '{print "#"NR"#"$1"#"$2"#"}' > tmp2.txt

cat tmp1.txt | grep -i "href=" | grep -vi "assignedAttributes" | awk -F"/" '{print $(NF-1)}' | awk -F'"' '{print "#"$1"#"}' > tmp_id.txt
cat tmp1.txt | grep -i "<name>" | awk -F"</" '{print $1}' | awk -F"<name>" '{print "#"$NF"#"}' > tmp_name.txt

paste tmp_name.txt tmp_id.txt > tmp2a.txt

cat tmp2a.txt | awk -F"#" '{print NR"\t"$2"\t\t"$(NF-1)}' 
cat tmp2a.txt | awk -F"#" '{print "#"NR"#"$2"#"$(NF-1)"#"}' > tmp2.txt


echo
echo -n "Choose Node to check [No/Node Name/Node ID] : "
read -e agentnak

cat tmp2.txt | grep -i "#$agentnak#" > tmp3.txt

nombor=`cat tmp3.txt | awk -F# '{print $2}'`
node_id=`cat tmp3.txt | awk -F# '{print $4}'`
namanode=`cat tmp3.txt | awk -F# '{print $3}'`

rm -rf tmp1.txt tmp_id.txt tmp_name.txt tmp2a.txt tmp2.txt tmp3.txt

echo
echo "Number = $nombor"
echo "Node ID = $node_id"
echo "Node name = $namanode"
echo

if [ $nombor -gt 0 2> /dev/null ]
then

curl -IL -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL2"/"$node_id"
echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL2"/"$node_id"
echo
echo

else

echo "WRONG INPUT"
echo

fi
