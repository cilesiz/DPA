#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/reportmenu
URL2=http://"$HB_DPA":9004/apollo-api/users

echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL2" > tmp1.txt

echo
cat tmp1.txt | egrep -i "apollo-api|<logonName>" | paste - - | awk -F"/" '{print $(NF-1)"#"$(NF-2)}' | awk -F"<logonName>"  '{print $NF}' | awk -F"<"  '{print $1$2}' | awk -F'"' '{print NR"#"$1}' | awk -F"#" '{print $1"\t"$2"\t""\t""\t"$3}'
cat tmp1.txt | egrep -i "apollo-api|<logonName>" | paste - - | awk -F"/" '{print $(NF-1)"#"$(NF-2)}' | awk -F"<logonName>"  '{print $NF}' | awk -F"<"  '{print $1$2}' | awk -F'"' '{print "#"NR"#"$1"#"}' > tmp2.txt
echo
echo -n "Choose User to use to LOGIN [No/LogonName/ID] : "
read -e agentnak

cat tmp2.txt | grep -i "#$agentnak#" > tmp3.txt

nombor=`cat tmp3.txt | awk -F# '{print $2}'`
namanya=`cat tmp3.txt | awk -F# '{print $3}'`
system_id=`cat tmp3.txt | awk -F# '{print $4}'`

rm -rf tmp1.txt tmp2.txt tmp3.txt

echo
echo "No = $nombor / User = $namanya / ID = $system_id"
echo

if [ $nombor -gt 0 2> /dev/null ]
then

echo
echo -n "Password for user $namanya = "
read -e pswd2
echo
echo
echo "TO CREATE A NEW REPORTMENU"
echo "=========================="
echo
echo -n "Please put the NAME : "
read -e namebagi
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
echo "   <name>$namebagi</name> " >> tmp11.xml
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
curl -v -u "$namanya":"$pswd2" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -T tmp11.xml "$URL1"
rm -rf  tmp11.xml
echo

else

echo
echo "WRONG ReportMenu Type = $typenak - EXIT"
echo
exit

fi

else

echo
echo "WRONG User Login chosen- EXIT"
echo
exit

fi
