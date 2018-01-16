#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/userroles

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
   <userRole version="1">
      <name>DataCollectionPolicy101</name>
      <description>UserRole for a Data Collection Policy 101</description>
      <permissions>
      <permission name="apollo.user.readwrite">false</permission>
      <permission name="apollo.user.read">false</permission>
      <permission name="apollo.datacollectionpolicy.read">true</permission>
      <permission name="apollo.datacollectionpolicy.readwrite">false</permission>
      <permission name="apollo.datacollectionpolicy.assign">true</permission>
      <permission name="apollo.inventory.read">true</permission>
      </permissions>
   </userRole>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
tukar=`cat tmp1.txt | grep -i "<id>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}'`
sed -i "s/idtukar=.*/idtukar=$tukar/g" POST_create_user_dcp_now_no_rw.sh  
rm -rf tmp1.txt 
# -rwxr-xr-x 1 root root 1076 Mar  6 12:56 POST_create_user_dcp_noa_no_as.sh
# -rwxr-xr-x 1 root root 1076 Mar  6 12:09 POST_create_user_dcp_nor_no_ro.sh
# -rwxr-xr-x 1 root root 1076 Mar  6 12:56 POST_create_user_dcp_now_no_rw.sh
# <system>false</system>
#      <permission name="apollo.inventory.read">true</permission>
