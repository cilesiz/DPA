#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/userroles
URL3=http://"$HB_DPA":9004/dpa-api/userroles

echo
curl -IL -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"
echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > tmp1.txt

echo
echo
echo "CHOOSE YOUR ROLE"
cat tmp1.txt | grep -i "<link" | awk -F"/" '{print $(NF-1)}' | awk -F'"' '{print "#"$(NF-1)"#"}' > tmp2.txt
cat tmp1.txt | grep -i "<name>" | awk -F"<name>" '{print $NF}' | awk -F"</name>" '{print "#"$(NF-1)"#"}' > tmp3.txt
paste tmp3.txt tmp2.txt | awk -F"#" '{print NR"\t"$2"\t\t"$(NF-1)}'
paste tmp3.txt tmp2.txt | awk -F"#" '{print "#"NR"#"$2"#"$(NF-1)"#"}' > tmp4.txt

echo
echo -n "User role choosen [ No / User / ID ] : "
read -e userrole1
berapa=`cat tmp4.txt | grep -i "#$userrole1#" | cut -d# -f2`
role1=`cat tmp4.txt | grep -i "#$userrole1#" | cut -d# -f3`
role1_id=`cat tmp4.txt | grep -i "#$userrole1#" | cut -d# -f4`

if [ $berapa -gt 0 2>/dev/null ]
then

echo
echo "Userrole = $role1"
echo "UserroleID = $role1_id"
echo

# curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"/"$role1_id"
echo

rm -rf tmp1.txt tmp2.txt tmp3.txt tmp4.txt

URL2=http://"$HB_DPA":9004/dpa-api/dashboards

echo

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL2" > tmp1.txt

echo
echo "List of Dashboards"
echo "------------------"

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

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL3"/"$role1_id"/dashboards > tmp1.txt

new1=`cat tmp1.txt | wc -l`
if [ $new1 -gt 1 2>/dev/null ]
then

cat tmp1.txt | egrep -vi "</dashboards>|</userRoleDashboards>" > tmp111.xml
rm -rf tmp1.txt

else

echo '<userRoleDashboards version="1">' > tmp111.xml
echo "   <userRoleId>$role1_id</userRoleId> " >> tmp111.xml
echo "    <dashboards> " >> tmp111.xml

fi

echo '      <dashboard version="1"> ' >> tmp111.xml
echo "         <dashboardId>$dashboard_id</dashboardId> " >> tmp111.xml
echo "      </dashboard> " >> tmp111.xml
echo "      </dashboards> " >> tmp111.xml
echo " </userRoleDashboards> " >> tmp111.xml

echo
echo "userRoleDashboards XML"
echo "======================"
cat tmp111.xml
echo
echo

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X PUT -T tmp111.xml "$URL3"/"$role1_id"/dashboards

rm -rf tmp111.xml

echo
echo




else

echo
echo "WRONG INPUT Dashboard choice"
echo

fi

else

echo
echo "WRONG INPUT Userrole choice"
echo

fi
