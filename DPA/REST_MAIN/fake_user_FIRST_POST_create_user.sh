#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/users
URL2=http://"$HB_DPA":9004/apollo-api/ldap-settings
URL3=http://"$HB_DPA":9004/apollo-api/ldap-settings/user-test-request

hari=`date +%Y%m%d_%H%M%S`
tmp1=/tmp/tmp1_"$hari".txt
tmp2=/tmp/tmp2_"$hari".txt
tmp3=/tmp/tmp3_"$hari".txt
tmp4=/tmp/tmp4_"$hari".txt
tmp5=/tmp/tmp5_"$hari".txt
tmp6=/tmp/tmp6_"$hari".txt

tmp1fake=/tmp/tmp1fake_"$hari".txt
tmp2fake=/tmp/tmp2fake_"$hari".xml
tmp3fake=/tmp/tmp3fake_"$hari".txt

echo

curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > "$tmp1"
echo 
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL2" > "$tmp2"
echo

LDAP_IP=`cat "$tmp2" | egrep -i "<server>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}'`
AUTO_LOGON=`cat "$tmp2" | egrep -i "<allowAutoLogon>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}'`
DEFAULT_ROLE=`cat "$tmp2" | egrep -i "<defaultRole>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}'`
UID_ATTRIBT=`cat "$tmp2" | egrep -i "<uidAttribute>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}'`

cat "$tmp1" | grep -i "apollo-api" | awk -F"/" '{print $6}' | awk -F'"' '{print $1}' > "$tmp3"
cat "$tmp1" | grep -i "<logonName>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}' > "$tmp4"

echo
echo "=========================="
echo "LDAP SERVER $LDAP_IP : "
echo "=========================="
echo
if [ $LDAP_IP == 10.64.213.17 -o $LDAP_IP == 10.64.213.18 ]
then

echo "List of Users : "
echo "==============="
echo
/usr/bin/rsh "$LDAP_IP" -l root cat /etc/passwd | grep -v "/var" | egrep -i "test|ldap" | awk -F: '{print $1,","}' | tr "\n" " "
echo
echo
else
echo
echo "IT IS NOT LDAP SERVER.... MAYBE AD (ACTIVE DIRECTORY) SERVER"
echo
fi
echo
echo
echo "=========================="
echo "DPA SERVER $HB_DPA : "
echo "=========================="
echo
echo "AUTO LOGON = $AUTO_LOGON "
echo "DEFAULT ROLE = $DEFAULT_ROLE "
echo "UID ATTRIBUTE = $UID_ATTRIBT "
echo
echo 
echo "List of existing Users and ID : "
echo "======================"
echo
paste "$tmp4" "$tmp3" | grep -v "agent:" | cat -n
echo
echo
echo "TEST USER LOGON"
echo "==============="
echo
echo -n "Enter Username : "
read -e fakeuser
echo
echo -n "Enter Password : "
read -e fakepswd
echo 
echo "USER = $fakeuser    PASSWD = $fakepswd "

line1="<testUser>$fakeuser<\/testUser>"
line2="<testPassword>$fakepswd<\/testPassword>"

##################################################################################

echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL2" > "$tmp1fake"
echo

cat "$tmp1fake" | egrep -v "<id>|<link" | sed -e 's/<groupRole version.*/<groupRole version="1">/g' -e 's/<ldapSettings.*/<ldapSettings version="1">/g' > "$tmp2fake"

echo
echo "ADDITIONAL LINE1 = $line1"
echo "ADDITIONAL LINE2 = $line2"
echo
echo
echo "Here is the XML conf which will be add to $URL3"
echo 
echo
sed -i "s/<allowAutoLogon>/\t TOREPLACELINE1XXXXX \n \t TOREPLACELINE2XXXXX  \n   <allowAutoLogon>/g" "$tmp2fake"
sed -i "s/TOREPLACELINE1XXXXX.*/$line1/g" "$tmp2fake"
sed -i "s/TOREPLACELINE2XXXXX.*/$line2/g" "$tmp2fake"
cat "$tmp2fake"
echo -n > "$tmp3fake"

echo
echo

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -T "$tmp2fake" -X POST "$URL3" > "$tmp3fake" 2>&1

echo
echo
cat "$tmp3fake" 
echo
echo

############ NOW PROCESS TO SEND DATA TO fake_user_SECOND_GET_check_user_validity.sh FILE #####

fakeuserid=`cat "$tmp3fake" | grep -i "user-test-request" | grep -i "result" | awk -F"/" '{print $7}'`
periksa2=`ls -al | grep -i fake_user_SECOND_GET_check_user_validity.sh | awk '{print $NF}'`

echo
echo "This information will be transfer to file $periksa2 : "
echo
echo "USER   - $fakeuser "
echo "PASSWD - $fakepswd "
echo "UID    - $fakeuserid "
echo

sed -i "s/fakeuser=.*/fakeuser=$fakeuser/g" "$periksa2" 
sed -i "s/fakepswd=.*/fakepswd=$fakepswd/g" "$periksa2"  
sed -i "s/fakeuserid=.*/fakeuserid=$fakeuserid/g" "$periksa2"  
sed -i "s/HB_DPA=10.64.205.162

######## FINALLY -- REMOVE TEMPORARY FILES 
rm -rf "$tmp1" "$tmp2" "$tmp3" "$tmp4" "$tmp1fake" "$tmp2fake" "$tmp3fake"
