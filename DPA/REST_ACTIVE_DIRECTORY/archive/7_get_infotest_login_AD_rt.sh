#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/users
URL2=http://"$HB_DPA":9004/apollo-api/ldap-settings

LDAP1=10.64.213.17
LDAP2=10.64.213.18
LDAP_AD=10.64.213.66

tmp1=/tmp/tmp1.txt
tmp2=/tmp/tmp2.txt
tmp4=/tmp/tmp4.txt

echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > "$tmp1"
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL2" > "$tmp2"
echo

LDAP_IP=`cat "$tmp2" | egrep -i "<server>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}'`
AUTO_LOGON=`cat "$tmp2" | egrep -i "<allowAutoLogon>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}'`
DEFAULT_ROLE=`cat "$tmp2" | egrep -i "<defaultRole>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}'`

cat "$tmp1" | grep -i "<logonName>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}' > "$tmp4"

if [ $LDAP_IP == $LDAP_AD ] 
then

echo
echo "============================"
echo "AD server IP : $LDAP_IP "
echo "============================"
echo
echo "List of AD users : "
echo
echo "administrator"
echo "admintest1 , admintest2 , admintest3 , admintest4"
echo "usertest1 , usertest2 , usertest3 , usertest4 , usertest5 , usertest6"
echo
echo "List of AD group : "
echo
echo "testgrp1 ( admintest3 , admintest4 )"
echo "testgrp2 ( usertest4 , usertest5 , usertest6 )"
echo 
echo "=========================="
echo "DPA SERVER $HB_DPA : "
echo "=========================="
echo
echo "AUTO LOGON = $AUTO_LOGON "
echo "DEFAULT ROLE = $DEFAULT_ROLE "
echo
echo "List of Group and Role : "
echo "------------------------"
cat "$tmp2" | egrep -i "<group>|<role>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}' | paste - -
echo
echo "List of existing Users : "
echo "------------------------"
cat "$tmp4" | grep -v "agent:" 
echo 
echo
echo "========================"
echo -n "LDAP user to test login : "
read -e usernyer

userla1=`echo $usernyer | cut -c1-8`

if [ $userla1 = administ ]
then
passwd1=administrator
# passwd1=H0meBase1
elif [ $userla1 = admintes ]
then
passwd1=H0meBase
else
passwd1=risckey
fi
echo
echo "Active Directory User   = $usernyer"
echo "Active Directory passwd = $passwd1"
echo

curl -IL -u "$usernyer":"$passwd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" "$URL2"

echo 

curl -X GET -u "$usernyer":"$passwd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" "$URL2"

echo
echo

else

echo 
echo "LDAP IS NOT ACTIVE DIRECTORY $LDAP_AD"
echo "LDAP = $LDAP_IP"
echo

fi

rm -rf "$tmp1" "$tmp2" "$tmp4"
