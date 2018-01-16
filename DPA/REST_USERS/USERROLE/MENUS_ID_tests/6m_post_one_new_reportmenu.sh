#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/reportmenu
URL2=http://"$HB_DPA":9004/dpa-api/report-templates

echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL2" > tmp1.txt
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
echo "Only available for ReportMenu TYPE = report"
typenak=report
echo
echo -n "Put Label : "
read -e labelbg

echo
echo "NOW CHOOSE REPORTTEMPLATE TO ADD TO REPORTMENU"
echo "-------------------------"
cat tmp1.txt | egrep -i "<name>|<id>" | awk -F"</" '{print $1}' | awk -F">" '{print "#"$NF"#"}' | paste - - | awk -F"#" '{print NR"\t"$2"\t"$(NF-1)}'
cat tmp1.txt | egrep -i "<name>|<id>" | awk -F"</" '{print $1}' | awk -F">" '{print "#"$NF"#"}' | paste - - | awk -F"#" '{print "#"NR"#"$2"#"$(NF-1)"#"}' > tmp2.txt
echo
echo -n "CHOOSE REPORTTEMPLATE TO ADD TO REPORTMENU [ No / ID / FullName ] : "
read -e agentnak

berapa=`cat tmp2.txt | grep -i "#$agentnak#" | awk -F# '{print $2}'`
siapanya=`cat tmp2.txt | grep -i "#$agentnak#" | awk -F# '{print $4}'`
template_id=`cat tmp2.txt | grep -i "#$agentnak#" | awk -F# '{print $3}'`

rm -rf tmp1.txt tmp2.txt

if [ $berapa -gt 0 2> /dev/null ]
then

echo
echo "No = $berapa / ID = $template_id / TempltName = $siapanya"
echo

echo '<reportMenu version="1"> ' > tmp11.xml
echo "   <name>$namadiberi</name> " >> tmp11.xml
echo "   <description>$descrptn</description> " >> tmp11.xml
echo "   <hidden>false</hidden> " >> tmp11.xml
echo "   <system>false</system> " >> tmp11.xml
echo "   <type>$typenak</type> " >> tmp11.xml
echo "   <menu> " >> tmp11.xml
echo "   <label>$labelbg</label> " >> tmp11.xml
echo "   <menuItem> " >> tmp11.xml
echo "            <objectId>$template_id</objectId> " >> tmp11.xml
echo "            <label>$siapanya</label> " >> tmp11.xml
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
echo "WRONG INPUT - REPORTTEMPLATE"
echo

fi
