#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.xml
tmp111="$tmprundir"/tmp111.xml

echo -n '<ldapSettings version="1">
  <useLDAPAuthentication>false</useLDAPAuthentication>
  <port>0</port>
  <useSSL>false</useSSL>
  <allowAutoLogon>false</allowAutoLogon>
</ldapSettings>' > "$tmp111"


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

