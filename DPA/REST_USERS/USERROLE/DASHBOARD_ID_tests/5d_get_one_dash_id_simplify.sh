#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/dashboards
URL2=http://"$HB_DPA":9004/dpa-api/viewlettemplates
URL3=http://"$HB_DPA":9004/apollo-api/userroles

echo

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > tmp1.txt
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL2" > tmp1v.txt
cat tmp1v.txt | egrep -i "<name>|<id>" | awk -v w1=">" -v w2="</" 'match ($0, w1 ".*" w2){print "#"substr($0,RSTART+length(w1),RLENGTH-length(w1 w2))"#"}' | paste - - | awk '{print "#"NR$0}' > tmp1v2.txt
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL3" > tmp1r.txt
cat tmp1r.txt | egrep -i "<name>|<id>" | awk -v w1=">" -v w2="</" 'match ($0, w1 ".*" w2){print "#"substr($0,RSTART+length(w1),RLENGTH-length(w1 w2))"#"}' | paste - - | awk '{print "#"NR$0}' > tmp1r2.txt
echo

echo
cat tmp1.txt | grep -i "dpa-api/dashboards" | awk -F"/" '{print $(NF-1)}' | awk -F'"' '{print "#"$1"#"}' > tmp2a.txt
cat tmp1.txt | awk "/<link /,/<\/name>/" | grep -i "<name>" | awk -F">" '{print $2}' | awk -F"<" '{print "#"$1"#"}' > tmp2b.txt
echo
echo "LIST OF DASHBOARDS"
echo "=================="
echo
paste tmp2b.txt tmp2a.txt | awk -F"#" '{print NR"\t"$2"\t\t"$(NF-1)}'
paste tmp2b.txt tmp2a.txt | awk -F"#" '{print "#"NR"#"$2"#"$(NF-1)"#"}' > tmp2.txt

echo
echo -n "Choose Dashboard to GET [ No / Name / ID ] : "
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
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"/"$dashboard_id" > tmp1.xml

echo
echo "CONFIGURATION FOR DASHBOARD = $siapanya"
echo "============================================="
echo
echo "VIEWLETS"
i_v=1
for v_id in `cat tmp1.xml | awk "/<viewletTemplate>/,/<\/id>/" | grep -i id | awk -F"</" '{print $1}' | awk -F">" '{print $NF}'`
do
echo -n "$i_v    "
cat tmp1v2.txt | grep -i "$v_id" | awk -F"#" '{print $3"\t"$(NF-1)}'
i_v=$(( i_v + 1 ))
done
echo
echo "READ ONLY (RO) USERROLE"
i_v=1
for u_id in `cat tmp1.xml | awk "/<read>/,/<\/userRoles>/" | grep -i id | awk -F"</" '{print $1}' | awk -F">" '{print $NF}'`
do
echo -n "$i_v    "
cat tmp1r2.txt | grep -i "$u_id" | awk -F"#" '{print $3"\t"$(NF-1)}'
i_v=$(( i_v + 1 ))
done
echo
echo "READWRITE (RW) USERROLE"
i_v=1
for u_id in `cat tmp1.xml | awk "/<readWrite>/,/<\/userRoles>/" | grep -i id | awk -F"</" '{print $1}' | awk -F">" '{print $NF}'`
do
echo -n "$i_v    "
cat tmp1r2.txt | grep -i "$u_id" | awk -F"#" '{print $3"\t"$(NF-1)}'
i_v=$(( i_v + 1 ))
done
echo

echo

rm -rf tmp12.xml tmp1r2.txt tmp1r.txt tmp1v2.txt tmp1v.txt tmp1.xml

################ PENUTUP - KALO TAK BETUL PILIH DASHBOARD

else

echo "WRONG INPUT - Dashboard "
rm -rf tmp12.xml tmp1r2.txt tmp1r.txt tmp1v2.txt tmp1v.txt tmp1.xml
echo
exit

fi
