#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib
source /root/rosli/61DPA/LIB/listing_id.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.xml
tmp2="$tmprundir"/tmp2.txt
tmp3="$tmprundir"/tmp3.txt

echo

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_apollo_nod" > "$tmp1"

xml sel -t -m nodes/node -v numField -o "#" -v id -v numField -o "#" -v displayName -v numField -o "#" -n "$tmp1" | grep "#" | sort -t "#" -k 3 | grep -v ":" | awk -F"#" '{print "#"NR$0}' > "$tmp2"

echo; echo

cat "$tmp2" | awk -F"#" '{print $2"\t"$3"\t"$4}'

echo
echo -n "Choose NODE to RUN REPORT [No/Node ID/Display Name] : "
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
isminode=`echo "$namanode" | sed -e "s/ /_/g" | sed -e "s/\./_/g"`
echo "
ISMINODE = $isminode
"

######################

echo; echo -n "Type of Report Template : "
read -e typereport
curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_dpa_rpttpt" > "$tmp1"

echo; echo
echo "SIMPLIFY RESULT :
================="
xml sel -t -m reports/report \
-o "ID=" -v id \
-o " NAME=" -v name \
-n "$tmp1" | grep -i "$typereport" | grep -i [0-9,a-z] | awk '{print NR"   "$0}'
echo; echo

xml sel -t -m reports/report \
-o "#" -v id \
-o "#" -v name \
-n "$tmp1" | grep -i "$typereport" | grep -i [0-9,a-z] | awk '{print "#"NR$0"#"}' > "$tmp2"

echo -n "Choose Report Template : "
read -e reporttemplate

nombor=`cat "$tmp2" | grep -i "#$reporttemplate#" | awk -F# '{print $2}'`

if [ $nombor -gt 0 2> /dev/null ]
then
report_id=`cat "$tmp2" | grep -i "#$reporttemplate#" | awk -F# '{print $3}'`
reportname=`cat "$tmp2" | grep -i "#$reporttemplate#" | awk -F# '{print $4}'`
echo
echo "Number = $nombor"
echo "Report ID = $report_id"
echo "Report Name = $reportname"
echo

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

if [ x"$formatrpt" == x1 -o x"$formatrpt" == xxml -o x"$formatrpt" == xXML ]; then
formatrpt=XML
filename=xml
elif [ x"$formatrpt" == x2 -o x"$formatrpt" == xpdf -o x"$formatrpt" == xPDF ]; then
formatrpt=PDF
filename=pdf
elif [ x"$formatrpt" == x3 -o x"$formatrpt" == xhtml -o x"$formatrpt" == xHTML ]; then
formatrpt=HTML
filename=html
elif [ x"$formatrpt" == x4 -o x"$formatrpt" == xImage -o x"$formatrpt" == xPNG ]; then
formatrpt=Image
filename=png
elif [ x"$formatrpt" == x5 -o x"$formatrpt" == xcsv -o x"$formatrpt" == xCSV ]; then
formatrpt=CSV
filename=csv
else
formatrpt=HTML
filename=html
fi

else

echo
echo "WRONG INPUT = $reporttemplate"
echo
rm -rf "$tmprundir"
exit

fi

##################################

echo
echo -n "<runReportParameters>
    <report>
        <name>$reportname</name>
    </report>
    <nodes>
        <node>
            <id>$node_id</id>
        </node>
    </nodes>
    <timeConstraints type=\"window\">
        <window>
            <name>$timerpt</name>
        </window>
    </timeConstraints>
    <formatParameters>
        <formatType>$formatrpt</formatType>
        <pageOrientation>Portrait</pageOrientation>
        <pageSize>A4</pageSize>
        <fitContent>true</fitContent>
    </formatParameters>
    <processName>GUI</processName>
    <user>
        <logonName>administrator</logonName>
    </user>
</runReportParameters>" > "$tmp1"

echo "
XML INPUT 
=========
"
xml fo "$tmp1"
echo; echo

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X POST -T "$tmp1" "$URL_dpa_report" > "$tmp2" 2>&1

echo
dos2unix "$tmp2"
# cat "$tmp2"
echo
echo
reportid=`cat "$tmp2" | grep -i Location | grep -i http | grep -i dpa-api | grep -i report | grep -i result | awk -F"/" '{print $NF}'`
echo "
REPORTID = $reportid
URL = $URL_dpa_rptrst/$reportid
"
echo

sleep 60

# curl -k -v -u "$login1":"$paswd1" \
# -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
# -X GET "$URL_dpa_rptrst"/"$reportid" > "$isminode".xml

masa=`date +%Y%m%d_%H%M%S`

curl -k -v -u "$login1":"$paswd1" \
-X GET "$URL_dpa_rptrst"/"$reportid" > /root/"$isminode"_"$masa"."$filename"

# dos2unix "$tmp3"
# cat "$tmp3"
# isminode=`echo "$namenode" | awk '{print $1}'`
# cp "$tmp3" "$node_id"_"$isminode".xml

echo; echo "REPORT_FILENAME =" "$isminode"_"$masa"."$filename"
echo; echo

rm -rf "$tmprundir" 

else

echo
echo "WRONG INPUT = $agentnak "
echo
rm -rf "$tmprundir"

fi
