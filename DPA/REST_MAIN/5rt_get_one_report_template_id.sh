#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/report-templates

echo

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > tmp1.txt

echo
# cat tmp1.txt | egrep -i "apollo-api|<logonName>" | paste - - | awk -F"/" '{print $(NF-1)"#"$(NF-2)}' | awk -F"<logonName>"  '{print $NF}' | awk -F"<"  '{print $1$2}' | awk -F'"' '{print NR"#"$1}' | awk -F"#" '{print $1"\t"$2"\t""\t""\t"$3}'
# cat tmp1.txt | egrep -i "apollo-api|<logonName>" | paste - - | awk -F"/" '{print $(NF-1)"#"$(NF-2)}' | awk -F"<logonName>"  '{print $NF}' | awk -F"<"  '{print $1$2}' | awk -F'"' '{print "#"NR"#"$1"#"}' > tmp2.txt

# cat tmp1.txt | grep -i "<name>" | awk -F"</name>" '{print $1}' | awk -F"<name>" '{print $2}' > tmp2.txt
# cat tmp1.txt | grep -i "<id>" | awk -F"</id>" '{print $1}' | awk -F"<id>" '{print $2}' > tmp3.txt

cat tmp1.txt | egrep -i "<name>|<id>" | awk -F"</" '{print $1}' | awk -F">" '{print "#"$NF"#"}' | paste - - | awk -F"#" '{print NR"\t"$2"\t"$(NF-1)}'
cat tmp1.txt | egrep -i "<name>|<id>" | awk -F"</" '{print $1}' | awk -F">" '{print "#"$NF"#"}' | paste - - | awk -F"#" '{print "#"NR"#"$2"#"$(NF-1)"#"}' > tmp2.txt
echo
echo -n "Choose ReportTemplate to check [No/ID/FullName] : "
read -e agentnak

berapa=`cat tmp2.txt | grep -i "#$agentnak#" | awk -F# '{print $2}'`
siapanya=`cat tmp2.txt | grep -i "#$agentnak#" | awk -F# '{print $4}'`
system_id=`cat tmp2.txt | grep -i "#$agentnak#" | awk -F# '{print $3}'`

rm -rf tmp1.txt tmp2.txt 

echo
echo "No = $berapa / ID = $system_id / TempltName = $siapanya"
echo

if [ $berapa -gt 0 2> /dev/null ]
then

echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"/"$system_id"
echo
echo

else

echo "WRONG INPUT"
echo

fi
