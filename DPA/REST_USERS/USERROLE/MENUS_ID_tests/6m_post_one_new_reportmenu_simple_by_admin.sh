#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/reportmenu
# id_r=`date +%s`

echo

echo
echo "TO CREATE A NEW REPORTMENU"
echo "=========================="
echo
echo -n "Please put the NAME : "
read -e namadiberi
echo
echo -n "Please put the DESCRIPTION : "
read -e descrptn
echo
echo -n "Choose ReportMenu TYPE - object / report / favourite : "
read -e typenak
echo
echo -n "Put Label : "
read -e labelbg

if [ $typenak == object -o $typenak == report -o $typenak == favourite ]
then

echo '<reportMenu version="1"> ' > tmp11.xml
echo "   <name>$namadiberi</name> " >> tmp11.xml
echo "   <description>$descrptn</description> " >> tmp11.xml
echo "   <hidden>false</hidden> " >> tmp11.xml
echo "   <system>false</system> " >> tmp11.xml
echo "   <type>$typenak</type> " >> tmp11.xml
echo "   <menu> " >> tmp11.xml
echo "   <menuItem> " >> tmp11.xml
echo "            <label>$labelbg</label> " >> tmp11.xml
echo "            <startTime>0</startTime> " >> tmp11.xml
echo "            <endTime>0</endTime> " >> tmp11.xml
echo "            <interval>0</interval> " >> tmp11.xml
echo "      </menuItem> " >> tmp11.xml
echo "   </menu> " >> tmp11.xml
echo "</reportMenu> " >> tmp11.xml

echo
echo "INPUT XML"
echo "========="
echo
echo
cat tmp11.xml
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -T tmp11.xml "$URL1"
echo
rm -rf tmp11.xml

else

echo
echo "WRONG ReportMenu Type = $typenak - EXIT"
echo
exit

fi
