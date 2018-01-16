#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/userroles
URL2=http://"$HB_DPA":9004/dpa-api/userroles

echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > tmp1.txt

idtukar=`cat tmp1.txt | egrep "<id>|<name>" | paste - - | grep -i "<name>AdministratorTWO</name>" | awk -F"</id>" '{print $1}' | awk -F"<id>" '{print $NF}'`

echo '<userRoleMenus version="1"> ' >> tmp11.xml
echo "   <userRoleId>$idtukar</userRoleId> " >> tmp11.xml
echo "   <allMenus>true</allMenus> " >> tmp11.xml
echo "</userRoleMenus> " >> tmp11.xml

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -T tmp11.xml "$URL2"/"$idtukar"/menus

rm -rf tmp11.xml tmp1.txt
