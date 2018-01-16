#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator
hostname1=uncle-mgmt.wysdm.lab.emc.com

URL1=http://"$HB_DPA":9004/dpa-api/agent/"$hostname1"/report

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.dpa.agent-v1+xml" -H "Content-Type: application/vnd.emc.dpa.agent-v1+xml" -X POST -T /root/rosli/DPA/REST_DISCOVERY/celerra_config.xml "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp1.txt 
