#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator
idtukar=ba4a0ca0-a34a-4105-9cef-947abe7754c8

URL1=http://"$HB_DPA":9004/apollo-api/users

echo
echo

echo '<user version="1"> ' > tmp11.xml
echo "  <displayName>dcp_now</displayName> " >> tmp11.xml
echo "  <logonName>dcp_now</logonName> " >> tmp11.xml
echo "  <externalName>dcp_now</externalName> " >> tmp11.xml
echo "  <password>dcp_now</password> " >> tmp11.xml
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

