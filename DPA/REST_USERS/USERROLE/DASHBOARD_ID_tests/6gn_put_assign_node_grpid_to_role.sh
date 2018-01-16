#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/userroles

echo
curl -IL -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"
echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > tmp1.txt

echo
echo
echo "CHOOSE YOUR ROLE"
cat tmp1.txt | grep -i "<link" | awk -F"/" '{print $(NF-1)}' | awk -F'"' '{print "#"$(NF-1)"#"}' > tmp2.txt
cat tmp1.txt | grep -i "<name>" | awk -F"<name>" '{print $NF}' | awk -F"</name>" '{print "#"$(NF-1)"#"}' > tmp3.txt
paste tmp3.txt tmp2.txt | awk -F"#" '{print NR"\t"$2"\t\t"$(NF-1)}'
paste tmp3.txt tmp2.txt | awk -F"#" '{print "#"NR"#"$2"#"$(NF-1)"#"}' > tmp4.txt

echo
echo -n "User role choosen [ No / User / ID ] : "
read -e userrole1
berapa=`cat tmp4.txt | grep -i "#$userrole1#" | cut -d# -f2`
role1=`cat tmp4.txt | grep -i "#$userrole1#" | cut -d# -f3`
role1_id=`cat tmp4.txt | grep -i "#$userrole1#" | cut -d# -f4`

if [ $berapa -gt 0 2>/dev/null ]
then

echo
echo "Userrole = $role1"
echo "UserroleID = $role1_id"
echo

echo

rm -rf tmp1.txt tmp2.txt tmp3.txt tmp4.txt

URL2=http://"$HB_DPA":9004/apollo-api/nodes

echo

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL2" > tmp1.txt

echo
echo "List of Nodes"
echo "-------------"

cat tmp1.txt | grep -i "href=" | grep -vi "assignedAttributes" | awk -F"/" '{print $(NF-1)}' | awk -F'"' '{print "#"$1"#"}' > tmp_id.txt
cat tmp1.txt | grep -i "<name>" | awk -F"</" '{print $1}' | awk -F"<name>" '{print "#"$NF"#"}' > tmp_name.txt

paste tmp_name.txt tmp_id.txt > tmp2a.txt

cat tmp2a.txt | awk -F"#" '{print NR"\t"$2"\t\t"$(NF-1)}' 
cat tmp2a.txt | awk -F"#" '{print "#"NR"#"$2"#"$(NF-1)"#"}' > tmp2.txt


echo
echo -n "Choose Node to assign to Userrole [No/Node Name/Node ID] : "
read -e agentnak

cat tmp2.txt | grep -i "#$agentnak#" > tmp3.txt

berapa=`cat tmp3.txt | awk -F# '{print $2}'`
node_id=`cat tmp3.txt | awk -F# '{print $4}'`
siapanode=`cat tmp3.txt | awk -F# '{print $3}'`

rm -rf tmp1.txt tmp_id.txt tmp_name.txt tmp2a.txt tmp2.txt tmp3.txt

echo
echo "Number = $berapa"
echo "Node ID = $node_id"
echo "Node name = $siapanode"
echo

if [ $berapa -gt 0 2> /dev/null ]
then

echo

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"/"$role1_id"/groups > tmp1.txt

# cp tmp1.txt tmp_prob1.txt

new1=`cat tmp1.txt | sed -e "/<error>/,/<\/error>/{//p;d;}" | grep -v "error>" | wc -l`
if [ $new1 -gt 1 2>/dev/null ]
then 

cat tmp1.txt | awk "/<userRoleGroups/,/<\/userRoleId>/" > tmp111.xml
echo "    <groups> " >> tmp111.xml
cat tmp1.txt | awk "/<groups/,/<\/groups>/" | grep -v groups >> tmp111.xml
rm -rf tmp1.txt

else

echo '<userRoleGroups version="1">' > tmp111.xml
echo "   <userRoleId>$role1_id</userRoleId> " >> tmp111.xml
echo "    <groups> " >> tmp111.xml

fi

echo '      <group version="1"> ' >> tmp111.xml
echo "         <groupId>$node_id</groupId> " >> tmp111.xml
echo "      </group> " >> tmp111.xml
echo "      </groups> " >> tmp111.xml
echo " </userRoleGroups> " >> tmp111.xml

echo 
echo "UserRoleGroups XML"
echo "=================="
cat tmp111.xml
echo
echo

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X PUT -T tmp111.xml "$URL1"/"$role1_id"/groups

rm -rf tmp111.xml

echo
echo

else

echo
echo "WRONG INPUT Node choice"
echo

fi

else

echo
echo "WRONG INPUT Userrole choice"
echo

fi
