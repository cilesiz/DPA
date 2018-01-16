#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator
idtukar=8f71b2c8-064d-46e7-a255-e66ad36fcacf

URL1=http://"$HB_DPA":9004/apollo-api/users

echo
echo

echo '<user version="1" system="false" hidden="false"> ' > tmp11.xml
echo "  <displayName>au_ro</displayName> " >> tmp11.xml
echo "  <logonName>au_ro</logonName> " >> tmp11.xml
echo "  <externalName>au_ro</externalName> " >> tmp11.xml
echo "  <password>au_ro</password> " >> tmp11.xml
echo "  <authenticationType>PASSWORD</authenticationType> " >> tmp11.xml
echo '  <userRole version="1"> ' >> tmp11.xml
echo "   <id>$idtukar</id> " >> tmp11.xml
echo "  </userRole> "  >> tmp11.xml
echo " </user> " >> tmp11.xml

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -T tmp11.xml "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp11.xml tmp1.txt 
