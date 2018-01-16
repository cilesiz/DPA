#!/bin/bash

echo "
Usage = ./<binary.sh> <DPA_server> <http/https> <administrator_pswd>
"

DPA_svr="$1"
sslornot="$2"
adminpswd="$3"

if [ x"$DPA_svr" == x ]; then
DPA_svr=`/sbin/ifconfig eth0 | grep -i bcast | grep -i mask | awk -F"addr:" '{print $2}' | awk -F"Bcast" '{print $1}' | awk '{print $1}'`
fi

if [ x"$sslornot" == xhttp -o x"$sslornot" == x9004 ]; then
urlssl="http://"
portssl=9004
else
urlssl="https://"
portssl=9002
fi

if [ x"$adminpswd" != x ]; then
login1=administrator
paswd1="$adminpswd"
else
login1=administrator
paswd1=administrator
fi

HB_DPA="$urlssl""$DPA_svr:$portssl"

URL_apollo_usr="$HB_DPA"/apollo-api/users
URL_ldap_settg="$HB_DPA"/apollo-api/ldap-settings
URL_ldapstgutr="$HB_DPA"/apollo-api/ldap-settings/user-test-request

hari=`date +%Y%m%d_%H%M%S`
tmpldap=/tmp/tmp_ldap_"$hari"
mkdir -p "$tmpldap"
tmp1="$tmpldap"/tmp1.txt
tmp2="$tmpldap"/tmp2.txt
tmp1fake="$tmpldap"/tmp1fake.txt
tmp2fake="$tmpldap"/tmp2fake.xml
tmp3fake="$tmpldap"/tmp3fake.txt

echo "
URL_apollo_usr = $URL_apollo_usr
URL_ldap_settg = $URL_ldap_settg
URL_ldapstgutr = $URL_ldapstgutr
"

echo

curl -k -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" \
-H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL_apollo_usr" > "$tmp1"
echo 
curl -k -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" \
-H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL_ldap_settg" > "$tmp2"
echo

bindusertukar=`xml sel -t -m ldapSettings -v bindUser "$tmp2"`
sed -i "s/<bindPassword><\/bindPassword>/<bindPassword>$bindusertukar<\/bindPassword>/g" "$tmp2"

LDAP_IP=`xml sel -t -m ldapSettings -v server "$tmp2"`
AUTO_LOGON=`xml sel -t -m ldapSettings -v allowAutoLogon "$tmp2"`
DEFAULT_ROLE=`xml sel -t -m ldapSettings -v defaultRole "$tmp2"`
UID_ATTRIBT=`xml sel -t -m ldapSettings -v uidAttribute "$tmp2"`

echo
echo "=========================="
echo "LDAP SERVER $LDAP_IP : "
echo "=========================="
echo
if [ x"$LDAP_IP" == x10.64.213.7 -o x"$LDAP_IP" == x10.64.213.8 ]
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
echo "DPA SERVER $DPA_svr : "
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
xml sel -t -m users/user \
-o "  ID=" -v id \
-o "  NAME=" -v logonName \
-o "  AUTHTYPE=" -v authenticationType \
-o "  STATUS=" -v status \
-n "$tmp1" | grep -i [0-9,a-z] | awk '{print NR"   "$0}' 

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

cp "$tmp2" "$tmp1fake"
echo

cat "$tmp1fake" | egrep -v "<id>|<link" > "$tmp2fake"
sed -i 's/<groupRole version.*/<groupRole version="1">/g' "$tmp2fake" 
sed -i 's/<ldapSettings.*/<ldapSettings version="1">/g' "$tmp2fake"

echo
echo "ADDITIONAL LINE1 = $line1"
echo "ADDITIONAL LINE2 = $line2"
echo
echo
echo "XML INPUT TO POST TO $URL_ldapstgutr"
echo 
echo
sed -i "s/<allowAutoLogon>/\t TOREPLACELINE1XXXXX \n \t TOREPLACELINE2XXXXX  \n   <allowAutoLogon>/g" "$tmp2fake"
sed -i "s/TOREPLACELINE1XXXXX.*/$line1/g" "$tmp2fake"
sed -i "s/TOREPLACELINE2XXXXX.*/$line2/g" "$tmp2fake"
xml fo "$tmp2fake"
echo -n > "$tmp3fake"

echo
echo

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" \
-H "Content-Type: application/vnd.emc.apollo-v1+xml" -T "$tmp2fake" -X POST "$URL_ldapstgutr" > "$tmp3fake" 2>&1

echo
echo
cat "$tmp3fake" 
echo
echo

############ NOW PROCESS TO SEND DATA TO SECOND_GET_check_user_validity.sh FILE #####

fakeuserid=`cat "$tmp3fake" | grep -i "user-test-request" | grep -i "result" | awk -F"/" '{print $7}'`
periksa2=`ls -al | grep -i SECOND_GET_check_testuser_validity.sh | awk '{print $NF}'`

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
sed -i "s/DPA_svr=.*/DPA_svr=$DPA_svr/g" "$periksa2"
sed -i "s/portssl=.*/portssl=$portssl/g" "$periksa2"
sed -i "s/user1=.*/user1=$login1/g" "$periksa2"
sed -i "s/pswd1=.*/pswd1=$paswd1/g" "$periksa2"
if [ x"$portssl" == x9002 ]; then
sed -i "s/urlssl=.*/urlssl=\"https:\/\/\"/g" "$periksa2"
else 
sed -i "s/urlssl=.*/urlssl=\"http:\/\/\"/g" "$periksa2"
fi

######## FINALLY -- REMOVE TEMPORARY FILES 
rm -rf "$tmpldap"
