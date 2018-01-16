#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/server/settings

echo
curl -IL -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"
echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > tmp1.txt

echo
echo
# cat tmp1.txt 
echo "CHOOSE YOUR ROLE"
cat tmp1.txt | egrep -i "<link|<name>" > tmp2.txt
cat tmp1.txt | egrep -i "<link|<name>" | paste - - > tmp3.txt
cat tmp2.txt | grep -i "<name>" | awk -F"<" '{print $2}' | awk -F">" '{print $2}' | cat -n
cat tmp2.txt | grep -i "<name>" | awk -F"<" '{print $2}' | awk -F">" '{print $2}' | cat -n | awk '{print "#"$1"#"$2"#"}' > tmp4.txt
echo
echo -n "User role choosen [No] : "
read -e userrole1
role1=`cat tmp4.txt | grep -i "#$userrole1#" | cut -d# -f3`
echo
# echo "$role1"
URL3=`cat tmp3.txt | grep "$role1" | awk -F"href" '{print $2}' | awk -F">" '{print $1}' | awk -F'"' '{print $2}'`
echo "$URL3" > tmp5.txt

echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL3"
echo

rm -rf tmp1.txt tmp2.txt tmp3.txt tmp4.txt tmp5.txt

