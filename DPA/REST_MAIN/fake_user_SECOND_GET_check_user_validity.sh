#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/ldap-settings/user-test-request

fakeuser=XXXremotexUser2310XXX
fakepswd=sfsdafasd
fakeuserid=68b0a91f-1834-4afe-9f7b-a1a8ff14bc40

echo
echo "TO TEST USER LOGON AUTHENTICATION : " 
echo
echo "   USER   - $fakeuser " 
echo "   PASSWD - $fakepswd "
echo "   UID    - $fakeuserid "
echo
echo "Choose Result information level : "
echo
echo "1) Basic "
echo "2) Detail "
echo 
echo -n "Your choice [1/2] : "
read -e choice1

if [ $choice1 -gt 0 -a $choice1 -eq 1 2> /dev/null ]
then

echo
echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" "$URL1"/"$fakeuserid"/result/
echo
echo

elif [ $choice1 -gt 0 -a $choice1 -eq 2 2> /dev/null ]
then

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" "$URL1"/"$fakeuserid"/result/
echo
echo

else
echo
echo "WRONG INPUT"
echo
fi
