#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/apollo-api/users
URL2=http://"$HB_DPA":9004/apollo-api/ldap-settings

tmp1=/tmp/tmp1.txt
tmp2=/tmp/tmp2.txt
tmp3=/tmp/tmp3.txt
tmp4=/tmp/tmp4.txt
tmp5=/tmp/tmp5.txt
tmp6=/tmp/tmp6.txt

echo

curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > "$tmp1"
echo 
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL2" > "$tmp2"
echo

LDAP_IP=`cat "$tmp2" | egrep -i "<server>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}'`
AUTO_LOGON=`cat "$tmp2" | egrep -i "<allowAutoLogon>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}'`
DEFAULT_ROLE=`cat "$tmp2" | egrep -i "<defaultRole>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}'`

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
echo "List of Groups and its' members : "
echo "================================"
echo
/usr/bin/rsh "$LDAP_IP" -l root cat /etc/group | egrep -i "test|ldap" | awk -F: '{print $1,"(",$4,")",","}' | grep -v "(  )" | tr "\n" " "
echo

else

echo "Server is not an LDAP server"

fi

echo
echo "=========================="
echo "DPA SERVER $HB_DPA : "
echo "=========================="
echo
echo "AUTO LOGON = $AUTO_LOGON "
echo "DEFAULT ROLE = $DEFAULT_ROLE "
echo
echo "List of Group and Role : "
echo "========================"
echo
cat "$tmp2" | egrep -i "<group>|<role>" | awk -F">" '{print $2}' | awk -F"<" '{print $1}' | paste - -
echo
echo 
echo "List of Users and ID : "
echo "======================"
echo
paste "$tmp4" "$tmp3" | grep -v "agent:" | cat -n
paste "$tmp4" "$tmp3" | grep -v "agent:" | cat -n | awk '{print "#"$1"#"$2"#"$NF"#"}' > "$tmp5"
echo
echo
echo "You can choose to try above users or other users"
echo
echo -n "Choose agent to check [No/UserName/ID] : "
read -e agentnak

cat "$tmp5" | grep -i "#$agentnak#" > "$tmp6"

nombor=`cat "$tmp6" | awk -F# '{print $2}'`
namanya=`cat "$tmp6" | awk -F# '{print $3}'`
system_id=`cat "$tmp6" | awk -F# '{print $4}'`

rm -rf "$tmp1" "$tmp2" "$tmp3" "$tmp4" "$tmp5" "$tmp6" 

if [ $nombor -gt 0 2> /dev/null ]
then

echo
echo "Number = $nombor"
echo "LogonName = $namanya"
echo "ID = $system_id"
echo
user2="$namanya"
echo -n "User passwd : "
read -e pswd2

echo
echo "LOGON TEST FOR USER ($user2) / PSSWD ($pswd2) TO GET LDAP/AD SETTING INFO "
echo "=========================================================================="
echo
echo
curl -IL -u "$user2":"$pswd2" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL2"
echo
curl -u "$user2":"$pswd2" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL2"
echo
echo

else

echo
user2="$agentnak"
echo
echo -n "User passwd : "
read -e pswd2
echo
echo "LOGON TEST FOR USER ($user2) / PSSWD ($pswd2) TO GET LDAP/AD SETTING INFO "
echo "=========================================================================="
echo
echo
curl -IL -u "$user2":"$pswd2" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL2"
echo
curl -u "$user2":"$pswd2" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL2"
echo
echo

fi
