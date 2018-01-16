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
echo -n "Choose Dashboard to EDIT [ No / Name / ID ] : "
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
cat tmp1.xml | awk "/<dashboard/,/<\/viewlets>/" | grep -v "</viewlets>" > tmp12.xml

echo
echo "EXISTING CONFIGURATION FOR DASHBOARD = $siapanya"
echo "=================================================="
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
echo
echo "LIST OF AVAILABLE VIEWLETS"
echo "=========================="
echo

cat -n tmp1v2.txt | awk -F"#" '{print NR"\t"$3"\t"$(NF-1)}'
echo
echo -n "Add another Viewlet ? [ Y / N ] : "
read -e nakaddviewlet

while [ $nakaddviewlet == Y -o $nakaddviewlet == y ]
do

echo
echo -n "Choose Viewlet Templates to add to Dashboard [ No / ID / Fullname ] : "
read -e viewltnak

berapa=`cat tmp1v2.txt | grep "#$viewltnak#" | awk -F"#" '{print $2}'`
siapanya=`cat tmp1v2.txt | grep "#$viewltnak#" | awk -F"#" '{print $(NF-1)}'`
viewlet_id=`cat tmp1v2.txt | grep "#$viewltnak#" | awk -F"#" '{print $3}'`

echo
echo "CHOOSEN : No = $berapa / Name = $siapanya / ID = $viewlet_id"
echo

if [ $berapa -gt 0 2> /dev/null ]
then

echo '       <viewlet version="1"> ' >> tmp12.xml
echo '         <layout row="0" column="0" width="200" height="200"/> ' >> tmp12.xml
echo "         <viewletTemplate> " >> tmp12.xml
echo "            <id>$viewlet_id</id> " >> tmp12.xml
echo "         </viewletTemplate> " >> tmp12.xml
echo "         <nodeLinks/> " >> tmp12.xml
echo "         <parameters/> " >> tmp12.xml
echo "       </viewlet> " >> tmp12.xml

else

echo
echo "WRONG INPUT - Additional Viewlet"
echo

fi

echo -n "Add another Viewlet ? [ Y / N ] : "
read -e nakaddviewlet

done

echo "    </viewlets>" >> tmp12.xml

################ READ ONLY USERROLES SECTION

echo "  <authorization> " >> tmp12.xml
echo "  <read> " >> tmp12.xml
cat tmp1.xml | awk "/<read>/,/<\/read>/" | awk "/<users>/,/<\/users>/" | grep -v "<read>" | grep -v "</read>" | grep -v "<users/>" >> tmp12.xml
echo "      <userRoles>" >> tmp12.xml
cat tmp1.xml | awk "/<read>/,/<\/read>/" | awk "/<userRoles/,/<\/userRoles>/" | grep -v "<read>" | grep -v "</read>" | grep -v "<userRoles>" | grep -v "<userRoles/>" | grep -vi "</userRoles>" >> tmp12.xml

echo
echo "LIST OF AVAILABLE USERROLES"
echo "==========================="
echo
cat -n tmp1r2.txt | awk -F"#" '{print NR"\t"$3"\t"$(NF-1)}'
echo
echo "READ ONLY USERROLES"
echo "---------------"
echo
echo -n "Add another Userrole for READ ONLY ? [ Y / N ] : "
read -e nakroleRO

while [ $nakroleRO == y -o $nakroleRO == Y ]
do

echo
echo -n "User role to ADD [ No / User / ID ] : "
read -e userrole1
berapa=`cat tmp1r2.txt | grep -i "#$userrole1#" | awk -F"#" '{print $2}'`
role1=`cat tmp1r2.txt | grep -i "#$userrole1#" | awk -F"#" '{print $(NF-1)}'`
role1_id=`cat tmp1r2.txt | grep -i "#$userrole1#" | awk -F"#" '{print $3}'`

if [ $berapa -gt 0 2>/dev/null ]
then

echo
echo "CHOOSEN : No = $berapa / Userrole = $role1 / Usrrole_ID = $role1_id "
echo
echo "            <userRole> "  >> tmp12.xml
echo "               <id>$role1_id</id> "  >> tmp12.xml
echo "            </userRole> "  >> tmp12.xml

else

echo
echo "WRONG INPUT - Userrole RO section"
echo

fi

echo -n "Add another Userrole for READ ONLY ? [ Y / N ] : "
read -e nakroleRO

done

echo "         </userRoles>" >> tmp12.xml
echo "   </read>" >> tmp12.xml


################# READWRITE USERROLE SECTION

echo "   <readWrite>" >> tmp12.xml
cat tmp1.xml | awk "/<readWrite>/,/<\/readWrite>/" | awk "/<users>/,/<\/users>/" | grep -v "<readWrite>" | grep -v "</readWrite>" | grep -v "<users/>" >> tmp12.xml
echo "      <userRoles>" >> tmp12.xml
cat tmp1.xml | awk "/<readWrite>/,/<\/readWrite>/" | awk "/<userRoles/,/<\/userRoles>/" | grep -v "<readWrite>" | grep -v "</readWrite>" | grep -v "<userRoles>" | grep -v "<userRoles/>" | grep -vi "</userRoles>" >> tmp12.xml

echo
echo "LIST OF AVAILABLE USERROLES"
echo "==========================="
echo
cat -n tmp1r2.txt | awk -F"#" '{print NR"\t"$3"\t"$(NF-1)}'
echo
echo "READWRITE USERROLES"
echo "---------------"
echo
echo -n "Add another Userrole for READWRITE ? [ Y / N ] : "
read -e nakroleRW

while [ $nakroleRW == y -o $nakroleRW == Y ]
do

echo
echo -n "User role to ADD [ No / User / ID ] : "
read -e userrole1
berapa=`cat tmp1r2.txt | grep -i "#$userrole1#" | awk -F"#" '{print $2}'`
role1=`cat tmp1r2.txt | grep -i "#$userrole1#" | awk -F"#" '{print $(NF-1)}'`
role1_id=`cat tmp1r2.txt | grep -i "#$userrole1#" | awk -F"#" '{print $3}'`

if [ $berapa -gt 0 2>/dev/null ]
then

echo
echo "CHOOSEN : No = $berapa / Userrole = $role1 / ID = $role1_id "
echo
echo "            <userRole> "  >> tmp12.xml
echo "               <id>$role1_id</id> "  >> tmp12.xml
echo "            </userRole> "  >> tmp12.xml

else

echo
echo "WRONG INPUT - Userrole RW section"
echo

fi

echo -n "Add another Userrole for READWRITE ? [ Y / N ] : "
read -e nakroleRW

done

echo "          </userRoles>" >> tmp12.xml
echo "      </readWrite>" >> tmp12.xml

echo "  </authorization>" >> tmp12.xml
echo "</dashboard>" >> tmp12.xml

echo
echo "INPUT XML"
echo "========="
echo
cat tmp12.xml
echo

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X PUT -T tmp12.xml "$URL1"/"$dashboard_id"

echo
echo
rm -rf tmp1r2.txt tmp1r.txt tmp1v2.txt tmp1v.txt tmp1.xml
rm -rf tmp12.xml

################ PENUTUP - KALO TAK BETUL PILIH DASHBOARD

else

echo "WRONG INPUT - Dashboard "
rm -rf tmp12.xml tmp1r2.txt tmp1r.txt tmp1v2.txt tmp1v.txt tmp1.xml
echo
exit

fi

