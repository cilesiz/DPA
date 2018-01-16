#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.xml
tmp111="$tmprundir"/tmp111.xml

echo "CHOOSE LDAP SERVER : "
echo
echo "1) 10.64.213.7 (LDAP no SSL)"
echo "2) 10.64.213.8 (LDAP with SSL) "
echo
echo -n "Choose LDAP [ No / IP address ] : "
read -e ldapnak

if [ $ldapnak == 1 -o $ldapnak == 10.64.213.7 ]
then
ldapserver=10.64.213.7; ldapport=389; uldapssl=false
grp1=ldap4; grp2=ldap3; grp3=ldap2
elif [ $ldapnak == 2 -o $ldapnak == 10.64.213.8 ]
then
ldapserver=10.64.213.8; ldapport=636; uldapssl=true
grp1=ldapgrp4; grp2=ldapgrp2; grp3=ldapgrp6
else
echo
echo "WRONG INPUT"
echo
rm -rf "$tmprundir"
exit
fi

echo '<ldapSettings version="1">' > "$tmp111"
echo "  <useLDAPAuthentication>true</useLDAPAuthentication> 
  <server>$ldapserver</server> 
  <port>$ldapport</port> 
  <ldapVersion>3</ldapVersion> 
  <useSSL>$uldapssl</useSSL> 
  <baseDN>ou=People,dc=homebase,dc=corp,dc=emc,dc=com</baseDN> 
  <uidAttribute>uid</uidAttribute> 
  <bindUser>userldap1</bindUser> 
  <bindPassword>userldap1</bindPassword> " >> "$tmp111"

echo
echo -n "ALLOW AUTO LOGON [ Y / N ] : "
read -e uautologon

if [ $uautologon == N -o $uautologon == n ]
then
echo "   <allowAutoLogon>false</allowAutoLogon> " >> "$tmp111"
echo " </ldapSettings> " >> "$tmp111"

elif [ $uautologon == Y -o $uautologon == y ]
then

echo "   <allowAutoLogon>true</allowAutoLogon> " >> "$tmp111"

echo
echo "GROUP DEFAULT ROLE : "
echo "1) None "
echo "2) User (only this allow in this test) "
echo
echo -n "Your choice [1/2] : "
read -e defrole

if [ $defrole == 1 ]
then

echo "   <defaultRole></defaultRole> " >> "$tmp111"

elif [ $defrole == 2 ]
then

echo "   <defaultRole>User</defaultRole> " >> "$tmp111"

else

echo
echo "WRONG INPUT"
echo
rm -rf "$tmprundir"
exit

fi 

echo "   <baseDNForGroup>ou=Group,dc=homebase,dc=corp,dc=emc,dc=com</baseDNForGroup> 
   <groupAttribute>CN</groupAttribute> 
   <groupMemberAttribute>memberUid</groupMemberAttribute> 
   <groupRoles> " >> "$tmp111"
echo '      <groupRole version="1"> ' >> "$tmp111" 
echo "         <group>$grp1</group> 
         <role>Engineer</role> 
      </groupRole> " >> "$tmp111" 
echo '      <groupRole version="1"> ' >> "$tmp111"
echo "         <group>$grp2</group> 
         <role>Application Owner</role> 
      </groupRole> " >> "$tmp111"
echo '      <groupRole version="1"> ' >> "$tmp111"
echo "         <group>$grp3</group> 
         <role>Administrator</role> 
      </groupRole> 
   </groupRoles> 
 </ldapSettings> " >> "$tmp111"

else

echo
echo "WRONG INPUT"
echo
rm -rf "$tmprundir"
exit

fi

echo
echo
xml fo "$tmp111"
echo
echo "PUT $URL_ldap_settg"
confirmrest

curl -k -v -u "$login1":"$paswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X PUT -T "$tmp111" "$URL_ldap_settg" > "$tmp1" 

echo

xml fo "$tmp1" 
echo
echo
rm -rf "$tmprundir"

