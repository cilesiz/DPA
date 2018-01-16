#!/bin/bash

dpaserver="$1"
credtype="$2"
credname="$3"
creduser="$4"
credpswd="$5"
creddsct="$6"
texthelp="Usage : [ ./POST_credential.sh or sh POST_credential.sh ] <DPA_server> <Standard/Unix/Windows> <GivenName> <Username> <Password> <Description> <Other/etc>"

if [ -n "$dpaserver" ]||[ -n "$credtype" ]||[ -n "$credname" ]||[ -n "$creduser" ]||[ -n "$credpswd" ]; then

URL=http://"$dpaserver":9004/apollo-api/credentials

tmprundir=/tmp/tmp_credential
mkdir "$tmprundir"

tmp1="$tmprundir"/tmp1.txt
tmp2="$tmprundir"/tmp2.xml

if [ x"$credtype" == xStandard ]; then

echo '<credential version="1">' > "$tmp2"
echo "  <name>$credname</name>
  <description>$creddsct</description>
  <cred>
    <type>$credtype</type>
    <standard>
      <username>$creduser</username>
      <password>$credpswd</password>
    </standard>
  </cred>
</credential> " >> "$tmp2"

elif [ x"$credtype" == xUnix ]; then

echo '<credential version="1">' > "$tmp2"
echo "  <name>$credname</name>
  <description>$creddsct</description>
  <cred>
    <type>Unix</type>
    <unix>
      <username>$creduser</username>
      <password>$credpswd</password>
      <hasHomeDir>false</hasHomeDir>
      <shouldSU>false</shouldSU>
      <shouldSUDO>false</shouldSUDO>
      <sudoNeedsPassword>false</sudoNeedsPassword>
      <sudoIsInteractive>false</sudoIsInteractive>
    </unix>
  </cred>
</credential> " >> "$tmp2"

elif [ x"$credtype" == xWindows ]; then

creddomain="$7"

echo '<credential version="1">' > "$tmp2"
echo "  <name>$credname</name>
  <description>$creddsct</description>
  <cred>
    <type>Windows</type>
    <windows>
      <username>$creduser</username>
      <password>$credpswd</password>
      <domain>$creddomain</domain>
    </windows>
  </cred>
</credential> " >> "$tmp2"

fi

echo "
XML INPUT
========="
xml fo "$tmp2"
echo; echo

login1=administrator
paswd1=administrator

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X POST -T "$tmp2" "$URL" > "$tmp1"

echo
echo
xml fo "$tmp1"
echo
echo

rm -rf "$tmprundir"

else
echo; echo
echo "$texthelp"
echo; echo
fi
