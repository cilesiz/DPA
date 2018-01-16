#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/dashboards

echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
<dashboard version="1">
   <name>Test Rosli</name>
   <description>Default Backup Dashboard Rosli</description>
   <system>true</system>
   <viewlets>
      <viewlet version="1">
         <layout row="0" column="1" width="200" height="200"/>
         <viewletTemplate>
            <id>edc9bad5-f13b-4f94-8ae4-1c2e14d36719</id>
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
         <layout row="1" column="1" width="200" height="200"/>
         <viewletTemplate>
            <id>58c42162-7437-44c9-853c-0e65981f7e9f</id>
         </viewletTemplate>
         <nodeLinks/>
         <parameters/>
      </viewlet>
      <viewlet version="1" lastModified="2012-03-05T11:34:34.195Z">
         <id>7e886e89-b517-4a9c-8b00-0631b2413d72</id>
         <layout row="0" column="0" width="200" height="200"/>
         <viewletTemplate>
            <id>50615e97-2fbe-4f43-8ea3-63c798eed08f</id>
         </viewletTemplate>
         <nodeLinks/>
         <parameters/>
      </viewlet>
   </viewlets>
   <authorization>
      <read>
         <users/>
         <userRoles>
            <userRole>
               <id>36ad0bd5-dfa6-47c3-bf7b-a48140c93a8f</id>
            </userRole>
         </userRoles>
      </read>
      <readWrite>
         <users/>
         <userRoles>
            <userRole>
               <id>36ad0bd5-dfa6-47c3-bf7b-a48140c93a8f</id>
            </userRole>
         </userRoles>
      </readWrite>
   </authorization>
</dashboard>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp1.txt 

