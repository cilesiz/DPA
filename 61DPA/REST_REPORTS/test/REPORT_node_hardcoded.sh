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

# cp "$tmp2" roslitmp2.txt

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
echo -n "
Report Name :
1) Filesystem Configuration (for server - disks information)
2) Network Interface Performance By Interface (for network switch)
3) Report History (usually for DPA server)
4) Backup All Jobs (usually for Backup servers - Avamar / Networker etc)

Format [ 1 / 2 / 3 / 4 ] : "
read -e namerpt

if [ x"$namerpt" == x1 ]; then
namerpt="Filesystem Configuration"
elif [ x"$namerpt" == x2 ]; then
namerpt="Network Interface Performance By Interface"
elif [ x"$namerpt" == x3 ]; then
namerpt="Report History"
elif [ x"$namerpt" == x4 ]; then
namerpt="Backup All Jobs"
else
namerpt="Filesystem Configuration"
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
filename=xml
elif [ x"$formatrpt" == x2 ]; then
formatrpt=PDF
filename=pdf
elif [ x"$formatrpt" == x3 ]; then
formatrpt=HTML
filename=html
elif [ x"$formatrpt" == x4 ]; then
formatrpt=Image
filename=png
elif [ x"$formatrpt" == x5 ]; then
formatrpt=CSV
filename=csv
else
formatrpt=HTML
filename=html
fi

echo -n "
TimeConstraints :
1) Now
2) Last Hour
3) Last Day
4) Last Week
5) Last month

Format [ 1 / 2 / 3 / 4 ] : "
read -e timerpt

if [ x"$timerpt" == x1 ]; then
timerpt=Now
elif [ x"$timerpt" == x2 ]; then
timerpt="Last Hour"
elif [ x"$timerpt" == x3 ]; then
timerpt="Last Day"
elif [ x"$timerpt" == x4 ]; then
timerpt="Last Week"
elif [ x"$timerpt" == x4 ]; then
timerpt="Last Month"
else
timertp=Now
fi

echo
echo -n "<runReportParameters>
    <report>
        <name>$namerpt</name>
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
