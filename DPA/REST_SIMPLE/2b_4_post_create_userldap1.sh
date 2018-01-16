#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/users
URL2=http://"$HB_DPA":9004/apollo-api/userroles

echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL2" > tmp11.xml
echo

admin_id=`cat tmp11.xml | egrep -i "<id>|<name>" | paste - - | grep -i Administrator | awk -F"</id>" '{print $1}' | awk -F"<id>" '{print $2}'`

echo
echo '<user version="1" system="false" hidden="false"> ' > tmp22.xml
echo "  <displayName>userldap1</displayName> " >> tmp22.xml
echo "  <logonName>userldap1</logonName> " >> tmp22.xml
echo "  <externalName>userldap1</externalName> " >> tmp22.xml
echo "  <authenticationType>LDAP</authenticationType> " >> tmp22.xml
echo '  <userRole version="1"> ' >> tmp22.xml
echo "   <id>$admin_id</id> " >> tmp22.xml
echo "  </userRole> "  >> tmp22.xml
echo " </user> " >> tmp22.xml

echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -T tmp22.xml "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp11.xml tmp22.xml tmp1.txt 

