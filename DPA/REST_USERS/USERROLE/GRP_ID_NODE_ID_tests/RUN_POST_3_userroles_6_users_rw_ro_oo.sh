#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/userroles
URL2=http://"$HB_DPA":9004/apollo-api/users

echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > tmp1.txt

tukar1=`cat tmp1.txt | egrep "<id>|<name>" | paste - - | grep -i "<name>Administrator</name>" | awk -F"</id>" '{print $1}' | awk -F"<id>" '{print $NF}'`
tukar2=`cat tmp1.txt | egrep "<id>|<name>" | paste - - | grep -i "<name>Application Owner</name>" | awk -F"</id>" '{print $1}' | awk -F"<id>" '{print $NF}'`
tukar3=`cat tmp1.txt | egrep "<id>|<name>" | paste - - | grep -i "<name>User</name>" | awk -F"</id>" '{print $1}' | awk -F"<id>" '{print $NF}'`

echo
cat tmp1.txt
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
   <userRole version="1">
      <name>nothing_userrole</name>
      <description>UserRole for a nothing_userrole</description>
      <permissions>
      <permission name="apollo.scheduledreports.read">false</permission>
      <permission name="apollo.systemsettings.read">false</permission>
      <permission name="apollo.alerts.read">false</permission>
      <permission name="apollo.user.readwrite">false</permission>
      <permission name="apollo.protectionpolicy.read">false</permission>
      <permission name="apollo.datacollectionpolicy.read">false</permission>
      <permission name="apollo.dashboard.readwrite">false</permission>
      <permission name="import.readwrite">false</permission>
      <permission name="apollo.global.readwrite">true</permission>
      <permission name="apollo.reporttemplate.read">false</permission>
      <permission name="apollo.user.read">false</permission>
      <permission name="apollo.register.agent">false</permission>
      <permission name="apollo.analysispolicy.read">false</permission>
      <permission name="apollo.alerts.readwrite">false</permission>
      <permission name="apollo.dashboard.read">false</permission>
      <permission name="apollo.chargebackpolicy.read">false</permission>
      <permission name="apollo.chargebackpolicy.assign">false</permission>
      <permission name="apollo.reporttemplate.readwrite">false</permission>
      <permission name="apollo.datacollectionpolicy.assign">false</permission>
      <permission name="apollo.inventory.readwrite">false</permission>
      <permission name="apollo.protectionpolicy.assign">false</permission>
      <permission name="apollo.inventory.read">false</permission>
      <permission name="apollo.datacollectionpolicy.readwrite">false</permission>
      <permission name="apollo.analysispolicy.assign">false</permission>
      <permission name="apollo.chargebackpolicy.readwrite">false</permission>
      <permission name="apollo.systemsettings.readwrite">false</permission>
      <permission name="apollo.replicationanalysis.read">false</permission>
      <permission name="apollo.permissions.list">false</permission>
      <permission name="apollo.scheduledreports.readwrite">false</permission>
      <permission name="apollo.activereports.readwrite">false</permission>
      <permission name="apollo.analysispolicy.readwrite">false</permission>
      <permission name="apollo.replicationanalysis.readwrite">false</permission>
      <permission name="apollo.protectionpolicy.readwrite">false</permission>
      <permission name="apollo.activereports.read">false</permission>
      </permissions>
   </userRole>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
tukar4=`cat tmp1.txt | grep -i "<id>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}'`

echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
   <userRole version="1">
      <name>inventory_rw</name>
      <description>UserRole for a inventory_rw</description>
      <permissions>
         <permission name="apollo.inventory.read">true</permission>
         <permission name="apollo.inventory.readwrite">true</permission>
      </permissions>
   </userRole>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt
echo
tukar5=`cat tmp1.txt | grep -i "<id>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}'`

echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
   <userRole version="1">
      <name>inventory_ro</name>
      <description>UserRole for a inventory_ro</description>
      <permissions>
         <permission name="apollo.inventory.read">true</permission>
         <permission name="apollo.inventory.readwrite">false</permission>
      </permissions>
   </userRole>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt
echo
tukar6=`cat tmp1.txt | grep -i "<id>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}'`

rm -rf tmp1.txt

for i in `seq 1 1 6`
do

tukarje=tukar$i
tukar_id=${!tukarje}

echo
echo '<user version="1" system="false" hidden="false"> ' > tmp11.xml
echo "  <displayName>usr$i</displayName> " >> tmp11.xml
echo "  <logonName>usr$i</logonName> " >> tmp11.xml
echo "  <externalName>usr$i</externalName> " >> tmp11.xml
echo "  <password>usr$i</password> " >> tmp11.xml
echo "  <authenticationType>PASSWORD</authenticationType> " >> tmp11.xml
echo '  <userRole version="1"> ' >> tmp11.xml
echo "   <id>$tukar_id</id> " >> tmp11.xml
echo "  </userRole> "  >> tmp11.xml
echo " </user> " >> tmp11.xml

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -T tmp11.xml "$URL2" > tmp111.txt

echo
cat tmp111.txt 
rm -rf tmp11.xml tmp111.txt
echo

done

echo
