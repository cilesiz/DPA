#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator
tmp1=/tmp/tmpxml1.txt
tmphead=/tmp/tmphead

URL1=http://"$HB_DPA":9004/apollo-api/ldap-settings

echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > "$tmphead"

headdpa1=`cat "$tmphead" | grep -i ldapSettings | head -1`
rm -rf "$tmphead"

echo
echo "First, select which AD server you want to use : "
echo
echo "1) 10.64.212.133 (Elaine's AD server)"
echo "2) 10.64.213.66 (Rosli's AD server)"
echo
echo -n "Your choice [ 1 / 2 ] : "
read -e ad1

if [ $ad1 -gt 0 -a $ad1 -eq 1 2> /dev/null ]
then
usad1="<server>10.64.212.133</server>"
usbasedn1="<baseDN>CN=Users,DC=qa-dpa,DC=emc,DC=com</baseDN>"
usbinduser1="<bindUser>CN=elaine2,CN=Users,DC=qa-dpa,DC=emc,DC=com</bindUser>"
usbindpswd1="<bindPassword>Painfull11</bindPassword>"
usbsdnfgrp1="<baseDNForGroup>CN=Users,DC=qa-dpa,DC=emc,DC=com</baseDNForGroup>"
grpad1=dpatest
grpad2=dpatest2
grpad3="test group"

elif [ $ad1 -gt 0 -a $ad1 -eq 2 2> /dev/null ]
then
usad1="<server>10.64.213.66</server>"
usbasedn1="<baseDN>CN=Users,DC=emcqa,DC=corp,DC=emc,DC=com</baseDN>"
usbinduser1="<bindUser>CN=usertest1,CN=Users,DC=emcqa,DC=corp,DC=emc,DC=com</bindUser>"
usbindpswd1="<bindPassword>CP2HEFnGciqg3K/OF9qHxQWhw==</bindPassword>"
usbsdnfgrp1="<baseDNForGroup>CN=Users,DC=emcqa,DC=corp,DC=emc,DC=com</baseDNForGroup>"
grpad1=testgrp1
grpad2=testgrp2
grpad3=testgrp3

else
echo
echo "Wrong selection, program TERMINATE"
echo
exit
fi

echo
echo "Carefully select <uidAttribute> to use : "
echo
echo "1) CN"
echo "2) sAMAccountName"
echo
echo -n "Your choice [ 1 / 2 ] : "
read -e uidAttribute1

if [ $uidAttribute1 -gt 0 -a $uidAttribute1 -eq 1 2> /dev/null ]
then
usuid1="<uidAttribute>CN</uidAttribute>"
elif [ $uidAttribute1 -gt 0 -a $uidAttribute1 -eq 2 2> /dev/null ]
then
usuid1="<uidAttribute>sAMAccountName</uidAttribute>"
else
echo
echo "Wrong selection, program TERMINATE"
echo
exit
fi

echo
echo "Now select defaultRole for autologon users : "
echo
echo "1) None "
echo "2) Administrator "
echo "3) Application Owner "
echo "4) Engineer "
echo "5) User "
echo
echo -n "Your choice [ 1 / 2 / 3 / 4 / 5 ] : "
read -e defaultrole1

if [ $defaultrole1 -gt 0 -a $defaultrole1 -eq 1 2> /dev/null ]
then
usrole1="<defaultRole></defaultRole>"
role1="Application Owner"
role2=Engineer
role3=User

elif [ $defaultrole1 -gt 0 -a $defaultrole1 -eq 2 2> /dev/null ]
then
usrole1="<defaultRole>Administrator</defaultRole>"
role1="Application Owner"
role2=Engineer
role3=User

elif [ $defaultrole1 -gt 0 -a $defaultrole1 -eq 3 2> /dev/null ]
then
usrole1="<defaultRole>Application Owner</defaultRole>"
role1=Engineer
role2=User
role3=Administrator

elif [ $defaultrole1 -gt 0 -a $defaultrole1 -eq 4 2> /dev/null ]
then
usrole1="<defaultRole>Engineer</defaultRole>"
role1="Application Owner"
role2=Administrator
role3=User

elif [ $defaultrole1 -gt 0 -a $defaultrole1 -eq 5 2> /dev/null ]
then
usrole1="<defaultRole>User</defaultRole>"
role1="Application Owner"
role2=Engineer
role3=Administrator

else
echo
echo "Wrong selection, program TERMINATE"
echo
exit
fi

echo

echo "$headdpa1" > "$tmp1"
echo "<useLDAPAuthentication>true</useLDAPAuthentication>" >> "$tmp1"
echo "$usad1" >> "$tmp1"
echo "<port>389</port>" >> "$tmp1"
echo "<useSSL>false</useSSL>" >> "$tmp1"
echo "<ldapVersion>3</ldapVersion>" >> "$tmp1"
echo "$usbasedn1" >> "$tmp1"   
echo "$usuid1" >> "$tmp1"
echo "$usbinduser1" >> "$tmp1"
echo "$usbindpswd1" >> "$tmp1"
echo "<allowAutoLogon>true</allowAutoLogon>" >> "$tmp1"
echo "$usrole1" >> "$tmp1"
echo "$usbsdnfgrp1" >> "$tmp1"
echo "<groupAttribute>cn</groupAttribute>" >> "$tmp1"
echo "<groupMemberAttribute>member</groupMemberAttribute>" >> "$tmp1"
echo "   <groupRoles>" >> "$tmp1"
echo "       <groupRole>" >> "$tmp1"
echo "          <group>$grpad1</group>" >> "$tmp1"
echo "          <role>$role1</role>" >> "$tmp1"
echo "       </groupRole>" >> "$tmp1"
echo "       <groupRole>" >> "$tmp1"
echo "          <group>$grpad2</group>" >> "$tmp1"
echo "          <role>$role2</role>" >> "$tmp1"
echo "       </groupRole>" >> "$tmp1"
echo "       <groupRole>" >> "$tmp1"
echo "          <group>$grpad3</group>" >> "$tmp1"
echo "          <role>$role3</role>" >> "$tmp1"
echo "       </groupRole>" >> "$tmp1"
echo "    </groupRoles>" >> "$tmp1"
echo "</ldapSettings>" >> "$tmp1"

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X PUT -T "$tmp1" "$URL1"

echo

rm -rf "$tmp1" 
