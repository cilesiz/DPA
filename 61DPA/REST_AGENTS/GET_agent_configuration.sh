#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib
source /root/rosli/61DPA/LIB/listing_id.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.txt
tmp2="$tmprundir"/tmp2.txt
tmpagt="$tmprundir"/tmpagt.xml

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_dpa_agents" > "$tmpagt"

echo
echo
xml fo "$tmpagt"
echo
echo

# listing_jer_extra_agent "$URL_dpa_agents" /agentSettingsList/agentSettings/id agentSettings "$tmp1" id name status port agentVersion
xml sel -t -m agentSettingsList/agentSettings -v numField -o "#" -v agentId -v numField -o "#" -v name -v numField -o "#" -n "$tmpagt" | grep "#" | awk -F"#" '{print "#"NR$0}' > "$tmp1"

echo; 
echo "LISTS OF AGENTS :
---------------"
echo

cat "$tmp1" | awk -F"#" '{print $2"\t"$3"\t"$4}'

echo
echo -n "Choose Agents [ No / ID ] : "
read -e agent_id_nk

agent_id_no=`cat "$tmp1" | grep -i "#$agent_id_nk#" | awk -F"#" '{print $2}'`

if [ $agent_id_no -gt 0 2> /dev/null ]
then

agent_id=`cat "$tmp1" | grep -i "#$agent_id_nk#" | awk -F"#" '{print $3}'`
agent_name=`cat "$tmp1" | grep -i "#$agent_id_nk#" | awk -F"#" '{print $4}'`

echo 
echo "AGENT_ID = $agent_id"
echo "AGENT_NAME = $agent_name"
echo; echo
echo "GET $URL_dpa_agent1/$agent_id/configuration"
echo; echo

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_dpa_agent1"/"$agent_id"/configuration > "$tmp2"

if [ -s "$tmp2" ]
then

echo; echo
xml fo "$tmp2"
echo; echo

echo "
SIMPLIFY RESULTS
================
"

xml sel -t -m CONFIG/REQUEST \
-v UUID \
-o "  MODULE=" -v MODULE/NAME \
-o "  FUNCTION=" -v FUNCTION/NAME \
-o "  TARGET=" -v TARGET/NETNAME \
-o "  ISLOCAL=" -v TARGET/ISLOCAL \
-o "  CRED_TYPE/USER=" -v CRED/TYPE \
-o "/" -v CRED/GENERICAPP/USERNAME \
-n "$tmp2" > "$tmp1"

cat "$tmp1" | grep -i [0-9,a-z] | awk '{print NR"   "$0}'

echo; echo

else
cat "$tmp2"
echo; echo
echo "OUTPUT EMPTY"
echo; echo
rm -rf "$tmprundir"
fi

echo

else

echo
echo "WRONG CHOICE - $agent_id_nk"
echo
rm -rf "$tmprundir"

fi

rm -rf "$tmprundir"
