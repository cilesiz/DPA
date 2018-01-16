#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib
source /root/rosli/61DPA/LIB/listing_id.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.txt
tmp2="$tmprundir"/tmp2.xml

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
agentid=`curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_dpa_agents"/"$agent_id"/settings | xml sel -t -m "agentSettings" -v "name"`

echo
echo "POST $URL_dpa_agent1/$agentid/report"
confirmrest

echo -n '<AXMLRESULT version="6">
                <STATUS cast="Int">0</STATUS>
                <MESSAGE cast="String">Okay</MESSAGE>
                <REPORT module="networker" function="jobmonitor" starttime="1347379745"
                                runtime="5" endtime="2147483647" target="00000000-0000-0000-0000-000000000000" runuuid = "00000000-0000-0000-0000-000000000000" 
                                hostname="w2k3nw763">
                                <groupevent data="discontinuous">
                                                <group_name cast="String" item="key">Group4</group_name>
                                                <status cast="String" item="value">started</status>
                                                <groupstart cast="Int" item="key">1347379035</groupstart>
                                                <starttime cast="Int" item="key">1347379035</starttime>
                                </groupevent>
                                <backupevent data="discontinuous">
                                                <backup_servername cast="String" item="key">w2k3nw763</backup_servername>
                                                <client_name cast="String" item="key">w2k3nw763.wysdm.lab.emc.com</client_name>
                                                <group_name cast="String" item="key">Group4</group_name>
                                                <job_name cast="String" item="key">C:\temp\support</job_name>
                                                <schedule_name cast="String" item="key">Default</schedule_name>
                                                <domain_name cast="String" item="key" />
                                                <backup_set cast="String" item="key" />
                                                <session cast="String" item="key" />
                                                <jobid2 cast="String" item="key">259802</jobid2>
                                                <queuestart cast="Int" item="key">1347379035</queuestart>
                                                <status cast="String" item="value">started</status>
                                                <starttime cast="Int" item="key">1347379037</starttime>
                                </backupevent>
                                <backupevent data="discontinuous">
                                                <backup_servername cast="String" item="key">w2k3nw763</backup_servername>
                                                <client_name cast="String" item="key">w2k3nw763.wysdm.lab.emc.com</client_name>
                                                <group_name cast="String" item="key">Group3</group_name>
                                                <job_name cast="String" item="key">C:\temp\support2</job_name>
                                                <schedule_name cast="String" item="key">Default</schedule_name>
                                                <domain_name cast="String" item="key" />
                                                <backup_set cast="String" item="key" />
                                                <session cast="String" item="key" />
                                                <jobid2 cast="String" item="key">259803</jobid2>
                                                <queuestart cast="Int" item="key">1347379035</queuestart>
                                                <status cast="String" item="value">started</status>
                                                <starttime cast="Int" item="key">1347379037</starttime>
                                </backupevent>
                                <backupevent data="discontinuous">
                                                <backup_servername cast="String" item="key">w2k3nw763</backup_servername>
                                                <client_name cast="String" item="key">w2k3nw763.wysdm.lab.emc.com</client_name>
                                                <group_name cast="String" item="key">Group5</group_name>
                                                <job_name cast="String" item="key">C:\temp\support6</job_name>
                                                <schedule_name cast="String" item="key">Default</schedule_name>
                                                <domain_name cast="String" item="key" />
                                                <backup_set cast="String" item="key" />
                                                <session cast="String" item="key" />
                                                <jobid2 cast="String" item="key">259805</jobid2>
                                                <queuestart cast="Int" item="key">1347379035</queuestart>
                                                <status cast="String" item="value">started</status>
                                                <starttime cast="Int" item="key">1347379037</starttime>
                                </backupevent>
                                <backupevent data="discontinuous">
                                                <backup_servername cast="String" item="key">w2k3nw763</backup_servername>
                                                <client_name cast="String" item="key">w2k3nw763.wysdm.lab.emc.com</client_name>
                                                <group_name cast="String" item="key">Group4</group_name>
                                                <job_name cast="String" item="key">C:\temp\support</job_name>
                                                <schedule_name cast="String" item="key">Default</schedule_name>
                                                <domain_name cast="String" item="key" />
                                                <backup_set cast="String" item="key" />
                                                <session cast="String" item="key" />
                                                <jobid2 cast="String" item="key">259802</jobid2>
                                                <queuestart cast="Int" item="key">1347379035</queuestart>
                                                <status cast="String" item="value">started</status>
                                                <starttime cast="Int" item="key">1347379037</starttime>
                                </backupevent>
                                <backupevent data="discontinuous">
                                                <backup_servername cast="String" item="key">w2k3nw763</backup_servername>
                                                <client_name cast="String" item="key">w2k3nw763.wysdm.lab.emc.com</client_name>
                                                <group_name cast="String" item="key">Group3</group_name>
                                                <job_name cast="String" item="key">C:\temp\support2</job_name>
                                                <schedule_name cast="String" item="key">Default</schedule_name>
                                                <domain_name cast="String" item="key" />
                                                <backup_set cast="String" item="key" />
                                                <session cast="String" item="key" />
                                                <jobid2 cast="String" item="key">259803</jobid2>
                                                <queuestart cast="Int" item="key">1347379035</queuestart>
                                                <status cast="String" item="value">started</status>
                                                <starttime cast="Int" item="key">1347379037</starttime>
                                </backupevent>
                                <backupevent data="discontinuous">
                                                <backup_servername cast="String" item="key">w2k3nw763</backup_servername>
                                                <client_name cast="String" item="key">w2k3nw763.wysdm.lab.emc.com</client_name>
                                                <group_name cast="String" item="key">Group5</group_name>
                                                <job_name cast="String" item="key">C:\temp\support6</job_name>
                                                <schedule_name cast="String" item="key">Default</schedule_name>
                                                <domain_name cast="String" item="key" />
                                                <backup_set cast="String" item="key" />
                                                <session cast="String" item="key" />
                                                <jobid2 cast="String" item="key">259805</jobid2>
                                                <queuestart cast="Int" item="key">1347379035</queuestart>
                                                <status cast="String" item="value">started</status>
                                                <starttime cast="Int" item="key">1347379037</starttime>
                                </backupevent>
                                <backupevent data="discontinuous">
                                                <backup_servername cast="String" item="key">w2k3nw763</backup_servername>
                                                <client_name cast="String" item="key">w2k3nw763.wysdm.lab.emc.com</client_name>
                                                <group_name cast="String" item="key">Group4</group_name>
                                                <job_name cast="String" item="key">C:\temp\support</job_name>
                                                <schedule_name cast="String" item="key">Default</schedule_name>
                                                <domain_name cast="String" item="key" />
                                                <backup_set cast="String" item="key" />
                                                <session cast="String" item="key" />
                                                <jobid2 cast="String" item="key">259802</jobid2>
                                                <queuestart cast="Int" item="key">1347379035</queuestart>
                                                <status cast="String" item="value">started</status>
                                                <starttime cast="Int" item="key">1347379037</starttime>
                                </backupevent>
                                <backupevent data="discontinuous">
                                                <backup_servername cast="String" item="key">w2k3nw763</backup_servername>
                                                <client_name cast="String" item="key">w2k3nw763.wysdm.lab.emc.com</client_name>
                                                <group_name cast="String" item="key">Group3</group_name>
                                                <job_name cast="String" item="key">C:\temp\support2</job_name>
                                                <schedule_name cast="String" item="key">Default</schedule_name>
                                                <domain_name cast="String" item="key" />
                                                <backup_set cast="String" item="key" />
                                                <session cast="String" item="key" />
                                                <jobid2 cast="String" item="key">259803</jobid2>
                                                <queuestart cast="Int" item="key">1347379035</queuestart>
                                                <status cast="String" item="value">started</status>
                                                <starttime cast="Int" item="key">1347379037</starttime>
                                </backupevent>
                                <backupevent data="discontinuous">
                                                <backup_servername cast="String" item="key">w2k3nw763</backup_servername>
                                                <client_name cast="String" item="key">w2k3nw763.wysdm.lab.emc.com</client_name>
                                                <group_name cast="String" item="key">Group5</group_name>
                                                <job_name cast="String" item="key">C:\temp\support6</job_name>
                                                <schedule_name cast="String" item="key">Default</schedule_name>
                                                <domain_name cast="String" item="key" />
                                                <backup_set cast="String" item="key" />
                                                <session cast="String" item="key" />
                                                <jobid2 cast="String" item="key">259805</jobid2>
                                                <queuestart cast="Int" item="key">1347379035</queuestart>
                                                <status cast="String" item="value">started</status>
                                                <starttime cast="Int" item="key">1347379037</starttime>
                                </backupevent>
                                <backupevent data="discontinuous">
                                                <backup_servername cast="String" item="key">w2k3nw763</backup_servername>
                                                <client_name cast="String" item="key">w2k3nw763.wysdm.lab.emc.com</client_name>
                                                <group_name cast="String" item="key">Group4</group_name>
                                                <job_name cast="String" item="key">C:\temp\support</job_name>
                                                <schedule_name cast="String" item="key">Default</schedule_name>
                                                <domain_name cast="String" item="key" />
                                                <backup_set cast="String" item="key" />
                                                <session cast="String" item="key" />
                                                <jobid2 cast="String" item="key">259802</jobid2>
                                                <queuestart cast="Int" item="key">1347379035</queuestart>
                                                <status cast="String" item="value">started</status>
                                                <starttime cast="Int" item="key">1347379037</starttime>
                                </backupevent>
                                <backupevent data="discontinuous">
                                                <backup_servername cast="String" item="key">w2k3nw763</backup_servername>
                                                <client_name cast="String" item="key">w2k3nw763.wysdm.lab.emc.com</client_name>
                                                <group_name cast="String" item="key">Group3</group_name>
                                                <job_name cast="String" item="key">C:\temp\support2</job_name>
                                                <schedule_name cast="String" item="key">Default</schedule_name>
                                                <domain_name cast="String" item="key" />
                                                <backup_set cast="String" item="key" />
                                                <session cast="String" item="key" />
                                                <jobid2 cast="String" item="key">259803</jobid2>
                                                <queuestart cast="Int" item="key">1347379035</queuestart>
                                                <status cast="String" item="value">started</status>
                                                <starttime cast="Int" item="key">1347379037</starttime>
                                </backupevent>
                                <backupevent data="discontinuous">
                                                <backup_servername cast="String" item="key">w2k3nw763</backup_servername>
                                                <client_name cast="String" item="key">w2k3nw763.wysdm.lab.emc.com</client_name>
                                                <group_name cast="String" item="key">Group5</group_name>
                                                <job_name cast="String" item="key">C:\temp\support6</job_name>
                                                <schedule_name cast="String" item="key">Default</schedule_name>
                                                <domain_name cast="String" item="key" />
                                                <backup_set cast="String" item="key" />
                                                <session cast="String" item="key" />
                                                <jobid2 cast="String" item="key">259805</jobid2>
                                                <queuestart cast="Int" item="key">1347379035</queuestart>
                                                <status cast="String" item="value">started</status>
                                                <starttime cast="Int" item="key">1347379037</starttime>
                                </backupevent>
                                <backupevent data="discontinuous">
                                                <backup_servername cast="String" item="key">w2k3nw763</backup_servername>
                                                <client_name cast="String" item="key">w2k3nw763.wysdm.lab.emc.com</client_name>
                                                <group_name cast="String" item="key">Group4</group_name>
                                                <job_name cast="String" item="key">C:\temp\support</job_name>
                                                <schedule_name cast="String" item="key">Default</schedule_name>
                                                <domain_name cast="String" item="key" />
                                                <backup_set cast="String" item="key" />
                                                <session cast="String" item="key" />
                                                <jobid2 cast="String" item="key">259802</jobid2>
                                                <queuestart cast="Int" item="key">1347379035</queuestart>
                                                <status cast="String" item="value">started</status>
                                                <starttime cast="Int" item="key">1347379037</starttime>
                                </backupevent>
                                <backupevent data="discontinuous">
                                                <backup_servername cast="String" item="key">w2k3nw763</backup_servername>
                                                <client_name cast="String" item="key">w2k3nw763.wysdm.lab.emc.com</client_name>
                                                <group_name cast="String" item="key">Group3</group_name>
                                                <job_name cast="String" item="key">C:\temp\support2</job_name>
                                                <schedule_name cast="String" item="key">Default</schedule_name>
                                                <domain_name cast="String" item="key" />
                                                <backup_set cast="String" item="key" />
                                                <session cast="String" item="key" />
                                                <jobid2 cast="String" item="key">259803</jobid2>
                                                <queuestart cast="Int" item="key">1347379035</queuestart>
                                                <status cast="String" item="value">started</status>
                                                <starttime cast="Int" item="key">1347379037</starttime>
                                </backupevent>
                                <backupevent data="discontinuous">
                                                <backup_servername cast="String" item="key">w2k3nw763</backup_servername>
                                                <client_name cast="String" item="key">w2k3nw763.wysdm.lab.emc.com</client_name>
                                                <group_name cast="String" item="key">Group5</group_name>
                                                <job_name cast="String" item="key">C:\temp\support6</job_name>
                                                <schedule_name cast="String" item="key">Default</schedule_name>
                                                <domain_name cast="String" item="key" />
                                                <backup_set cast="String" item="key" />
                                                <session cast="String" item="key" />
                                                <jobid2 cast="String" item="key">259805</jobid2>
                                                <queuestart cast="Int" item="key">1347379035</queuestart>
                                                <status cast="String" item="value">started</status>
                                                <starttime cast="Int" item="key">1347379037</starttime>
                                </backupevent>
                                <backupevent data="discontinuous">
                                                <backup_servername cast="String" item="key">w2k3nw763</backup_servername>
                                                <client_name cast="String" item="key">w2k3nw763.wysdm.lab.emc.com</client_name>
                                                <group_name cast="String" item="key">Group4</group_name>
                                                <job_name cast="String" item="key">C:\temp\support</job_name>
                                                <schedule_name cast="String" item="key">Default</schedule_name>
                                                <domain_name cast="String" item="key" />
                                                <backup_set cast="String" item="key" />
                                                <session cast="String" item="key" />
                                                <jobid2 cast="String" item="key">259802</jobid2>
                                                <queuestart cast="Int" item="key">1347379035</queuestart>
                                                <status cast="String" item="value">started</status>
                                                <starttime cast="Int" item="key">1347379037</starttime>
                                </backupevent>
                                <backupevent data="discontinuous">
                                                <backup_servername cast="String" item="key">w2k3nw763</backup_servername>
                                                <client_name cast="String" item="key">w2k3nw763.wysdm.lab.emc.com</client_name>
                                                <group_name cast="String" item="key">Group3</group_name>
                                                <job_name cast="String" item="key">C:\temp\support2</job_name>
                                                <schedule_name cast="String" item="key">Default</schedule_name>
                                                <domain_name cast="String" item="key" />
                                                <backup_set cast="String" item="key" />
                                                <session cast="String" item="key" />
                                                <jobid2 cast="String" item="key">259803</jobid2>
                                                <queuestart cast="Int" item="key">1347379035</queuestart>
                                                <status cast="String" item="value">started</status>
                                                <starttime cast="Int" item="key">1347379037</starttime>
                                </backupevent>
                                <backupevent data="discontinuous">
                                                <backup_servername cast="String" item="key">w2k3nw763</backup_servername>
                                                <client_name cast="String" item="key">w2k3nw763.wysdm.lab.emc.com</client_name>
                                                <group_name cast="String" item="key">Group5</group_name>
                                                <job_name cast="String" item="key">C:\temp\support6</job_name>
                                                <schedule_name cast="String" item="key">Default</schedule_name>
                                                <domain_name cast="String" item="key" />
                                                <backup_set cast="String" item="key" />
                                                <session cast="String" item="key" />
                                                <jobid2 cast="String" item="key">259805</jobid2>
                                                <queuestart cast="Int" item="key">1347379035</queuestart>
                                                <status cast="String" item="value">started</status>
                                                <starttime cast="Int" item="key">1347379037</starttime>
                                </backupevent>
                                <backupevent data="discontinuous">
                                                <backup_servername cast="String" item="key">w2k3nw763</backup_servername>
                                                <client_name cast="String" item="key">w2k3nw763.wysdm.lab.emc.com</client_name>
                                                <group_name cast="String" item="key">Group4</group_name>
                                                <job_name cast="String" item="key">C:\temp\support</job_name>
                                                <schedule_name cast="String" item="key">Default</schedule_name>
                                                <domain_name cast="String" item="key" />
                                                <backup_set cast="String" item="key" />
                                                <session cast="String" item="key" />
                                                <jobid2 cast="String" item="key">259802</jobid2>
                                                <queuestart cast="Int" item="key">1347379035</queuestart>
                                                <status cast="String" item="value">started</status>
                                                <starttime cast="Int" item="key">1347379037</starttime>
                                </backupevent>
                                <backupevent data="discontinuous">
                                                <backup_servername cast="String" item="key">w2k3nw763</backup_servername>
                                                <client_name cast="String" item="key">w2k3nw763.wysdm.lab.emc.com</client_name>
                                                <group_name cast="String" item="key">Group3</group_name>
                                                <job_name cast="String" item="key">C:\temp\support2</job_name>
                                                <schedule_name cast="String" item="key">Default</schedule_name>
                                                <domain_name cast="String" item="key" />
                                                <backup_set cast="String" item="key" />
                                                <session cast="String" item="key" />
                                                <jobid2 cast="String" item="key">259803</jobid2>
                                                <queuestart cast="Int" item="key">1347379035</queuestart>
                                                <status cast="String" item="value">started</status>
                                                <starttime cast="Int" item="key">1347379037</starttime>
                                </backupevent>
                                <backupevent data="discontinuous">
                                                <backup_servername cast="String" item="key">w2k3nw763</backup_servername>
                                                <client_name cast="String" item="key">w2k3nw763.wysdm.lab.emc.com</client_name>
                                                <group_name cast="String" item="key">Group5</group_name>
                                                <job_name cast="String" item="key">C:\temp\support6</job_name>
                                                <schedule_name cast="String" item="key">Default</schedule_name>
                                                <domain_name cast="String" item="key" />
                                                <backup_set cast="String" item="key" />
                                                <session cast="String" item="key" />
                                                <jobid2 cast="String" item="key">259805</jobid2>
                                                <queuestart cast="Int" item="key">1347379035</queuestart>
                                                <status cast="String" item="value">started</status>
                                                <starttime cast="Int" item="key">1347379037</starttime>
                                </backupevent>
                                <backupevent data="discontinuous">
                                                <backup_servername cast="String" item="key">w2k3nw763</backup_servername>
                                                <client_name cast="String" item="key">w2k3nw763.wysdm.lab.emc.com</client_name>
                                                <group_name cast="String" item="key">Group4</group_name>
                                                <job_name cast="String" item="key">C:\temp\support</job_name>
                                                <schedule_name cast="String" item="key">Default</schedule_name>
                                                <domain_name cast="String" item="key" />
                                                <backup_set cast="String" item="key" />
                                                <session cast="String" item="key" />
                                                <jobid2 cast="String" item="key">259802</jobid2>
                                                <queuestart cast="Int" item="key">1347379035</queuestart>
                                                <status cast="String" item="value">started</status>
                                                <starttime cast="Int" item="key">1347379037</starttime>
                                </backupevent>
                                <backupevent data="discontinuous">
                                                <backup_servername cast="String" item="key">w2k3nw763</backup_servername>
                                                <client_name cast="String" item="key">w2k3nw763.wysdm.lab.emc.com</client_name>
                                                <group_name cast="String" item="key">Group3</group_name>
                                                <job_name cast="String" item="key">C:\temp\support2</job_name>
                                                <schedule_name cast="String" item="key">Default</schedule_name>
                                                <domain_name cast="String" item="key" />
                                                <backup_set cast="String" item="key" />
                                                <session cast="String" item="key" />
                                                <jobid2 cast="String" item="key">259803</jobid2>
                                                <queuestart cast="Int" item="key">1347379035</queuestart>
                                                <status cast="String" item="value">started</status>
                                                <starttime cast="Int" item="key">1347379037</starttime>
                                </backupevent>
                                <backupevent data="discontinuous">
                                                <backup_servername cast="String" item="key">w2k3nw763</backup_servername>
                                                <client_name cast="String" item="key">w2k3nw763.wysdm.lab.emc.com</client_name>
                                                <group_name cast="String" item="key">Group5</group_name>
                                                <job_name cast="String" item="key">C:\temp\support6</job_name>
                                                <schedule_name cast="String" item="key">Default</schedule_name>
                                                <domain_name cast="String" item="key" />
                                                <backup_set cast="String" item="key" />
                                                <session cast="String" item="key" />
                                                <jobid2 cast="String" item="key">259805</jobid2>
                                                <queuestart cast="Int" item="key">1347379035</queuestart>
                                                <status cast="String" item="value">started</status>
                                                <starttime cast="Int" item="key">1347379037</starttime>
                                </backupevent>
                                <backupevent data="discontinuous">
                                                <backup_servername cast="String" item="key">w2k3nw763</backup_servername>
                                                <client_name cast="String" item="key">w2k3nw763.wysdm.lab.emc.com</client_name>
                                                <group_name cast="String" item="key">Group4</group_name>
                                                <job_name cast="String" item="key">C:\temp\support</job_name>
                                                <schedule_name cast="String" item="key">Default</schedule_name>
                                                <domain_name cast="String" item="key" />
                                                <backup_set cast="String" item="key" />
                                                <session cast="String" item="key" />
                                                <jobid2 cast="String" item="key">259802</jobid2>
                                                <queuestart cast="Int" item="key">1347379035</queuestart>
                                                <status cast="String" item="value">started</status>
                                                <starttime cast="Int" item="key">1347379037</starttime>
                                </backupevent>
                                <backupevent data="discontinuous">
                                                <backup_servername cast="String" item="key">w2k3nw763</backup_servername>
                                                <client_name cast="String" item="key">w2k3nw763.wysdm.lab.emc.com</client_name>
                                                <group_name cast="String" item="key">Group3</group_name>
                                                <job_name cast="String" item="key">C:\temp\support2</job_name>
                                                <schedule_name cast="String" item="key">Default</schedule_name>
                                                <domain_name cast="String" item="key" />
                                                <backup_set cast="String" item="key" />
                                                <session cast="String" item="key" />
                                                <jobid2 cast="String" item="key">259803</jobid2>
                                                <queuestart cast="Int" item="key">1347379035</queuestart>
                                                <status cast="String" item="value">started</status>
                                                <starttime cast="Int" item="key">1347379037</starttime>
                                </backupevent>
                                <backupevent data="discontinuous">
                                                <backup_servername cast="String" item="key">w2k3nw763</backup_servername>
                                                <client_name cast="String" item="key">w2k3nw763.wysdm.lab.emc.com</client_name>
                                                <group_name cast="String" item="key">Group5</group_name>
                                                <job_name cast="String" item="key">C:\temp\support6</job_name>
                                                <schedule_name cast="String" item="key">Default</schedule_name>
                                                <domain_name cast="String" item="key" />
                                                <backup_set cast="String" item="key" />
                                                <session cast="String" item="key" />
                                                <jobid2 cast="String" item="key">259805</jobid2>
                                                <queuestart cast="Int" item="key">1347379035</queuestart>
                                                <status cast="String" item="value">started</status>
                                                <starttime cast="Int" item="key">1347379037</starttime>
                                </backupevent><backupevent data="discontinuous">
                                                <backup_servername cast="String" item="key">w2k3nw763</backup_servername>
                                                <client_name cast="String" item="key">w2k3nw763.wysdm.lab.emc.com</client_name>
                                                <group_name cast="String" item="key">Group4</group_name>
                                                <job_name cast="String" item="key">C:\temp\support</job_name>
                                                <schedule_name cast="String" item="key">Default</schedule_name>
                                                <domain_name cast="String" item="key" />
                                                <backup_set cast="String" item="key" />
                                                <session cast="String" item="key" />
                                                <jobid2 cast="String" item="key">259802</jobid2>
                                                <queuestart cast="Int" item="key">1347379035</queuestart>
                                                <status cast="String" item="value">started</status>
                                                <starttime cast="Int" item="key">1347379037</starttime>
                                </backupevent>
                                <backupevent data="discontinuous">
                                                <backup_servername cast="String" item="key">w2k3nw763</backup_servername>
                                                <client_name cast="String" item="key">w2k3nw763.wysdm.lab.emc.com</client_name>
                                                <group_name cast="String" item="key">Group3</group_name>
                                                <job_name cast="String" item="key">C:\temp\support2</job_name>
                                                <schedule_name cast="String" item="key">Default</schedule_name>
                                                <domain_name cast="String" item="key" />
                                                <backup_set cast="String" item="key" />
                                                <session cast="String" item="key" />
                                                <jobid2 cast="String" item="key">259803</jobid2>
                                                <queuestart cast="Int" item="key">1347379035</queuestart>
                                                <status cast="String" item="value">started</status>
                                                <starttime cast="Int" item="key">1347379037</starttime>
                                </backupevent>
                </REPORT>
</AXMLRESULT> ' > "$tmp2"

echo "
XML INPUT : 
==========="
xml fo "$tmp2"
echo; echo;

curl -k -v -u "$login1":"$paswd1" \
-H "Content-Type: application/vnd.emc.dpa.agent-v1+xml" \
-X POST -T "$tmp2" "$URL_dpa_agent1"/"$agentid"/report 


echo

else

echo
echo "WRONG CHOICE - $agent_id_nk"
echo

fi

rm -rf "$tmprundir"
