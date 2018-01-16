#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/userroles
URL2=http://"$HB_DPA":9004/dpa-api/reportmenu
URL3=http://"$HB_DPA":9004/dpa-api/userroles
URL4=http://"$HB_DPA":9004/apollo-api/users

echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > tmp1.txt
echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL2" > tmp123.txt
echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL4" > tmpuser1.txt
echo
echo "CHOOSE USER/PASSWD TO USE IN ASSIGNING MENUS TO USERROLE"

echo
cat tmpuser1.txt | egrep -i "apollo-api|<logonName>" | paste - - | awk -F"/" '{print $(NF-1)"#"$(NF-2)}' | awk -F"<logonName>"  '{print $NF}' | awk -F"<"  '{print $1$2}' | awk -F'"' '{print NR"#"$1}' | awk -F"#" '{print $1"\t"$2"\t""\t""\t"$3}'
cat tmpuser1.txt | egrep -i "apollo-api|<logonName>" | paste - - | awk -F"/" '{print $(NF-1)"#"$(NF-2)}' | awk -F"<logonName>"  '{print $NF}' | awk -F"<"  '{print $1$2}' | awk -F'"' '{print "#"NR"#"$1"#"}' > tmp2.txt
echo
echo -n "Choose User to LOGIN/USE [No/LogonName/ID] : "
read -e agentnak

cat tmp2.txt | grep -i "#$agentnak#" > tmp3.txt

berapa=`cat tmp3.txt | awk -F# '{print $2}'`
usernya=`cat tmp3.txt | awk -F# '{print $3}'`

rm -rf tmpuser1.txt tmp2.txt tmp3.txt

echo

if [ $berapa -gt 0 2> /dev/null ]
then

echo "CHOOSEN : No = $berapa / LogonName = $usernya"
echo
echo -n "Password for $usernya : "
read -e pswdnya

else

echo
echo "WRONG INPUT"
exit

fi

echo
echo
echo "ASSIGNING MENUS TO USERROLE"
echo "==========================="
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
echo
echo "EXISTING MENUS"
echo "=============="
echo

curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL3"/"$role1_id"/menus > tmp5.txt
echo
new1=`cat tmp5.txt | sed -e "/<error>/,/<\/error>/{//p;d;}" | grep -v "error>" | wc -l`
if [ $new1 -gt 1 2>/dev/null ]
then

cat tmp5.txt
echo

else

echo
echo "NO MENUS ASSIGN TO USERROLE $role1"
echo

fi

echo

rm -rf tmp1.txt tmp2.txt tmp3.txt tmp4.txt tmp5.txt

echo

# curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL2" > tmp1.txt

echo
echo "List of REPORTMENUS"
echo "-------------"

echo
cat tmp123.txt | grep -i "<link" | awk -F"/" '{print $(NF-1)}' | awk -F'"' '{print "#"$(NF-1)"#"}' > tmp2a.txt
cat tmp123.txt | grep -i "<name>" | awk -F"<name>" '{print $NF}' | awk -F"</name>" '{print "#"$(NF-1)"#"}' > tmp3.txt
avail1=`cat tmp3.txt | wc -l`
cat tmp2a.txt | head -"$avail1" > tmp2.txt

paste tmp3.txt tmp2.txt | awk -F"#" '{print NR"\t"$2"\t\t"$(NF-1)}'
paste tmp3.txt tmp2.txt | awk -F"#" '{print "#"NR"#"$2"#"$(NF-1)"#"}' > tmp4.txt

echo
echo -n "CHOOSE REPORT MENUS TO ADD TO ROLE [ No / User / ID ] : "
read -e agentnak

berapa=`cat tmp4.txt | grep "#$agentnak#" | awk -F"#" '{print $2}'`
siapanya=`cat tmp4.txt | grep "#$agentnak#" | awk -F"#" '{print $3}'`
menu_id=`cat tmp4.txt | grep "#$agentnak#" | awk -F"#" '{print $4}'`

rm -rf tmp123.txt tmp2a.txt tmp2.txt tmp3.txt tmp4.txt

echo
echo "No = $berapa \ Desciptn = $siapanya \ ID = $menu_id"
echo

if [ $berapa -gt 0 2> /dev/null ]
then

echo

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL3"/"$role1_id"/menus > tmp1.txt

new1=`cat tmp1.txt | sed -e "/<error>/,/<\/error>/{//p;d;}" | grep -v "error>" | wc -l`
if [ $new1 -gt 1 2>/dev/null ]
then

cat tmp1.txt | awk "/<userRoleMenus/,/<\/userRoleId>/" > tmp111.xml
echo "    <menus> " >> tmp111.xml
cat tmp1.txt | awk "/<menus/,/<\/menus>/" | grep -vi menus >> tmp111.xml

rm -rf tmp1.txt

else

echo '<userRoleMenus version="1">' > tmp111.xml
echo "   <userRoleId>$role1_id</userRoleId> " >> tmp111.xml
echo "    <menus> " >> tmp111.xml

fi

echo '      <menu version="1"> ' >> tmp111.xml
echo "         <menuId>$menu_id</menuId> " >> tmp111.xml
echo "      </menu> " >> tmp111.xml
echo "      </menus> " >> tmp111.xml
echo "    <allMenus>false</allMenus> " >> tmp111.xml
echo " </userRoleMenus> " >> tmp111.xml

echo
echo "userRoleMenus XML"
echo "================="
cat tmp111.xml
echo
echo

curl -v -u "$usernya":"$pswdnya" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X PUT -T tmp111.xml "$URL3"/"$role1_id"/menus

rm -rf tmp111.xml

echo
echo




else

echo
echo "WRONG INPUT Menus choice"
echo
rm -rf tmp1.txt tmp123.txt tmp2a.txt tmp2b.txt tmp2.txt tmp3.txt tmp4.txt tmp5.txt

fi

else

echo
echo "WRONG INPUT Userrole choice"
echo
rm -rf tmp1.txt tmp2a.txt tmp2b.txt tmp2.txt tmp3.txt tmp4.txt tmp5.txt

fi
