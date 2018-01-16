#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/userroles
URL2=http://"$HB_DPA":9004/apollo-api/users

echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
   <userRole version="1">
      <name>SystemSettingsTest1</name>
      <description>UserRole for a SystemSettingsTest1</description>
      <permissions>
         <permission name="apollo.systemsettings.read">true</permission>
         <permission name="apollo.user.readwrite">true</permission>
         <permission name="import.readwrite">false</permission>
         <permission name="apollo.user.read">true</permission>
         <permission name="apollo.systemsettings.readwrite">true</permission>
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
      <name>SystemSettingsTest2</name>
      <description>UserRole for a SystemSettingsTest2</description>
      <permissions>
         <permission name="apollo.systemsettings.read">true</permission>
         <permission name="apollo.user.readwrite">true</permission>
         <permission name="import.readwrite">false</permission>
         <permission name="apollo.user.read">true</permission>
         <permission name="apollo.systemsettings.readwrite">false</permission>
      </permissions>
   </userRole>
' "$URL1" > tmp2.txt

echo
cat tmp2.txt
echo
tukar2=`cat tmp2.txt | grep -i "<id>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}'`

echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
   <userRole version="1">
      <name>SystemSettingsTest7</name>
      <description>UserRole for a SystemSettingsTest7</description>
      <permissions>
         <permission name="apollo.systemsettings.read">false</permission>
         <permission name="apollo.user.readwrite">false</permission>
         <permission name="import.readwrite">false</permission>
         <permission name="apollo.user.read">false</permission>
         <permission name="apollo.systemsettings.readwrite">false</permission>
      </permissions>
   </userRole>
' "$URL1" > tmp3.txt

echo
cat tmp3.txt
echo
tukar3=`cat tmp3.txt | grep -i "<id>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}'`

echo
echo '<user version="1" system="false" hidden="false"> ' > tmp11.xml
echo "  <displayName>sst1</displayName> " >> tmp11.xml
echo "  <logonName>sst1</logonName> " >> tmp11.xml
echo "  <externalName>sst1</externalName> " >> tmp11.xml
echo "  <password>sst1</password> " >> tmp11.xml
echo "  <authenticationType>PASSWORD</authenticationType> " >> tmp11.xml
echo '  <userRole version="1"> ' >> tmp11.xml
echo "   <id>$tukar1</id> " >> tmp11.xml
echo "  </userRole> "  >> tmp11.xml
echo " </user> " >> tmp11.xml

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -T tmp11.xml "$URL2" > tmp111.txt

echo
cat tmp111.txt 
echo

echo
echo '<user version="1" system="false" hidden="false"> ' > tmp22.xml
echo "  <displayName>sst2</displayName> " >> tmp22.xml
echo "  <logonName>sst2</logonName> " >> tmp22.xml
echo "  <externalName>sst2</externalName> " >> tmp22.xml
echo "  <password>sst2</password> " >> tmp22.xml
echo "  <authenticationType>PASSWORD</authenticationType> " >> tmp22.xml
echo '  <userRole version="1"> ' >> tmp22.xml
echo "   <id>$tukar2</id> " >> tmp22.xml
echo "  </userRole> "  >> tmp22.xml
echo " </user> " >> tmp22.xml

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -T tmp22.xml "$URL2" > tmp222.txt

echo
cat tmp222.txt
echo

echo
echo '<user version="1" system="false" hidden="false"> ' > tmp33.xml
echo "  <displayName>sst4</displayName> " >> tmp33.xml
echo "  <logonName>sst4</logonName> " >> tmp33.xml
echo "  <externalName>sst4</externalName> " >> tmp33.xml
echo "  <password>sst4</password> " >> tmp33.xml
echo "  <authenticationType>PASSWORD</authenticationType> " >> tmp33.xml
echo '  <userRole version="1"> ' >> tmp33.xml
echo "   <id>$tukar3</id> " >> tmp33.xml
echo "  </userRole> "  >> tmp33.xml
echo " </user> " >> tmp33.xml

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -T tmp33.xml "$URL2" > tmp333.txt

echo
cat tmp333.txt
echo

echo

rm -rf tmp1.txt
rm -rf tmp2.txt
rm -rf tmp3.txt
rm -rf tmp11.xml tmp111.txt
rm -rf tmp22.xml tmp222.txt
rm -rf tmp33.xml tmp333.txt
