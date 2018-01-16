#!/bin/bash

HB_DPA=10.64.205.162
user1=sst4
pswd1=sst4

URL1=http://"$HB_DPA":9004/dpa-api/server/settings

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X PUT -d '
<serverSettings version="1">
  <timeout>60</timeout>
  <binaryMultiplier>false</binaryMultiplier>
  <port>25</port>
  <mailFrom>haha.hehe@hoho.com</mailFrom>
  <mailServer>apasajela.name.hoho.com</mailServer>
</serverSettings>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp1.txt 
