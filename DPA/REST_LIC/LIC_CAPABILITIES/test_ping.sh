#!/bin/bash

# set -x

pwd1=`pwd`
HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

#### TEMPORARY FILES SECTION
masa=`date +%Y%m%d_%H%M%S`
tmp4=/tmp/tmp4_"$masa".xml
tmp5=/tmp/tmp5_"$masa".xml

#### URL
URL3=http://"$HB_DPA":9004/dpa-api/agents

##### DPA SERVER ITSELF AS AN AGENT -- TO GET IT'S HOSTNAME AS AN REGISTERED AGENT

curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL3" > "$tmp4"

bilangan1=`cat "$tmp4" | grep -i "<name>" | wc -l`
if [ $bilangan1 == 1 ]
then
HB_DPA2=`cat "$tmp4" | grep -i "<name>" | awk -F"</" '{print $1}' | awk -F">" '{print $NF}'`
HB_DPA3="SAME_NO_NEED"
else

echo > "$tmp5"
for host1 in `cat "$tmp4" | grep -i "<name>" | awk -F"</" '{print $1}' | awk -F">" '{print $NF}'`
do
ping -c 1 "$host1" >> "$tmp5" 2>&1
done

bilangan2=`cat "$tmp5" | grep -i "$HB_DPA" | grep PING | wc -l`
if [ $bilangan2 == 0 ]
then
echo
echo "Cannot DEFINE DPA_SERVER $HB_DPA 's agent name - Need to choose manually"
echo
cat "$tmp4" | grep -i "<name>" | awk -F"</" '{print $1}' | awk -F">" '{print NR"\t"$NF}'
cat "$tmp4" | grep -i "<name>" | awk -F"</" '{print $1}' | awk -F">" '{print "#"NR"#"$NF"#"}' > "$tmp5"
echo -n "Your choice : "
read -e HB_DPA3
echo
berapa=`cat "$tmp5" | grep "#$HB_DPA3#" | awk -F"#" '{print $2}'`
if [ $berapa -gt 0 2> /dev/null ]
then
HB_DPA2=`cat "$tmp5" | grep "#$HB_DPA3#" | awk -F"#" '{print $(NF-1)}'`
else
echo "Wrong choice $HB_DPA3 -- EXITING"
fi
else
HB_DPA3=`cat "$tmp5" | grep -i "$HB_DPA" | grep PING | awk '{print $2}'`
HB_DPA2=`cat "$tmp4" | grep -i "<name>" | grep -i "$HB_DPA3" | awk -F"</" '{print $1}' | awk -F">" '{print $NF}'`
fi
fi

echo
echo "========= HB_DPA1 = $HB_DPA =========="
echo
echo "========= HB_DPA2 = $HB_DPA2 ========="
echo
echo "========= HB_DPA3 = $HB_DPA3 ========="
echo
