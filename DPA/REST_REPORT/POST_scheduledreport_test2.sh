#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/scheduledreport

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
<scheduledReport version="1">
    <description>I am a comment</description>
    <!-- Reports, windows and users are mandatory. Either ID or name can be specified when creating/updating -->
    <!-- The server response will return _both_ the id and name -->
    <report><id></id><name></name></report>
    <window><id></id><name></name></window>
    <!-- For user, does the UI want 'name' and or 'externalName'? -->
    <user><id></id><logonName></logonName></user>
    <!-- schedule may be empty, inferring that the scheduled report is not active. If supplied, either id or name can be specified -->
    <schedule><id></id><name></name></schedule>
    <preScript></preScript>
    <generateIfEmpty>true|false</generateIfEmpty>
    <publications>
        <publication>
            <publicationMethod>file</publicationMethod>
            <formatType>XML</formatType>
            <pageOrientation>Portrait</pageOrientation>
            <pageSize>A4</pageSize>
            <fitContent>false</fitContent>
            <postScript></postScript>
            <styleTemplate></styleTemplate>
            <!-- fileName and notifyByMail only applicable when publicationMethod=file-->
            <fileName></fileName>
            <notifyByMail></notifyByMail>
            <!-- mailTo and mailSubject applicable when publicationMethod=email OR notifyByMail=true-->
            <mailTo></mailTo>
            <mailSubject></mailSubject>
            <!-- emailBehavior only applicable when publicationMethod=email -->
            <emailBehavior>attach|embed</emailBehavior>
        </publication>
    </publications>
    <nodeLinks>
        <!-- multiple node links can exist. Each node link should be a full path to the node from the Root node so that reports can be run with a full node ancestral context. NOTE: The report engine will still support a single id that doesnt have a full ancestry path, however i believe the current requirements are to specify the full path -->
        <nodeLink>
            <!-- NOTE: On writing/saving, only id needs to be specified -->
            <id>00000000-0000-0000-0000-000000000001</id>
            <child>
                <id>8ad04346-9abd-4466-8bd8-05306b63519d</id>
                <child>
                    <id>307c9831-e611-453d-bbb8-89ff3e0248b7</id>
                    <child>
                        <id>91bdc85c-f18b-44e6-af7b-cec02625b00d</id>
                    </child>
                </child>
            </child>
        </nodeLink>
            <nodeLink type="Group">
            <!-- NOTE: On a GET, all of id, name and type are returned -->
               <id>00000000-0000-0000-0000-000000000001</id>
               <name>Root</name>
               <child type="Group">
                  <id>8ad04346-9abd-4466-8bd8-05306b63519d</id>
                  <name>Configuration</name>
                  <child type="Group">
                     <id>307c9831-e611-453d-bbb8-89ff3e0248b7</id>
                     <name>Servers</name>
                     <child type="Group">
                        <id>91bdc85c-f18b-44e6-af7b-cec02625b00d</id>
                        <name>DPA Server</name>
                     </child>
                  </child>
               </child>
            </nodeLink>
    </nodeLinks>
</scheduledReport>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp1.txt 

