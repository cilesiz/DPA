#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib
source /root/rosli/61DPA/LIB/listing_id.lib

choose_server
listing_url

# URL_dpa_dscvry=http://"$HB_DPA"/dpa-api/discovery
# URL_dpa_dsctst=http://"$HB_DPA"/dpa-api/discoverytests

tmp1="$tmprundir"/tmp1.xml
tmp2="$tmprundir"/tmp2.txt
tmp3="$tmprundir"/tmp3.txt
tmpfinal="$tmprundir"/tmpfinal.xml

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_apollo_nod" > "$tmp1"

# depnodetype

echo "
#Backup Application#
#1#ArcServe#
#2#CommVault#
#3#Avamar#
#4#NetWorker#
#5#DataProtector#
#6#TSM#
#7#ACSLS#
#8#BackupExec#
#9#NetBackup#
#10#PureDisk#

#Database#
#11#MSSQLDatabase#
#12#OracleDatabase#
#13#PostgreSQLDatabase#

#Host
#14#Host#

#Primary Storage#
#15#Celerra#
#16#VPlexManagement#
#17#Vnx#
#18#RecoverPoint#
#19#HPEVA#

#Protection Storage#
#20#DataDomain#
#21#EDL#
#22#NearStore#
#23#TapeLibrary#

#Switch#
#24#FibreChannel#
#25#InfinibandPort#
#26#XSIGOSwitch#

#VM#
#27#VCenter# " > "$tmp2"

cat "$tmp2" | awk -F"#" '{print $2"\t"$3}'

echo
echo -n "Choose Node Type : "
read -e nodenak

cat "$tmp2" | grep -i "#$nodenak#" > "$tmp3"

depnodetype=`cat "$tmp3" | awk -F# '{print $3}'`

### 

echo -n "
HOST TO DISCOVER (valid FQDN or IP) : "
read -e hosttodisccover

echo -n "Host Monitoring (default=false) : "
read -e hostmonfalse
if [ x"$hostmonfalse" != xtrue ]; then
hostmonfalse=false
fi

echo -n "Replication Monitoring (default=false) : "
read -e repmonfalse
if [ x"$repmonfalse" != xtrue ]; then
repmonfalse=false
fi

# rmtcollector

xml sel -t -m 'nodes/node[@type="Host"]' -v numField -o "#" -v id -v numField -o "#" -v displayName -v numField -o "#" -n "$tmp1" | grep "#" | awk -F"#" '{print "#"NR$0}' > "$tmp2"

echo; echo

cat "$tmp2" | awk -F"#" '{print $2"\t"$3"\t"$4}'

echo
echo -n "Choose Remote Collector [No/Node ID/Display Name] : "
read -e nodenak

cat "$tmp2" | grep -i "#$nodenak#" > "$tmp3"

rmtcollector=`cat "$tmp3" | awk -F# '{print $4}'`

# grouphost

xml sel -t -m 'nodes/node[@type="Group"]' -v numField -o "#" -v id -v numField -o "#" -v displayName -v numField -o "#" -n "$tmp1" | grep "#" | awk -F"#" '{print "#"NR$0}' > "$tmp2"

echo; echo

cat "$tmp2" | awk -F"#" '{print $2"\t"$3"\t"$4}'

echo
echo -n "Choose Group for Host [No/Node ID/Display Name] : "
read -e nodenak

cat "$tmp2" | grep -i "#$nodenak#" > "$tmp3"

grouphost=`cat "$tmp3" | awk -F# '{print $4}'`

# credential

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_apollo_crd" > "$tmp1"

xml sel -t -m credentials/credential -v numField -o "#" -v id -v numField -o "#" -v name -v numField -o "#" -n "$tmp1" | grep "#" | awk -F"#" '{print "#"NR$0}' > "$tmp2"

echo; echo

cat "$tmp2" | awk -F"#" '{print $2"\t"$3"\t"$4}'

echo
echo -n "Choose Credential [No/Cred ID/Name] : "
read -e nodenak

cat "$tmp2" | grep -i "#$nodenak#" > "$tmp3"

credential=`cat "$tmp3" | awk -F# '{print $4}'`

######

echo
echo

echo '<discoveryJob>
  <task>
    <primaryObject exists="false">
      <node version="1" type="Host"> ' >  "$tmpfinal"
echo "        <name>$hosttodisccover</name>
        <displayName>$hosttodisccover</displayName> 
      </node> " >> "$tmpfinal"
echo "     <dataCollectionParameter>
        <hostMonitoring>$hostmonfalse</hostMonitoring>
        <replicationMonitoring>$repmonfalse</replicationMonitoring> " >> "$tmpfinal"
echo '        <agent local="false">
        <node type="Host"> ' >> "$tmpfinal"
echo "                <name>$rmtcollector</name>
        </node>
        </agent>
     </dataCollectionParameter> " >> "$tmpfinal"
echo '     <parents>
      <parent primary="true">
         <node type="Group"> ' >> "$tmpfinal"
echo "         <name>$grouphost</name>
         </node>
      </parent>
     </parents>
    </primaryObject> " >> "$tmpfinal"
echo "    <dependentObjects>
      <dependentObject> " >> "$tmpfinal"
echo "        <node version=\"1\" type=\"$depnodetype\">
          <displayName>$depnodetype</displayName>
        </node> " >> "$tmpfinal"
echo '        <dataCollectionParameter>
          <credential version="1"> ' >> "$tmpfinal"
echo "            <name>$credential</name>
          </credential>
        </dataCollectionParameter>
      </dependentObject>
    </dependentObjects>
  </task>
</discoveryJob> " >> "$tmpfinal"

echo "XML INPUT
========="
xml fo "$tmpfinal"
echo "
URL = $URL_dpa_dsctst
"

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X POST -T "$tmpfinal" "$URL_dpa_dsctst" > "$tmp1" 2>&1

dos2unix "$tmp1"

cat "$tmp1"

idresult=`cat "$tmp1" | grep discoverytests | grep requestteststatus | awk -F"/" '{print $NF}'`

echo "
GET RESULT
==========
ID = $idresult
GET URL = $URL_dpa_dscstt/$idresult
"
confirmrest

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_dpa_dscstt"/"$idresult" > "$tmp2"

echo; echo
cat "$tmp2"

reqresult=`xml sel -t -m RequestTestResult -v success "$tmp2"`
echo "

SUCCESS = $reqresult
"

if [ x"$reqresult" == xtrue ]; then

echo "
CREATE DISCOVERY NODE :

POST $URL_dpa_dscvry
"
confirmrest
curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X POST -T "$tmpfinal" "$URL_dpa_dscvry"
echo
else
echo
echo "CANNOT CREATE NODE $hosttodisccover"
echo
fi
rm -rf "$tmprundir"
