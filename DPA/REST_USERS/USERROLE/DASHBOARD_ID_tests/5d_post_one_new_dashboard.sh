#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/viewlettemplates
URL2=http://"$HB_DPA":9004/apollo-api/userroles
URL3=http://"$HB_DPA":9004/dpa-api/dashboards

echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > tmp1.txt
echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL2" > tmp123.txt
echo

echo
echo "TO CREATE A NEW DASHBOARD"
echo "========================="
echo
echo -n "Please put the NAME : "
read -e namadiberi
echo
echo -n "Please put the DESCRIPTION : "
read -e descrptn
echo

echo "LIST OF VIEWLET TEMPLATES"
echo "========================="
echo
cat tmp1.txt | grep -i "<name>" | awk -F">" '{print $2}' | awk -F"<" '{print "#"$1"#"}' > tmp2a.txt
cat tmp1.txt | grep -i "<id>" | awk -F">" '{print $2}' | awk -F"<" '{print "#"$1"#"}' > tmp2b.txt
paste tmp2b.txt tmp2a.txt | awk -F"#" '{print NR"\t"$2"\t"$(NF-1)}'
paste tmp2b.txt tmp2a.txt | awk -F"#" '{print "#"NR"#"$2"#"$(NF-1)"#"}' > tmp2.txt
echo
echo -n "Choose Viewlet Templates to ADD to Dashboard $namadiberi [ No / ID / Fullname ] : "
read -e viewltnak

berapa=`cat tmp2.txt | grep "#$viewltnak#" | awk -F"#" '{print $2}'`
siapanya=`cat tmp2.txt | grep "#$viewltnak#" | awk -F"#" '{print $4}'`
viewlet_id=`cat tmp2.txt | grep "#$viewltnak#" | awk -F"#" '{print $3}'`

rm -rf tmp1.txt 

echo
echo "No = $berapa / Viewlet = $siapanya / ID = $viewlet_id"
echo

if [ $berapa -gt 0 2> /dev/null ]
then

echo

echo ' <dashboard version="1"> ' > tmp12.xml
echo "    <name>$namadiberi</name> " >> tmp12.xml
echo "    <description>$descrptn</description> " >> tmp12.xml
echo "     <system>false</system> " >> tmp12.xml
echo "      <viewlets> " >> tmp12.xml
echo '       <viewlet version="1"> ' >> tmp12.xml
echo '         <layout row="0" column="0" width="200" height="200"/> ' >> tmp12.xml
echo "         <viewletTemplate> " >> tmp12.xml
echo "            <id>$viewlet_id</id> " >> tmp12.xml
echo "         </viewletTemplate> " >> tmp12.xml
echo "         <nodeLinks/> " >> tmp12.xml
echo "         <parameters/> " >> tmp12.xml
echo "       </viewlet> " >> tmp12.xml

echo -n "Add another Viewlet ? [ Y / N ] : "
read -e nakaddviewlet

while [ $nakaddviewlet == Y -o $nakaddviewlet == y ] 
do

echo
echo "ADDITIONAL VIEWLETS"
echo "-------------------"
echo
echo "LIST OF VIEWLET TEMPLATES"
echo
paste tmp2b.txt tmp2a.txt | awk -F"#" '{print NR"\t"$2"\t"$(NF-1)}'
echo
echo -n "Choose Viewlet Templates to ADD to Dashboard $namadiberi [ No / ID / Fullname ] : "
read -e viewltnak

berapa=`cat tmp2.txt | grep "#$viewltnak#" | awk -F"#" '{print $2}'`
siapanya=`cat tmp2.txt | grep "#$viewltnak#" | awk -F"#" '{print $4}'`
viewlet_id=`cat tmp2.txt | grep "#$viewltnak#" | awk -F"#" '{print $3}'`

echo
echo "No = $berapa / Viewlet = $siapanya / ID = $viewlet_id"
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
rm -rf tmp2a.txt tmp2b.txt tmp2.txt

else

echo "WRONG INPUT"
echo
rm -rf tmp2a.txt tmp2b.txt tmp2.txt
exit

fi
echo "   </viewlets> " >> tmp12.xml

echo
# curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL2" > tmp1.txt

echo
echo "USERROLES THAT HAVE ACCESS TO ABOVE DASHBOARD $namadiberi"
echo "======================================================"
echo
echo "   <authorization> " >> tmp12.xml
echo
cat tmp123.txt | grep -i "<link" | awk -F"/" '{print $(NF-1)}' | awk -F'"' '{print "#"$(NF-1)"#"}' > tmp2.txt
cat tmp123.txt | grep -i "<name>" | awk -F"<name>" '{print $NF}' | awk -F"</name>" '{print "#"$(NF-1)"#"}' > tmp3.txt
paste tmp3.txt tmp2.txt | awk -F"#" '{print "#"NR"#"$2"#"$(NF-1)"#"}' > tmp4.txt

echo "      <read> " >> tmp12.xml
echo "         <users/> " >> tmp12.xml
echo "         <userRoles> " >> tmp12.xml

echo "Choose USERROLES FOR READ ONLY PRIVILEGES"
echo "-----------------------------------------"

nakroleRO=Y
while [ $nakroleRO == y -o $nakroleRO == Y ]
do

echo
paste tmp3.txt tmp2.txt | awk -F"#" '{print NR"\t"$2"\t\t"$(NF-1)}'
echo
echo -n "Choose UserRole to ADD [ No / User / ID ] : "
read -e userrole1
berapa=`cat tmp4.txt | grep -i "#$userrole1#" | cut -d# -f2`
role1=`cat tmp4.txt | grep -i "#$userrole1#" | cut -d# -f3`
role1_id=`cat tmp4.txt | grep -i "#$userrole1#" | cut -d# -f4`

if [ $berapa -gt 0 2>/dev/null ]
then

echo
echo "No = $berapa / UserRole = $role1 / ID = $role1_id"
echo
echo "            <userRole> "  >> tmp12.xml
echo "               <id>$role1_id</id> "  >> tmp12.xml
echo "            </userRole> "  >> tmp12.xml

else

echo
echo "WRONG INPUT"
echo

fi

echo -n "Add another Userrole for READ ONLY ? [ Y / N ] : "
read -e nakroleRO

done

echo "         </userRoles> "  >> tmp12.xml
echo "      </read> "  >> tmp12.xml

echo "      <readWrite> " >> tmp12.xml
echo "         <users/> " >> tmp12.xml
echo "         <userRoles> " >> tmp12.xml

echo
echo "Choose USERROLES FOR READ WRITE PRIVILEGES"
echo "------------------------------------------"

nakroleRW=Y
while [ $nakroleRW == y -o $nakroleRW == Y ]
do

echo
paste tmp3.txt tmp2.txt | awk -F"#" '{print NR"\t"$2"\t\t"$(NF-1)}'
echo
echo -n "Choose UserRole to ADD [ No / User / ID ] : "
read -e userrole1
berapa=`cat tmp4.txt | grep -i "#$userrole1#" | cut -d# -f2`
role1=`cat tmp4.txt | grep -i "#$userrole1#" | cut -d# -f3`
role1_id=`cat tmp4.txt | grep -i "#$userrole1#" | cut -d# -f4`

if [ $berapa -gt 0 2>/dev/null ]
then

echo
echo "No = $berapa / UserRole = $role1 / ID = $role1_id"
echo
echo "            <userRole> "  >> tmp12.xml
echo "               <id>$role1_id</id> "  >> tmp12.xml
echo "            </userRole> "  >> tmp12.xml

else

echo
echo "WRONG INPUT"
echo

fi

echo -n "Add another Userrole for READ WRITE [ Y / N ] : "
read -e nakroleRW

done

rm -rf tmp123.txt tmp2.txt tmp3.txt tmp4.txt

echo "         </userRoles> "  >> tmp12.xml
echo "      </readWrite> "  >> tmp12.xml
echo "   </authorization> "  >> tmp12.xml
echo "</dashboard> "  >> tmp12.xml

echo
echo
echo "INPUT XML"
echo "========="
echo
cat tmp12.xml
echo

echo

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -T tmp12.xml "$URL3"

echo
rm -rf tmp12.xml
echo
