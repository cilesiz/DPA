#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/userroles
URL2=http://"$HB_DPA":9004/dpa-api/userroles

echo
curl -IL -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"
echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > tmp1.txt

echo
echo
echo "To check Menus list for given UserRole"
echo
echo "CHOOSE ROLE"
cat tmp1.txt | egrep -i "<link|<name>" > tmp2.txt
cat tmp1.txt | egrep -i "<link|<name>" | paste - - > tmp3.txt
cat tmp2.txt | grep -i "<name>" | awk -F"<" '{print $2}' | awk -F">" '{print $2}' | cat -n
cat tmp2.txt | grep -i "<name>" | awk -F"<" '{print $2}' | awk -F">" '{print "#"NR"#"$2"#"}' > tmp4.txt
echo
echo -n "User role choosen [No] : "
read -e userrole1
role1=`cat tmp4.txt | grep -i "#$userrole1#" | cut -d# -f3`
role1_id=`cat tmp3.txt | awk -F">" '{print "#"$1"#"$3}' | awk -F"<" '{print "#"$2"#"}' | grep "#$role1#" | awk -F"/" '{print $(NF-1)}' | awk -F'"' '{print $1}'`

echo
echo "Userrole = $role1"
echo "UserroleID = $role1_id"
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL2"/"$role1_id"/menus
# curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"/"$role1_id"/menus
echo

rm -rf tmp1.txt tmp2.txt tmp3.txt tmp4.txt

