#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/userroles
URL2=http://"$HB_DPA":9004/apollo-api/users

echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
   <userRole version="1">
      <name>PLCRW</name>
      <description>UserRole for a Policies RW only</description>
      <permissions>
         <permission name="apollo.analysispolicy.read">true</permission>
         <permission name="apollo.analysispolicy.readwrite">true</permission>
         <permission name="apollo.analysispolicy.assign">false</permission>
         <permission name="apollo.chargebackpolicy.read">true</permission>
         <permission name="apollo.chargebackpolicy.readwrite">true</permission>
         <permission name="apollo.chargebackpolicy.assign">false</permission>
         <permission name="apollo.datacollectionpolicy.read">true</permission>
         <permission name="apollo.datacollectionpolicy.readwrite">true</permission>
         <permission name="apollo.datacollectionpolicy.assign">false</permission>
         <permission name="apollo.protectionpolicy.read">true</permission>
         <permission name="apollo.protectionpolicy.readwrite">true</permission>
         <permission name="apollo.protectionpolicy.assign">false</permission>
      </permissions>
   </userRole>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
tukar1=`cat tmp1.txt | grep -i "<id>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}'`
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
   <userRole version="1">
      <name>PLCRO</name>
      <description>UserRole for a Policies RO only</description>
      <permissions>
         <permission name="apollo.analysispolicy.read">true</permission>
         <permission name="apollo.analysispolicy.readwrite">false</permission>
         <permission name="apollo.analysispolicy.assign">false</permission>
         <permission name="apollo.chargebackpolicy.read">true</permission>
         <permission name="apollo.chargebackpolicy.readwrite">false</permission>
         <permission name="apollo.chargebackpolicy.assign">false</permission>
         <permission name="apollo.datacollectionpolicy.read">true</permission>
         <permission name="apollo.datacollectionpolicy.readwrite">false</permission>
         <permission name="apollo.datacollectionpolicy.assign">false</permission>
         <permission name="apollo.protectionpolicy.read">true</permission>
         <permission name="apollo.protectionpolicy.readwrite">false</permission>
         <permission name="apollo.protectionpolicy.assign">false</permission>
      </permissions>
   </userRole>
' "$URL1" > tmp2.txt

echo
cat tmp2.txt
echo
tukar2=`cat tmp2.txt | grep -i "<id>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}'`

echo
echo '<user version="1" system="false" hidden="false"> ' > tmp11.xml
echo "  <displayName>plc_rw</displayName> " >> tmp11.xml
echo "  <logonName>plc_rw</logonName> " >> tmp11.xml
echo "  <externalName>plc_rw</externalName> " >> tmp11.xml
echo "  <password>plc_rw</password> " >> tmp11.xml
echo "  <authenticationType>PASSWORD</authenticationType> " >> tmp11.xml
echo '  <userRole version="1"> ' >> tmp11.xml
echo "   <id>$tukar1</id> " >> tmp11.xml
echo "  </userRole> "  >> tmp11.xml
echo " </user> " >> tmp11.xml

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -T tmp11.xml "$URL2" > tmp3.txt

echo
cat tmp3.txt 
echo

echo
echo '<user version="1" system="false" hidden="false"> ' > tmp22.xml
echo "  <displayName>plc_ro</displayName> " >> tmp22.xml
echo "  <logonName>plc_ro</logonName> " >> tmp22.xml
echo "  <externalName>plc_ro</externalName> " >> tmp22.xml
echo "  <password>plc_ro</password> " >> tmp22.xml
echo "  <authenticationType>PASSWORD</authenticationType> " >> tmp22.xml
echo '  <userRole version="1"> ' >> tmp22.xml
echo "   <id>$tukar2</id> " >> tmp22.xml
echo "  </userRole> "  >> tmp22.xml
echo " </user> " >> tmp22.xml

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -T tmp22.xml "$URL2" > tmp4.txt

echo
cat tmp4.txt
echo
echo

rm -rf tmp1.txt
rm -rf tmp2.txt
rm -rf tmp11.xml tmp3.txt
rm -rf tmp22.xml tmp4.txt
