#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/report

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
<runReportParameters>
    <report>
        <name>Filesystem Configuration</name>
    </report>
    <nodes>
        <node>
            <id>00000000-0000-0000-0000-000000000001</id>
        </node>
    </nodes>
    <timeConstraints type="window">
        <window>
            <name>Now</name>
        </window>
    </timeConstraints>
    <formatParameters>
        <formatType>XML</formatType>
        <pageOrientation>Portrait</pageOrientation>
        <pageSize>A4</pageSize>
        <fitContent>true</fitContent>
    </formatParameters>
    <processName>GUI</processName>
    <user>
        <logonName>administrator</logonName>
    </user>
</runReportParameters>
' "$URL1" > tmp1.txt 2>&1

echo
dos2unix tmp1.txt
cat tmp1.txt 
echo
echo
reportid=`cat tmp1.txt | grep -i Location | grep -i http | awk -F"/" '{print $NF}'`
echo
# echo "reportid=$reportid"
# echo
sed -i "s/reportid=.*/reportid=$reportid/g" GET_report_result_id.sh 
rm -rf tmp1.txt 

