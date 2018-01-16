#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator
idtukar=c093d794-4659-49a3-a2f2-30048835606e

URL1=http://"$HB_DPA":9004/apollo-api/users

echo
echo

echo '<user version="1"> ' > tmp11.xml
echo "  <displayName>dcp_noa</displayName> " >> tmp11.xml
echo "  <logonName>dcp_noa</logonName> " >> tmp11.xml
echo "  <externalName>dcp_noa</externalName> " >> tmp11.xml
echo "  <password>dcp_noa</password> " >> tmp11.xml
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

