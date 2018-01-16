#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

tmp1=/tmp/tmp1_nw.xml
tmp2=/tmp/tmp2_nw.xml

URL1=http://"$HB_DPA":9004/apollo-api/nodes

echo
echo -n "GIVE NETWORKER NODE NAME : "
read -e nodename
echo
echo -n "GIVE NETWORKER NODE NAME'S IP_ADDR : "
read -e ipnodename
echo

echo '      <node version="1" type="NetWorkerBackupClient"> ' > "$tmp1"
echo "        <name>$nodename</name> " >> "$tmp1"
echo "        <displayName>$nodename:NetWorker:$nodename</displayName> " >> "$tmp1"
echo "        <globalName>$nodename:NetWorker:$nodename</globalName> " >> "$tmp1"   
echo "        <creatorType>apollo</creatorType> " >> "$tmp1"
echo "	      <aliases/> " >> "$tmp1"
echo "      </node> " >> "$tmp1"

echo
echo "INPUT XML FOR NODE=NetWorkerBackupClient"
echo "----------------------------------------"
cat "$tmp1"
echo


echo '    <node version="1" type="Host"> ' > "$tmp2"
echo "      <name>$nodename</name> " >> "$tmp2"
echo "      <displayName>$nodename</displayName> " >> "$tmp2"
echo "      <globalName>$nodename</globalName> " >> "$tmp2"
echo "      <creatorType>Apollo</creatorType> " >> "$tmp2"
echo "      <aliases> " >> "$tmp2"
echo "         <alias>$nodename</alias> " >> "$tmp2"
echo "         <alias>$ipnodename</alias> " >> "$tmp2"
echo "      </aliases> " >> "$tmp2"
echo "      <attributes> " >> "$tmp2"
echo "         <assignedAttribute> " >> "$tmp2"
echo "            <attributeName>osinfo</attributeName> " >> "$tmp2"
echo '            <attributeValue class="com.emc.apollo.datamodel.xml.attribute.OSAttributeValueXML" type="OS"> ' >> "$tmp2"
echo "               <family>LINUX</family> " >> "$tmp2"
echo "               <processorType>x64</processorType> " >> "$tmp2"
echo "            </attributeValue> " >> "$tmp2"
echo "            <attributeCategory>Apollo</attributeCategory> " >> "$tmp2"
echo "         </assignedAttribute> " >> "$tmp2"
echo "      </attributes> " >> "$tmp2"
echo "      <timeZone>UTC</timeZone> " >> "$tmp2"
echo "   </node> " >> "$tmp2"

echo
echo "INPUT XML FOR NODE=Host"
echo "-----------------------"
cat "$tmp2"
echo

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -T "$tmp2" "$URL1"

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -T "$tmp1" "$URL1"

echo
rm -rf "$tmp1" "$tmp2"
echo
echo

#    <node version="1" lastModified="2012-07-03T09:25:19.681Z" type="Host">
#      <id>644fd65e-8cc3-40ab-9f2b-666d5a08ab4b</id>
#      <link rel="self" href="http://10.64.213.74:9004/apollo-api/nodes/644fd65e-8cc3-40ab-9f2b-666d5a08ab4b"/>
#      <name>rhel55-networker</name>
#      <displayName>rhel55-networker</displayName>
#      <globalName>rhel55-networker</globalName>
#      <creatorType>Apollo</creatorType>
#      <aliases>
#         <alias>rhel55-networker</alias>
#         <alias>10.64.212.151</alias>
#      </aliases>
#      <attributes>
#         <assignedAttribute lastModified="2012-07-03T09:25:19.681Z">
#            <id>c41b2e1f-f547-4bcd-b6f0-1b413c8cac4c</id>
#            <attributeName>osinfo</attributeName>
#            <link rel="self" href="http://10.64.213.74:9004/apollo-api/nodes/644fd65e-8cc3-40ab-9f2b-666d5a08ab4b/assignedAttributes/osinfo"/>
#            <attributeValue class="com.emc.apollo.datamodel.xml.attribute.OSAttributeValueXML" type="OS">
#               <family>LINUX</family>
#               <processorType>x64</processorType>
#            </attributeValue>
#            <attributeCategory>Apollo</attributeCategory>
#         </assignedAttribute>
#      </attributes>
#      <timeZone>UTC</timeZone>
#   </node>

# <node version="1" lastModified="2012-07-03T17:28:10.592Z" type="NetWorkerBackupClient">
#    <id>36526a77-a9c0-4a4b-91cc-91047ffcf3a9</id>
#    <link rel="self" href="http://10.64.213.74:9004/apollo-api/nodes/36526a77-a9c0-4a4b-91cc-91047ffcf3a9"/>
#    <name>rhel55-networker</name>
#    <displayName>rhel55-networker:NetWorker:rhel55-networker</displayName>
#    <globalName>rhel55-networker:NetWorker:rhel55-networker</globalName>
#    <creatorType>Apollo</creatorType>
#    <aliases/>
# </node>

