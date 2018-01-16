#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

tmp1=/tmp/tmp1_nw.xml

URL1=http://"$HB_DPA":9004/apollo-api/nodes

echo
echo -n "GIVE NETWORKER NODE NAME : "
read -e nodename
echo
echo

echo '      <node version="1" type="NetWorkerBackupClient"> ' > "$tmp1"
echo "        <name>$nodename</name> " >> "$tmp1"
echo "        <displayName>$nodename:NetWorker:$nodename</displayName> " >> "$tmp1"
echo "        <globalName>$nodename:NetWorker:$nodename</globalName> " >> "$tmp1"   
echo "        <creatorType>apollo</creatorType> " >> "$tmp1"
echo "	      <aliases/> " >> "$tmp1"
echo "      </node> " >> "$tmp1"
echo
echo "INPUT XML FOR NODE=NetWorkerBackupClient"
echo "----------------------------------------"
cat "$tmp1"
echo

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -T "$tmp1" "$URL1"

echo
rm -rf "$tmp1"
echo
echo
