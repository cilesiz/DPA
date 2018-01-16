#!/bin/bash

HB_DPA=10.64.205.162
user1=emc.dpa.agent.logon
pswd1=4BtByG4rTnNcQpZr!
tmp1=/tmp/tmp_file.xml
URL1=http://"$HB_DPA":9004/dpa-api/agent/registration

echo
echo -n "How many agents : "
read -e brp1
echo
echo -n "Agent main name : "
read -e siapagent
echo
echo "Choose agent version : "
echo "1) Version 5.8 "
echo "2) Version 6.0 "
echo -n "Your choice [1/2] : "
read -e versio

if [ $versio -gt 0 -a $versio -eq 1 2> /dev/null ]
then

for berapa in `seq 1 1 "$brp1"`
do
hostname="$siapagent"_"$berapa"

echo '<registration version="1">' > "$tmp1"
echo "<!-- if an agent registration request is sent for an existing agent(to update it's configuration), the agent id will be sent.-->" >> "$tmp1"
echo " <clienttype>agent</clienttype>" >> "$tmp1"  
echo "  <hostnames>" >> "$tmp1"
echo "    <name>$hostname</name>" >> "$tmp1"
echo "    <name>$siapagent-alias-$berapa</name>" >> "$tmp1"
echo "    <name>10.64.2.$berapa</name>" >> "$tmp1"
echo "  </hostnames>" >> "$tmp1"
echo "  <productversion>" >> "$tmp1"
echo "    <major>5</major>" >> "$tmp1"
echo "    <minor>8</minor>" >> "$tmp1"
echo "    <maintenance>1</maintenance>" >> "$tmp1"
echo "    <build>5991</build>" >> "$tmp1"
echo "  </productversion>" >> "$tmp1"
echo "  <config>" >> "$tmp1"
echo "    <port>3741</port>" >> "$tmp1"
echo "    <platform>windows</platform>" >> "$tmp1"
echo "    <platformProcessor>x64</platformProcessor>" >> "$tmp1"
echo "    <concurrency>5</concurrency>" >> "$tmp1"
echo "    <loglevel>Info</loglevel>" >> "$tmp1"
echo "    <logfile>C:\log\dpa58\mylogfile.log</logfile>" >> "$tmp1"
echo "    <maxlogfilesize>5</maxlogfilesize>" >> "$tmp1"
echo "    <maxlogfiles>10</maxlogfiles>" >> "$tmp1"
echo "    <maxfwdqueuelength>100</maxfwdqueuelength>" >> "$tmp1"
echo "    <maxfwdqueuesize>10</maxfwdqueuesize>" >> "$tmp1"
echo "    <key>asdf234kadsfla</key> <!-- secret key used by server when sending agent commands -->" >> "$tmp1"
echo "  </config>" >> "$tmp1"
echo "</registration>" >> "$tmp1"

echo "Put $hostname to DPA server $HB_DPA"
echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X PUT -T "$tmp1" "$URL1"
echo

rm -rf "$tmp1"

done

else

echo

curl -u administrator:administrator -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET http://"$HB_DPA":9004/dpa-api/serverstatus > tmp_server.txt
# nowbld=`cat tmp_server.txt | grep -i build | awk -F">" '{print $2}' |  awk -F"<" '{print $1}'`
nowbld=9999
rm -rf tmp_server.txt
echo

echo "BUILD=$nowbld"

for berapa in `seq 1 1 "$brp1"`
do
hostname="$siapagent"_"$berapa"

echo '<registration version="1">' > "$tmp1"
echo "<!-- if an agent registration request is sent for an existing agent(to update it's configuration), the agent id will be sent.-->" >> "$tmp1"
echo " <clienttype>agent</clienttype>" >> "$tmp1"
echo "  <hostnames>" >> "$tmp1"
echo "    <name>$hostname</name>" >> "$tmp1"
echo "    <name>$siapagent-alias-$berapa</name>" >> "$tmp1"
echo "    <name>10.64.2.$berapa</name>" >> "$tmp1"
echo "  </hostnames>" >> "$tmp1"
echo "  <productversion>" >> "$tmp1"
echo "    <major>6</major>" >> "$tmp1"
echo "    <minor>0</minor>" >> "$tmp1"
echo "    <maintenance>0</maintenance>" >> "$tmp1"
echo "    <build>$nowbld</build> " >> "$tmp1"
echo "  </productversion>" >> "$tmp1"
echo "  <config>" >> "$tmp1"
echo "    <port>3741</port>" >> "$tmp1"
echo "    <platform>windows</platform>" >> "$tmp1"
echo "    <platformProcessor>x64</platformProcessor>" >> "$tmp1"
echo "    <concurrency>5</concurrency>" >> "$tmp1"
echo "    <loglevel>Info</loglevel>" >> "$tmp1"
echo "    <logfile>C:\log\dpa60\mylogfile.log</logfile>" >> "$tmp1"
echo "    <maxlogfilesize>5</maxlogfilesize>" >> "$tmp1"
echo "    <maxlogfiles>10</maxlogfiles>" >> "$tmp1"
echo "    <maxfwdqueuelength>100</maxfwdqueuelength>" >> "$tmp1"
echo "    <maxfwdqueuesize>10</maxfwdqueuesize>" >> "$tmp1"
echo "    <key>asdf234kadsfla</key> <!-- secret key used by server when sending agent commands -->" >> "$tmp1"
echo "  </config>" >> "$tmp1"
echo "</registration>" >> "$tmp1"

echo "Run $berapa - PUT $hostname to DPA server $HB_DPA"
echo
curl -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X PUT -T "$tmp1" "$URL1"
echo

rm -rf "$tmp1"

done

fi
