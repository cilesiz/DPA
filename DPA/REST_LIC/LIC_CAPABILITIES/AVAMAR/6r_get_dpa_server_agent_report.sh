#!/bin/bash

pwd1=`pwd`
HB_DPA1=10.64.213.74
user1=administrator
pswd1=administrator

#### TEMPORARY FILES SECTION
masa=`date +%Y%m%d_%H%M%S`
tmp1=/tmp/tmp1_"$masa".xml

#### URL
URL3=http://"$HB_DPA1":9004/dpa-api/agents

##### DPA SERVER ITSELF AS AN AGENT -- TO GET IT'S HOSTNAME AS REGISTER AGENT

curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL3" > "$tmp1"

namatuan=`hostname`
HB_DPA2=`cat "$tmp1" | grep -i "<name>" | grep -i "$namatuan" | awk -F"</" '{print $1}' | awk -F">" '{print $NF}'`
echo
echo "========= HB_DPA2 = $HB_DPA2 ========= "
echo

URL2=http://"$HB_DPA1":9004/dpa-api/agent/"$HB_DPA2"/report

echo

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL2"
echo
echo

rm -rf "$tmp1" 
