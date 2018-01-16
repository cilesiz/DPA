#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/userroles

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
   <userRole version="1">
      <name>ChargeBackPolicy110</name>
      <description>UserRole for a Charge Back Policy 110</description>
      <permissions>
      <permission name="apollo.user.readwrite">false</permission>
      <permission name="apollo.user.read">false</permission>
      <permission name="apollo.chargebackpolicy.read">true</permission>
      <permission name="apollo.chargebackpolicy.assign">false</permission>
      <permission name="apollo.chargebackpolicy.readwrite">true</permission>
      </permissions>
   </userRole>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
tukar=`cat tmp1.txt | grep -i "<id>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}'`
sed -i "s/idtukar=.*/idtukar=$tukar/g" POST_create_user_cp_noa_no_as.sh 
rm -rf tmp1.txt 
# -rwxr-xr-x 1 root root 923 Mar  8 11:40 POST_create_user_cp_noa_no_as.sh
# -rwxr-xr-x 1 root root 923 Mar  8 11:41 POST_create_user_cp_nor_no_ro.sh
#      <system>false</system>
