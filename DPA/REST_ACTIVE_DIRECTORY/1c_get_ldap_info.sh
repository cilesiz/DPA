#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/ldap-settings

echo
curl -IL -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"
echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > tmp1.txt

echo
echo
cat tmp1.txt 
echo
echo
test1=`cat tmp1.txt | wc -l`

if [ $test1 -lt 2 2>/dev/null ]
then
tukar='<ldapSettings version="1">'
else
tukar=`cat tmp1.txt | grep -i "<ldapSettings"`
fi

for failtukar in `ls 3_put*.sh 2> /dev/null`
do
sed -i "s/<ldapSettings.*/$tukar/g" "$failtukar"
done

rm -rf tmp1.txt

