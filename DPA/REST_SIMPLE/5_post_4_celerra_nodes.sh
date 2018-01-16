#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/nodes

nodeno1=4
echo
for newnode in `seq 1 1 $nodeno1`
do
echo

echo ' <node type="Celerra"> ' > tmp11.xml
echo "     <name>uncle-mgmt-$newnode.wysdm.lab.emc.com</name> " >> tmp11.xml
echo "     <displayName>uncle-mgmt-$newnode</displayName> " >> tmp11.xml
echo '     <creatorType>apollo</creatorType> ' >> tmp11.xml
echo ' </node> ' >> tmp11.xml

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -T tmp11.xml  "$URL1" > tmp1.txt 
done

echo
echo
echo
rm -rf tmp1.txt tmp11.xml
