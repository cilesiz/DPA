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
echo "To DELETE One Groups list for given UserRole"
echo
echo "CHOOSE ROLE"
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

rm -rf tmp1.txt tmp2.txt tmp3.txt tmp4.txt

if [ $berapa -gt 0 2>/dev/null ]
then

echo
echo "Userrole = $role1"
echo "UserroleID = $role1_id"
echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"/"$role1_id"/groups > tmp1.txt
echo

echo "CHOOSE GROUPP_ID TO DELETE"
cat tmp1.txt | grep -A100 -e '<groups' | grep -i "<groupId>" | awk -F"</" '{print $1}' | awk -F">" '{print NR"\t"$NF}'
cat tmp1.txt | grep -A100 -e '<groups' | grep -i "<groupId>" | awk -F"</" '{print $1}' | awk -F">" '{print "#"NR"#"$NF"#"}' > tmp2.txt

echo
echo -n  "User role choosen [ No / Group_ID ] : "
read -e grp_id
nombur=`cat tmp2.txt | grep -i "#$grp_id#" | cut -d# -f2`
group_id=`cat tmp2.txt | grep -i "#$grp_id#" | cut -d# -f3`

if [ $nombur -gt 0 2>/dev/null ]
then

echo
echo "Group_ID = $group_id"
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X DELETE "$URL1"/"$role1_id"/groups/"$group_id" > tmp3.txt
echo

cat tmp3.txt
rm -rf tmp1.txt tmp2.txt tmp3.txt

echo
echo

else

echo
echo "WRONG INPUT Group ID"
echo
exit

fi

else

echo
echo "WRONG INPUT Role Choosen"
echo
exit

fi
