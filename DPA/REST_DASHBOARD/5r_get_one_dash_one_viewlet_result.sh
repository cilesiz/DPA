#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/dashboards

echo

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > tmp1.txt

echo
cat tmp1.txt | grep -i "dpa-api/dashboards" | awk -F"/" '{print $(NF-1)}' | awk -F'"' '{print "#"$1"#"}' > tmp2a.txt
cat tmp1.txt | grep -i "<description>" | awk -F">" '{print $2}' | awk -F"<" '{print "#"$1"#"}' > tmp2b.txt
paste tmp2b.txt tmp2a.txt | awk -F"#" '{print NR"\t"$2"\t"$(NF-1)}'
paste tmp2b.txt tmp2a.txt | awk -F"#" '{print "#"NR"#"$2"#"$(NF-1)"#"}' > tmp2.txt
echo
echo -n "Choose Dashboard to check [ No / Fullname / ID ] : "
read -e agentnak

berapa=`cat tmp2.txt | grep "#$agentnak#" | awk -F"#" '{print $2}'`
siapanya=`cat tmp2.txt | grep "#$agentnak#" | awk -F"#" '{print $3}'`
dashboard_id=`cat tmp2.txt | grep "#$agentnak#" | awk -F"#" '{print $4}'`

rm -rf tmp1.txt tmp2a.txt tmp2b.txt tmp2.txt

echo
echo "Number = $berapa"
echo "LogonName = $siapanya"
echo "ID = $dashboard_id"
echo

if [ $berapa -gt 0 2> /dev/null ]
then

echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"/"$dashboard_id" > /tmp/tmp4.txt

echo
echo "Choose Dashboard $siapanya 's Viewlet to check : "
echo
echo
cat /tmp/tmp4.txt | awk "/<viewlet version/,/<\/id>/" | grep -i "<id>" | awk -F"</id>" '{print $1}' | awk -F"<id>" '{print NR"\t"$NF}'
cat /tmp/tmp4.txt | awk "/<viewlet version/,/<\/id>/" | grep -i "<id>" | awk -F"</id>" '{print $1}' | awk -F"<id>" '{print "#"NR"#"$NF"#"}' > /tmp/tmp5.txt
echo
echo -n "Viewlet choosen : "
read -e vltnak

berapa=`cat /tmp/tmp5.txt | grep -i "#$vltnak#" | awk -F"#" '{print $2}'`
vid=`cat /tmp/tmp5.txt | grep -i "#$vltnak#" | awk -F"#" '{print $3}'`

if [ $berapa -gt 0 2> /dev/null ]
then

echo
echo "Nombor = $berapa"
echo "Viewlet_ID = $vid"
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"/"$dashboard_id"/viewlets/"$vid"/result
echo
echo

else

echo
echo "WRONG INPUT - VIEWLET CHOOSEN"
echo

fi

rm -rf /tmp/tmp4.txt /tmp/tmp5.txt 

echo
echo

else

echo
echo "WRONG INPUT - DASHBOARD CHOOSEN"
echo

fi
