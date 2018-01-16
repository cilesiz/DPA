#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/dashboards

echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
<dashboard version="1">
   <name>BackupRosli2</name>
   <description>Default Backup Dashboard Rosli 2</description>
   <system>false</system>
   <viewlets>
      <viewlet version="1">
         <layout row="0" column="0" width="200" height="200"/>
         <viewletTemplate>
            <id>50615e97-2fbe-4f43-8ea3-63c798eed08f</id>
         </viewletTemplate>
         <nodeLinks/>
         <parameters/>
      </viewlet>
      <viewlet version="1">
         <layout row="1" column="1" width="200" height="200"/>
         <viewletTemplate>
            <id>58c42162-7437-44c9-853c-0e65981f7e9f</id>
         </viewletTemplate>
         <nodeLinks/>
         <parameters/>
      </viewlet>
      <viewlet version="1">
         <layout row="1" column="0" width="200" height="200"/>
         <viewletTemplate>
            <id>8d77d101-b292-4c5c-b4be-2f6f8cabc46d</id>
         </viewletTemplate>
         <nodeLinks/>
         <parameters/>
      </viewlet>
      <viewlet version="1">
         <layout row="0" column="1" width="200" height="200"/>
         <viewletTemplate>
            <id>edc9bad5-f13b-4f94-8ae4-1c2e14d36719</id>
         </viewletTemplate>
         <nodeLinks/>
         <parameters/>
      </viewlet>
   </viewlets>
   <authorization>
      <read>
         <userRoles/>
         <users>
	   <user>
               <id>29b08d38-71a2-4762-899a-e0fa78a5769b</id>
           </user>
           <user>
               <id>7b594b07-26e2-42ab-919b-346c48837f14</id>
           </user>
         </users>
      </read>
      <readWrite>
         <userRoles/>
         <users>
           <user>
               <id>29b08d38-71a2-4762-899a-e0fa78a5769b</id>
           </user>
           <user>
               <id>7b594b07-26e2-42ab-919b-346c48837f14</id>
           </user>
         </users>
      </readWrite>
   </authorization>
</dashboard>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp1.txt 

