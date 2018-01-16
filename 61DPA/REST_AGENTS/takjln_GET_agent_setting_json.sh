#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib
source /root/rosli/61DPA/LIB/listing_id.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.txt

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_dpa_agents" > "$tmp1"

echo
echo
xml fo "$tmp1"
echo
echo

listing_jer_extra_agent "$URL_dpa_agents" /agentSettingsList/agentSettings/id agentSettings "$tmp1" id name status port agentVersion

echo
echo -n "Choose Agents [ No / ID ] : "
read -e agent_id_nk

agent_id_no=`cat "$tmp1" | grep -i "#$agent_id_nk#" | awk -F"#" '{print $2}'`

if [ $agent_id_no -gt 0 2> /dev/null ]
then

agent_id=`cat "$tmp1" | grep -i "#$agent_id_nk#" | awk -F"#" '{print $3}'`

echo
curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_dpa_agents"/"$agent_id"/settings | python -mjson.tool
echo

else

echo
echo "WRONG CHOICE - $agent_id_nk"
echo

fi

rm -rf "$tmprundir"
