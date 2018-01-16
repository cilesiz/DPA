#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/ldap-settings

echo
curl -IL -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"
echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X PUT -d '
<ldapSettings lastModified="2013-08-30T15:29:09.124+01:00" version="1">
  <server>10.64.213.18</server> 
  <port>636</port> 
  <ldapVersion>3</ldapVersion> 
  <useSSL>true</useSSL> 
  <baseDN>ou=People,dc=homebase,dc=corp,dc=emc,dc=com</baseDN> 
  <uidAttribute>uid</uidAttribute> 
  <bindUser>userldap1</bindUser> 
  <bindPassword>userldap1</bindPassword> 
  <allowAutoLogon>true</allowAutoLogon>
  <defaultRole>Administrator</defaultRole>
</ldapSettings>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp1.txt 
