#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/reportmenu

echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > tmp1.txt
echo
nav_id=`cat tmp1.txt | egrep -i "<link|<name>" | paste - - | grep -i "<name>Navigator Menu</name>" | awk -F'"' '{print $(NF-1)}' | awk -F"/" '{print $NF}'`
echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"/"$nav_id" > tmp2.txt
echo
echo
echo "TO CREATE OTHER NAVIGATOR_MENU REPORTMENU"
echo "========================================="
echo '<reportMenu version="1"> ' > tmp2.xml
echo
echo -n "PUT NAME : "
read -e namebg
echo
echo -n "PUT DESCRIPTION : "
read -e descbg

echo
echo "   <name>$namebg</name> " >> tmp2.xml
echo "   <description>$descbg</description> " >> tmp2.xml

# cat tmp2.txt | awk '{if (NR>5) {print}}' >> tmp2.xml
cat tmp2.txt | awk '{if (NR>5) {print}}' | grep -v "<id>" | grep -v "<nodeTypes/>" | sed -e "s/<menu .*/<menu>/g" | sed -e "s/<menuItem .*/<menuItem>/g" >> tmp2.xml

echo "INPUT XML"
echo "========="
echo
cat tmp2.xml
echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -T tmp2.xml "$URL1" 
echo
echo
rm -rf tmp1.txt tmp2.txt
rm -rf tmp2.xml
