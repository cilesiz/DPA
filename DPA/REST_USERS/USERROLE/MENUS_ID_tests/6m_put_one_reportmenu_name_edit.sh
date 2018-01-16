#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/reportmenu
URL2=http://"$HB_DPA":9004/dpa-api/report-templates

echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > tmp1.txt
echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL2" > tmp123.txt
cat tmp123.txt | egrep -i "<name>|<id>" | awk -F"</" '{print $1}' | awk -F">" '{print "#"$NF"#"}' | paste - - | awk -F"#" '{print "#"NR"#"$2"#"$(NF-1)"#"}' > tmp1234.txt
echo

echo
echo
echo "LIST OF REPORTMENUS"
echo "==================="
echo
cat tmp1.txt | grep -i "<link" | awk -F"/" '{print $(NF-1)}' | awk -F'"' '{print "#"$(NF-1)"#"}' > tmp2a.txt
cat tmp1.txt | grep -i "<name>" | awk -F"<name>" '{print $NF}' | awk -F"</name>" '{print "#"$(NF-1)"#"}' > tmp3.txt
avail1=`cat tmp3.txt | wc -l`
cat tmp2a.txt | head -"$avail1" > tmp2.txt

paste tmp3.txt tmp2.txt | awk -F"#" '{print NR"\t"$2"\t\t"$(NF-1)}'
paste tmp3.txt tmp2.txt | awk -F"#" '{print "#"NR"#"$2"#"$(NF-1)"#"}' > tmp4.txt

echo
echo -n "CHOOSE YOUR REPORT MENUS [ No / User / ID ] : "
read -e usrrl1
berapa=`cat tmp4.txt | grep -i "#$usrrl1#" | cut -d# -f2`
menu1=`cat tmp4.txt | grep -i "#$usrrl1#" | cut -d# -f3`
menu1_id=`cat tmp4.txt | grep -i "#$usrrl1#" | cut -d# -f4`

rm -rf tmp1.txt tmp2a.txt tmp2.txt tmp3.txt tmp4.txt

if [ $berapa -gt 0 2>/dev/null ]
then

echo
echo "No = $berapa / ReportMenu = $menu1 / ID = $menu1_id"
echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"/"$menu1_id" > tmp1.txt
echo
echo "EXISTING CONFIGURATION - REPORTMENU = $menu1"
echo "------------------------------------------------"
cat tmp1.txt
echo
echo
echo "ADD ANOTHER REPORT TEMPLATE TO REPORTMENU $menu1"
echo "--------------------------------------------------"
echo
# cat tmp1.txt | grep -vi nodeTypes | grep -vi "</menu>" | grep -vi "</reportMenu>" > tmp12.xml
bil_line=`cat tmp1.txt | wc -l`
cat tmp1.txt | head -"$((bil_line - 1))" | grep -vi "<nodeTypes/>" > tmp12.xml
echo
echo -n "Add another ReportTemplate to ReportMenu $menu1 ? [ Y / N ] : "
read -e nakmenu

while [ $nakmenu == y -o $nakmenu == Y ]
do

echo
echo "LIST OF REPORTTEMPLATE"
cat tmp123.txt | egrep -i "<name>|<id>" | awk -F"</" '{print $1}' | awk -F">" '{print "#"$NF"#"}' | paste - - | awk -F"#" '{print NR"\t"$2"\t"$(NF-1)}'
echo
echo -n "Choose ReportTemplate to ADD [No/ID/FullName] : "
read -e agentnak

nombur=`cat tmp1234.txt | grep -i "#$agentnak#" | awk -F# '{print $2}'`
tmpltnya=`cat tmp1234.txt | grep -i "#$agentnak#" | awk -F# '{print $4}'`
tmplt_id=`cat tmp1234.txt | grep -i "#$agentnak#" | awk -F# '{print $3}'`

echo
# echo -n "Put Label :"
# read -e labelbg
echo
# echo "No = $nombur / ID = $tmplt_id / TempltName = $tmpltnya / Label = $labelbg"
echo "No = $nombur / ID = $tmplt_id / TempltName = $tmpltnya"
echo


if [ $nombur -gt 0 2>/dev/null ]
then

echo
# echo "CHOOSEN : No = $nombur / ID = $tmplt_id / TempltName = $tmpltnya / Label = $labelbg"
echo "CHOOSEN : No = $nombur / ID = $tmplt_id / TempltName = $tmpltnya"
echo
# echo "    <menu>" >> tmp12.xml
# echo "     <label>$labelbg</label> " >> tmp12.xml
echo "      <menuItem> " >> tmp12.xml
echo "            <objectId>$tmplt_id</objectId> " >> tmp12.xml
echo "            <label>$tmpltnya</label> " >> tmp12.xml
echo "            <startTime>0</startTime> " >> tmp12.xml
echo "            <endTime>0</endTime> " >> tmp12.xml
echo "            <interval>0</interval> " >> tmp12.xml
echo "      </menuItem> " >> tmp12.xml
# echo "    </menu>" >> tmp12.xml

else

echo
echo "WRONG INPUT - Template $agentnak IS NOT EXIST"
echo

fi

echo -n "Add another ReportTemplate to ReportMenu $menu1 ? [ Y / N ] : "
read -e nakmenu

done

echo "    </menu>" >> tmp12.xml
echo "</reportMenu>" >> tmp12.xml

echo 
echo "INPUT XML"
echo "========="
cat tmp12.xml
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X PUT -T tmp12.xml "$URL1"/"$menu1_id"
echo
rm -rf tmp1.txt tmp123.txt tmp1234.txt 
rm -rf tmp12.xml

else

echo
echo "WRONG INPUT - $usrrl1 NOT EXIST"
echo
exit

fi
