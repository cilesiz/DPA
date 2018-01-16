#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/userroles
URL2=http://"$HB_DPA":9004/apollo-api/users

echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > tmp1.txt

idtukar=`cat tmp1.txt | egrep "<id>|<name>" | paste - - | grep -i "<name>AdministratorTHREE</name>" | awk -F"</id>" '{print $1}' | awk -F"<id>" '{print $NF}'`

echo
echo

echo '<user version="1" system="false" hidden="false"> ' > tmp11.xml
echo "  <displayName>adminthree</displayName> " >> tmp11.xml
echo "  <logonName>adminthree</logonName> " >> tmp11.xml
echo "  <externalName>adminthree</externalName> " >> tmp11.xml
echo "  <password>adminthree</password> " >> tmp11.xml
echo "  <authenticationType>PASSWORD</authenticationType> " >> tmp11.xml
echo '  <userRole version="1"> ' >> tmp11.xml
echo "   <id>$idtukar</id> " >> tmp11.xml
echo "  </userRole> "  >> tmp11.xml
echo " </user> " >> tmp11.xml

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -T tmp11.xml "$URL2" > tmp2.txt

echo
cat tmp2.txt 
echo
echo
rm -rf tmp11.xml tmp1.txt tmp2.txt 
