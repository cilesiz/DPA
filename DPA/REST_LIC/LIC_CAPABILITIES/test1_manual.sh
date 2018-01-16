#!/bin/bash

pwd1=`pwd`
HB_DPA1=10.64.213.74
HB_DPA2=rhel55-hbs.homebase.corp.emc.com
user1=administrator
pswd1=administrator

#### TEMPORARY FILES SECTION
masa=`date +%Y%m%d_%H%M%S`
tmp3=/tmp/tmp3_"$masa".xml

#### URL
URL2=http://"$HB_DPA1":9004/dpa-api/agent/"$HB_DPA2"/report

# read -e nodename
nodename=testrosli2.example.apersajer.com
# nodename=testrosli2

# cat sample_celerra_config_report.xml | sed -e "s/hostname=\"uncle-mgmt\"/hostname=\"$nodename\"/g" > "$tmp3"
cat sample_celerra_config_report.xml | sed -e "s/></>\n</g" | sed -e "s/hostname=\"uncle-mgmt\"/hostname=\"$nodename\"/g" > "$tmp3"

##### CHANGE SAMPLE CELERRA CONFIG XML TO USE NEWLY CREATE NODENAME

echo
curl -v -u "$user1":"$pswd1" -H "Content-Type: application/vnd.emc.dpa.agent-v1+xml" -X POST -T "$tmp3" "$URL2"
echo

# rm -rf "$tmp1" "$tmp2" "$tmp3"
