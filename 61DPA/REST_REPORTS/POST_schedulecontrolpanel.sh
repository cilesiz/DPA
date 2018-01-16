#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib
source /root/rosli/61DPA/LIB/listing_id.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.txt
tmp2="$tmprundir"/tmp2.txt
tmp3="$tmprundir"/tmp3.txt
tmpxmlhelp="$tmprundir"/tmpxmlhelp.xml
tmpxmlinput="$tmprundir"/tmpxmlinput.xml

getnodechildinfo()
{
echo
curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_apollo_nod"/"$node_id"/children > "$tmp1"
xml sel -t -m nodes/node -v numField -o "#" -v id -v numField -o "#" -v displayName -v numField -o "#" -n "$tmp1" | grep "#" | sort -t "#" -k 3 | awk -F"#" '{print "#"NR$0}' > "$tmp2"
echo; echo
cat "$tmp2" | awk -F"#" '{print $2"\t"$3"\t"$4}'
echo "X       (Stop at this child node)"
testone=`cat "$tmp2" | awk -F"#" '{print $2"\t"$3"\t"$4}' | wc -l`
if [ x"$testone" == x0 ]; then
echo "This is the last node = $namanode"
echo; echo
else
echo
echo -n "Choose NODE to check [No/Node ID/Display Name] : "
read -e agentnak
cat "$tmp2" | grep -i "#$agentnak#" > "$tmp3"
nombor=`cat "$tmp3" | awk -F# '{print $2}'`
node_id=`cat "$tmp3" | awk -F# '{print $3}'`
namanode=`cat "$tmp3" | awk -F# '{print $4}'`
if [ $nombor -gt 0 2> /dev/null ]
then
echo
echo "Number = $nombor"
echo "Node ID = $node_id"
echo "Display Name = $namanode"
echo
echo -n "<child type=\"Group\">
               <id>$node_id</id>
               <name>$namanode</name> " >> "$tmpxmlinput"

echo -n "</child>" >> "$tmpxmlhelp"

else
echo
echo "WRONG INPUT = $agentnak "
testone=0
echo
# rm -rf "$tmprundir"
fi
fi
}

echo; echo -n "Type of Report Template : "
read -e typereport
curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_dpa_ctlpnl" > "$tmp1"

echo; echo
echo "SIMPLIFY RESULT :
================="

xml sel -t -m controlPanels/controlPanel \
-o "ID=" -v id \
-o " NAME=" -v name \
-n "$tmp1" | grep -i "$typereport" | grep -i [0-9,a-z] | awk '{print NR"   "$0}'
echo; echo

xml sel -t -m controlPanels/controlPanel \
-o "#" -v id \
-o "#" -v name \
-n "$tmp1" | grep -i "$typereport" | grep -i [0-9,a-z] | awk '{print "#"NR$0"#"}' > "$tmp2"

echo -n "Choose Control Panel : "
read -e reporttemplate

nombor=`cat "$tmp2" | grep -i "#$reporttemplate#" | awk -F# '{print $2}'`
report_id=`cat "$tmp2" | grep -i "#$reporttemplate#" | awk -F# '{print $3}'`
reportname=`cat "$tmp2" | grep -i "#$reporttemplate#" | awk -F# '{print $4}'`

if [ $nombor -gt 0 2> /dev/null ]
then

echo
echo "Number = $nombor"
echo "Report ID = $report_id"
echo "Report Name = $reportname"
echo

# echo -n "
# Report Description : "
# read -e reportdesc
reportdesc="$reportname $dpaserver"

echo -n "
Report filename : "
read -e reportfile

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_apollo_sch" > "$tmp1"

echo
echo
echo "Select ScheduleTime : "
xml sel -t -m schedules/schedule -v numField -o "#" -v id -v numField -o "#" -v name -v numField -o "#" -n "$tmp1" | grep "#" | sort -t "#" -k 3 | awk -F"#" '{print "#"NR$0}' > "$tmp2"
echo; echo
cat "$tmp2" | awk -F"#" '{print $2"\t"$3"\t"$4}'

echo -n "
Choose Schedule to use [No/ID/Name] : "
read -e schnak

cat "$tmp2" | grep -i "#$schnak#" > "$tmp3"
nombor=`cat "$tmp3" | awk -F# '{print $2}'`

if [ $nombor -gt 0 2> /dev/null ]; then
namasch=`cat "$tmp3" | awk -F# '{print $4}'`

### timeconstraints
curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_dpa_wndows" > "$tmp1"
echo; echo
echo "Time Constraints :
"
xml sel -t -m windows/window \
-o "ID=" -v id \
-o " NAME=" -v name \
-n "$tmp1" | grep -i [0-9,a-z] | awk '{print NR"   "$0}'
echo; echo
xml sel -t -m windows/window \
-o "#" -v id \
-o "#" -v name \
-n "$tmp1" | grep -i [0-9,a-z] | awk '{print "#"NR$0"#"}' > "$tmp2"
echo -n "Choose Time Constraint : "
read -e ttemplate
nombor=`cat "$tmp2" | grep -i "#$ttemplate#" | awk -F# '{print $2}'`
if [ $nombor -gt 0 2> /dev/null ]
then
timerpt=`cat "$tmp2" | grep -i "#$ttemplate#" | awk -F# '{print $4}'`
else
timerpt=Now
fi

echo -n "
FormatType :
1) XML
2) PDF
3) HTML
4) Image/PNG
5) CSV

Format [ 1 / 2 / 3 / 4 ] : "
read -e formatrpt

if [ x"$formatrpt" == x1 ]; then
formatrpt=XML
elif [ x"$formatrpt" == x2 ]; then
formatrpt=PDF
elif [ x"$formatrpt" == x3 ]; then
formatrpt=HTML
elif [ x"$formatrpt" == x4 ]; then
formatrpt=Image
elif [ x"$formatrpt" == x5 ]; then
formatrpt=CSV
else
formatrpt=HTML
fi

echo -n "<scheduledReport version=\"1\" >
         <description>$reportdesc</description>
      <controlPanel>
         <name>$reportname</name>
      </controlPanel>
      <window>
         <name>$timerpt</name>
      </window>
      <schedule>
         <name>$namasch</name>
      </schedule>
      <user>
         <logonName>administrator</logonName>
      </user>
      <generateIfEmpty>true</generateIfEmpty>
      <enabled>true</enabled>
      <publications>
         <publication>
            <publicationMethod>file</publicationMethod>
            <formatType>$formatrpt</formatType>
            <pageOrientation>Portrait</pageOrientation>
            <pageSize>A4</pageSize>
            <fitContent>false</fitContent>
            <fileName>$reportfile</fileName>
            <notifyByMail>false</notifyByMail>
         </publication>
      </publications>
      <nodeLinks> " > "$tmpxmlinput"


#### SECTION TWO Nodes and it child node

# echo
# curl -k -v -u "$login1":"$paswd1" \
# -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
# -X GET "$URL_apollo_nod" > "$tmp1"
#
# xml sel -t -m nodes/node -v numField -o "#" -v id -v numField -o "#" -v displayName -v numField -o "#" -n "$tmp1" | grep "#" |  grep -v ":" | sort -t "#" -k 3 | awk -F"#" '{print "#"NR$0}' > "$tmp2"
#
# echo; echo
#
# cat "$tmp2" | awk -F"#" '{print $2"\t"$3"\t"$4}'
#
# echo
# echo -n "Choose NODE to check [No/Node ID/Display Name] : "
# read -e agentnak
#
# cat "$tmp2" | grep -i "#$agentnak#" > "$tmp3"
#
# nombor=`cat "$tmp3" | awk -F# '{print $2}'`
# node_id=`cat "$tmp3" | awk -F# '{print $3}'`
# namanode=`cat "$tmp3" | awk -F# '{print $4}'`

nombor=79
node_id="00000000-0000-0000-0000-000000000001"
namanode=Root

echo -n > "$tmpxmlhelp"

echo -n "     <nodeLink type=\"Group\">
             <id>$node_id</id>
             <name>$namanode</name> " >> "$tmpxmlinput"

while [ $nombor -gt 0 -a x"$testone" != x0 2> /dev/null ]
do
echo
getnodechildinfo
done

cat "$tmpxmlhelp" >> "$tmpxmlinput"

echo -n "</nodeLink>
      </nodeLinks>
   </scheduledReport> " >> "$tmpxmlinput"

echo "
XML INPUT
---------"
xml fo "$tmpxmlinput"
echo; echo

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X POST -T "$tmpxmlinput" "$URL_dpa_schrpt" > "$tmp1"
echo
echo
xml fo "$tmp1"
echo
echo

else

echo
echo "WRONG CHOICE - $schnak"
echo

fi

else

echo
echo "WRONG CHOICE - $reporttemplate"
echo

fi

rm -rf "$tmprundir"
