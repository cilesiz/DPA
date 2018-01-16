#!/bin/bash

pwd1=`pwd`
HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

#### FOR CELERRA SAMPLE CONFIG
HB_SVN=dpa-svn.corp.emc.com
## my CORP login account... please change it with your's
user2=talibr
pswd2=irix293[]1972

#### TEMPORARY FILES SECTION
masa=`date +%Y%m%d_%H%M%S`
tmp1=/tmp/tmp1_"$masa".xml
tmp2=/tmp/tmp2_"$masa".xml
tmp3=/tmp/tmp3_"$masa".xml
tmp4=/tmp/tmp4_"$masa".xml
tmp5=/tmp/tmp5_"$masa".xml

#### URL
URL1=http://"$HB_DPA":9004/apollo-api/nodes
URL3=http://"$HB_DPA":9004/dpa-api/agents

##### SAMPLE CELERRA CONFIG XML
echo
wget --user="$user2" --password="$pswd2" http://"$HB_SVN"/svn/dpaqa/Branch/6.0/sample_celerra_config_report.xml
echo

cat "$pwd1"/sample_celerra_config_report.xml | sed -e "s/></>\n</g" > "$tmp1"
echo

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
echo
echo -n "Your choice [ No / AgentName ] : "
read -e HB_DPA3
echo
berapa=`cat "$tmp5" | grep "#$HB_DPA3#" | awk -F"#" '{print $2}'`
if [ $berapa -gt 0 2> /dev/null ]
then
HB_DPA2=`cat "$tmp5" | grep "#$HB_DPA3#" | awk -F"#" '{print $(NF-1)}'`
else
echo "Wrong choice $HB_DPA3 -- EXIT"
fi
else
HB_DPA3=`cat "$tmp5" | grep -i "$HB_DPA" | grep PING | awk '{print $2}'`
HB_DPA2=`cat "$tmp4" | grep -i "<name>" | grep -i "$HB_DPA3" | awk -F"</" '{print $1}' | awk -F">" '{print $NF}'`
fi
fi

echo
echo "========= HB_DPA2 = $HB_DPA2 ========= "
echo

URL2=http://"$HB_DPA":9004/dpa-api/agent/"$HB_DPA2"/report

##### CREATE NODE AND POST MAIN SAMPLE NODE FOR NEWLY CREATE NODE

echo
echo -n "GIVE NODE NAME (HOSTNAME WITHOUT DOMAINNAME) : "
read -e nodename
echo
echo -n "GIVE NODE'S DOMAINNAME : "
read -e domainnodename


echo '      <node type="Celerra"> ' > "$tmp2"
echo "        <name>$nodename.$domainnodename</name> " >> "$tmp2"
echo "        <displayName>$nodename</displayName> " >> "$tmp2"
echo "        <creatorType>apollo</creatorType> " >> "$tmp2"
echo "      </node> " >> "$tmp2"
echo

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -T "$tmp2" "$URL1"
echo
echo
echo "SUCCESSFULL CREATE CELERRA NODE $nodename"
echo

##### CHANGE SAMPLE CELERRA CONFIG XML TO USE NEWLY CREATE NODENAME

cat "$tmp1" | sed -e "s/hostname=\"uncle-mgmt\"/hostname=\"$nodename.$domainnodename\"/g" > "$tmp3"

##### POST MAIN SAMPLE XML DATA TO DB AND DPA AGENT REPORT  
echo
curl -v -u "$user1":"$pswd1" -H "Content-Type: application/vnd.emc.dpa.agent-v1+xml" -X POST -T "$tmp3" "$URL2"
echo
echo

rm -rf "$pwd1"/sample_celerra_config_report.xml*
rm -rf "$tmp1" "$tmp2" "$tmp3" "$tmp4" "$tmp5"
