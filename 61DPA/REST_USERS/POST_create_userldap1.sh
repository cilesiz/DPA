#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib
source /root/rosli/61DPA/LIB/listing_id.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.txt

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X POST -d '
<user version="1" system="false" hidden="false">
  <displayName>userldap1</displayName>
  <logonName>userldap1</logonName>
  <externalName>userldap1</externalName>
  <authenticationType>LDAP</authenticationType>
  <userRole version="1">
    <name>Administrator</name>
    <description>UserRole for an Administrator</description>
    <permissions>
      <permission name="apollo.userattribute.read">true</permission>
      <permission name="apollo.user.read">true</permission>
      <permission name="apollo.user.readwrite">true</permission>
      <permission name="apollo.permissions.list">true</permission>
      <permission name="apollo.userrole.read">true</permission>
      <permission name="apollo.userrole.readwrite">true</permission>
      <permission name="apollo.userattribute.readwrite">true</permission>
      <permission name="import.readwrite">false</permission>
    </permissions>
  </userRole>
</user> ' "$URL_apollo_usr" > "$tmp1"

echo
echo
xml fo "$tmp1"
echo
echo

rm -rf "$tmprundir"
