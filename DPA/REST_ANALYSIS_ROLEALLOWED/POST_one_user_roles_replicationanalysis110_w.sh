#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/userroles

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
   <userRole version="1">
      <name>ReplicationAnalysis110</name>
      <description>UserRole for a Replication Analysis 110</description>
      <permissions>
      <permission name="apollo.replicationanalysis.readwrite">true</permission>
      <permission name="apollo.replicationanalysis.read">true</permission>
      <permission name="apollo.inventory.read">true</permission>
      </permissions>
   </userRole>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
tukar=`cat tmp1.txt | grep -i "<id>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}'`
sed -i "s/idtukar=.*/idtukar=$tukar/g" POST_create_user_ra_rw.sh 
rm -rf tmp1.txt 
# POST_create_user_ss_ro.sh
# POST_create_user_ss_rw.sh
