#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/ldap-settings

curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > tmp11.txt

test1=`cat tmp11.txt | wc -l`

if [ $test1 -lt 2 2>/dev/null ]
then
tukar='<ldapSettings version="1">'
else
tukar=`cat tmp11.txt | grep -i "<ldapSettings"`
fi

rm -rf tmp11.txt

echo "CHOOSE LDAP SERVER : "
echo
echo "1) 10.64.213.7 (LDAP no SSL)"
echo "2) 10.64.213.8 (LDAP with SSL) "
echo
echo -n "Choose LDAP [ No / IP address ] : "
read -e ldapnak

if [ $ldapnak == 1 -o $ldapnak == 10.64.213.7 ]
then
ldapserver=10.64.213.7
ldapport=389
uldapssl=false
grp1=ldap4
grp2=ldap3
grp3=ldap2
elif [ $ldapnak == 2 -o $ldapnak == 10.64.213.8 ]
then
ldapserver=10.64.213.8
ldapport=636
uldapssl=true
grp1=ldapgrp4
grp2=ldapgrp2
grp3=ldapgrp6
else
echo
echo "WRONG INPUT"
echo
exit
fi

echo "$tukar" > tmp111.xml
echo "  <useLDAPAuthentication>true</useLDAPAuthentication> " >> tmp111.xml
echo "  <server>$ldapserver</server> " >> tmp111.xml
echo "  <port>$ldapport</port> " >> tmp111.xml
echo "  <ldapVersion>3</ldapVersion> " >> tmp111.xml
echo "  <useSSL>$uldapssl</useSSL> " >> tmp111.xml
echo "  <baseDN>ou=People,dc=homebase,dc=corp,dc=emc,dc=com</baseDN> " >> tmp111.xml
echo "  <uidAttribute>uid</uidAttribute> " >> tmp111.xml
echo "  <bindUser>userldap1</bindUser> " >> tmp111.xml
echo "  <bindPassword>userldap1</bindPassword> " >> tmp111.xml

echo
echo -n "ALLOW AUTO LOGON [ Y / N ] : "
read -e uautologon

if [ $uautologon == N -o $uautologon == n ]
then
echo "   <allowAutoLogon>false</allowAutoLogon> " >> tmp111.xml
echo " </ldapSettings> " >> tmp111.xml

elif [ $uautologon == Y -o $uautologon == y ]
then

echo "   <allowAutoLogon>true</allowAutoLogon> " >> tmp111.xml

echo
echo "GROUP DEFAULT ROLE : "
echo "1) None "
echo "2) User (only this allow in this test) "
echo
echo -n "Your choice [1/2] : "
read -e defrole

if [ $defrole == 1 ]
then

echo "   <defaultRole></defaultRole> " >> tmp111.xml

elif [ $defrole == 2 ]
then

echo "   <defaultRole>User</defaultRole> " >> tmp111.xml

else

echo
echo "WRONG INPUT"
echo
exit

fi 

echo "   <baseDNForGroup>ou=Group,dc=homebase,dc=corp,dc=emc,dc=com</baseDNForGroup> " >> tmp111.xml
echo "   <groupAttribute>CN</groupAttribute> " >> tmp111.xml
echo "   <groupMemberAttribute>memberUid</groupMemberAttribute> " >> tmp111.xml
echo "   <groupRoles> " >> tmp111.xml
echo '      <groupRole version="1"> ' >> tmp111.xml
echo "         <group>$grp1</group> " >> tmp111.xml
echo "         <role>Engineer</role> " >> tmp111.xml
echo "      </groupRole> " >> tmp111.xml
echo '      <groupRole version="1"> ' >> tmp111.xml
echo "         <group>$grp2</group> " >> tmp111.xml
echo "         <role>Application Owner</role> " >> tmp111.xml
echo "      </groupRole> " >> tmp111.xml
echo '      <groupRole version="1"> ' >> tmp111.xml
echo "         <group>$grp3</group> " >> tmp111.xml
echo "         <role>Administrator</role> " >> tmp111.xml
echo "      </groupRole> " >> tmp111.xml
echo "   </groupRoles> " >> tmp111.xml
echo " </ldapSettings> " >> tmp111.xml

else

echo
echo "WRONG INPUT"
echo
exit

fi

echo
echo

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X PUT -T tmp111.xml "$URL1" > tmp1.txt 

echo

cat tmp1.txt 
# cat tmp111.xml
echo
echo
rm -rf tmp1.txt tmp111.xml

