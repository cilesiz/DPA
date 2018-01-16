#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/ldap-settings

echo
curl -IL -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"
echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X PUT -d '

  <server>10.64.213.17</server> 
  <port>389</port> 
  <ldapVersion>3</ldapVersion> 
  <useSSL>false</useSSL> 
  <baseDN>ou=People,dc=homebase,dc=corp,dc=emc,dc=com</baseDN> 
  <uidAttribute>uid</uidAttribute> 
  <bindUser>userldap1</bindUser> 
  <bindPassword>userldap1</bindPassword> 
   <allowAutoLogon>true</allowAutoLogon>
   <defaultRole>User</defaultRole>
   <baseDNForGroup>ou=Group,dc=homebase,dc=corp,dc=emc,dc=com</baseDNForGroup>
   <groupAttribute>CN</groupAttribute>
   <groupMemberAttribute>memberUid</groupMemberAttribute>
   <groupRoles>
      <groupRole version="1">
         <group>ldap4</group>
         <role>Engineer</role>
      </groupRole>
      <groupRole version="1">
         <group>ldap3</group>
         <role>Application Owner</role>
      </groupRole>
   </groupRoles>
</ldapSettings>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp1.txt 

