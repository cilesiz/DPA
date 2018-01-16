#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/userroles

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
   <userRole version="1">
      <name>No_Anything_User</name>
      <description>UserRole for a No_Anything_User</description>
      <permissions>
         <permission name="apollo.systemsettings.read">false</permission>
         <permission name="apollo.user.readwrite">false</permission>
         <permission name="apollo.user.read">false</permission>
         <permission name="apollo.systemsettings.readwrite">false</permission>
      </permissions>
   </userRole>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
tukar=`cat tmp1.txt | grep -i "<id>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}'`
sed -i "s/idtukar=.*/idtukar=$tukar/g" 4b_post_create_user_user_norw_no_rw.sh 
rm -rf tmp1.txt 
