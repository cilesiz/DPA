#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/license

echo
echo "BEFORE ADD LICENSE"
echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"
echo
echo
echo "ADD LICENSE"
echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -d '
   <license>
      <name>DPA base license for EMC (405865) - EXPIRED 04June 2012</name>
      <code>EMC-DPA-ENT</code>
      <type>SysDM V1.1 License</type>
      <instances>1</instances>
      <expiry>1354156460</expiry>
      <holder>EMC Corporation</holder>
      <featureSet>0</featureSet>
      <sig>MCwCFFOyxhziyfMFIdQhQsvCTAFyJCkdAhQLLkRAI5t/UttlwFqZ3oiJSfUHtw==</sig>
   </license>
' -X POST "$URL1"

echo
echo
echo "AFTER ADD LICENSE"
echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1"
echo
echo

#       <id>8665399f-387d-493d-bbb9-8ad1e4d130ab</id>
#      <sig>MCwCFEEdE0F6Y3PccXL68+R7WAO8oxKNAhR4kWuzerDpmgG8R04sFo+EY2aUAg==</sig>
#
# Old DPA server base license
#
#    <license>
#       <name>DPA base license for emc (269089)</name>
#       <code>EMC-DPA-ENT</code>
#       <type>SysDM V1.1 License</type>
#       <instances>1</instances>
#       <expiry>1333610100</expiry>
#       <holder>EMC Corporation</holder>
#       <featureSet>0</featureSet>
#       <sig>MCwCFEEdE0F6Y3PccXL68+R7WAO8oxKNAhR4kWuzerDpmgG8R04sFo+EY2aUAg==</sig>
#    </license>
#
