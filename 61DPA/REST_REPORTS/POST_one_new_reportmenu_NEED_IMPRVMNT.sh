#!/bin/bash

#### originally from /root/rosli/DPA/REST_USERS/USERROLE/MENUS_ID_tests/6m_post_one_new_reportmenu.sh
###
# URL_dpa_rptmnu="$HB_DPA"/dpa-api/reportmenu
# URL_dpa_rpttpt="$HB_DPA"/dpa-api/report-templates

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib
source /root/rosli/61DPA/LIB/listing_id.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.txt
tmp2="$tmprundir"/tmp2.txt
tmp3="$tmprundir"/tmp3.txt

echo
curl -k -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_dpa_rpttpt" > "$tmp1"
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
cat "$tmp1" | egrep -i "<name>|<id>" | awk -F"</" '{print $1}' | awk -F">" '{print "#"$NF"#"}' | paste - - | awk -F"#" '{print NR"\t"$2"\t"$(NF-1)}'
cat "$tmp1" | egrep -i "<name>|<id>" | awk -F"</" '{print $1}' | awk -F">" '{print "#"$NF"#"}' | paste - - | awk -F"#" '{print "#"NR"#"$2"#"$(NF-1)"#"}' > "$tmp2"
echo
echo -n "CHOOSE REPORTTEMPLATE TO ADD TO REPORTMENU [ No / ID / FullName ] : "
read -e agentnak

berapa=`cat "$tmp2" | grep -i "#$agentnak#" | awk -F# '{print $2}'`
siapanya=`cat "$tmp2" | grep -i "#$agentnak#" | awk -F# '{print $4}'`
template_id=`cat "$tmp2" | grep -i "#$agentnak#" | awk -F# '{print $3}'`

rm -rf "$tmp1" "$tmp2" 

if [ $berapa -gt 0 2> /dev/null ]
then

echo
echo "No = $berapa / ID = $template_id / TempltName = $siapanya"
echo

echo '<reportMenu version="1"> ' > "$tmp3"
echo "   <name>$namadiberi</name> " >> "$tmp3" 
echo "   <description>$descrptn</description> " >> "$tmp3" 
echo "   <hidden>false</hidden> " >> "$tmp3" 
echo "   <system>false</system> " >> "$tmp3"
echo "   <type>$typenak</type> " >> "$tmp3" 
echo "   <menu> " >> "$tmp3" 
echo "   <label>$labelbg</label> " >> "$tmp3"
echo "   <menuItem> " >> "$tmp3"
echo "            <objectId>$template_id</objectId> " >> "$tmp3"
echo "            <label>$siapanya</label> " >> "$tmp3"
echo "            <startTime>0</startTime> " >> "$tmp3"
echo "            <endTime>0</endTime> " >> "$tmp3" 
echo "            <interval>0</interval> " >> "$tmp3" 
echo "      </menuItem> " >> "$tmp3" 
echo "   </menu> " >> "$tmp3" 
echo "</reportMenu> " >> "$tmp3"

echo
echo "INPUT XML"
echo "========="
echo
xml fo "$tmp3"
echo
curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X POST -T "$tmp3" "$URL_dpa_rptmnu"
echo
rm -rf "$tmp3"

else

echo
echo "WRONG INPUT - REPORTTEMPLATE"
echo

fi

rm -rf "$tmprundir"
