#!/bin/bash

DPA_svr=10.64.213.59
urlssl="https://"
portssl=9002
HB_DPA="$urlssl""$DPA_svr:$portssl"

user1=administrator
pswd1=administrator

URL_ldapstgutr="$HB_DPA"/apollo-api/ldap-settings/user-test-request

fakeuser=testldap6
fakepswd=testldap6
fakeuserid=e93c95b0-cfdf-4745-9296-69e763299f0b

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
echo "GET $URL_ldapstgutr/$fakeuserid/result "
echo
echo
curl -k -u "$user1":"$pswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
"$URL_ldapstgutr"/"$fakeuserid"/result
echo
echo

elif [ $choice1 -gt 0 -a $choice1 -eq 2 2> /dev/null ]
then

echo
echo "GET $URL_ldapstgutr/$fakeuserid/result "
echo
echo
curl -k -v -u "$user1":"$pswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
"$URL_ldapstgutr"/"$fakeuserid"/result
echo
echo

else
echo
echo "WRONG INPUT"
echo
fi
