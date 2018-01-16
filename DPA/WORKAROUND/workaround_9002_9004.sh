#!/bin/bash

pwd1=/root/rosli/DPA
masa=`date +%H_%M_%S`
tmpdpa=tmp_dpa_ws_"$masa"

service dpa stop

mkdir "$pwd1"/"$tmpdpa"
mkdir "$pwd1"/"$tmpdpa"_bak
cp /opt/emc/dpa/services/applications/dpa.ear "$pwd1"/"$tmpdpa"_bak
unzip /opt/emc/dpa/services/applications/dpa.ear -d "$pwd1"/"$tmpdpa"

cp "$pwd1"/"$tmpdpa"/dpa-restapi-war-6.0-SNAPSHOT.war "$pwd1"/"$tmpdpa"_bak
mkdir "$pwd1"/tmp_dpa_1
cd "$pwd1"/"$tmpdpa" && unzip "$pwd1"/"$tmpdpa"/dpa-restapi-war-6.0-SNAPSHOT.war -d "$pwd1"/tmp_dpa_1

cd "$pwd1"/tmp_dpa_1/WEB-INF && \
cp web.xml "$pwd1"/"$tmpdpa"_bak/web.xml
sed -i 's/<user-data-constraint>/<!-- <user-data-constraint>/g' web.xml && \
sed -i 's/<\/user-data-constraint>/<\/user-data-constraint> -->/g' web.xml
cp web.xml "$pwd1"/"$tmpdpa"_bak/web.xml_modify

cd "$pwd1"/tmp_dpa_1 && zip -r "$pwd1"/"$tmpdpa"/dpa-restapi-war-6.0-SNAPSHOT.war *
cp "$pwd1"/"$tmpdpa"/dpa-restapi-war-6.0-SNAPSHOT.war "$pwd1"/"$tmpdpa"_bak/dpa-restapi-war-6.0-SNAPSHOT.war_modify

cd "$pwd1"/"$tmpdpa" && zip -r /opt/emc/dpa/services/applications/dpa.ear * 
cp /opt/emc/dpa/services/applications/dpa.ear "$pwd1"/"$tmpdpa"_bak/dpa.ear_modify

# rm -rf "$pwd1"/tmp_dpa_1 "$pwd1"/"$tmpdpa"

cp /opt/emc/dpa/services/standalone/configuration/standalone.xml "$pwd1"/"$tmpdpa"_bak
sed -i 's/port="9004"/port="9002FOUR"/g' /opt/emc/dpa/services/standalone/configuration/standalone.xml
sed -i 's/port="9002"/port="9004"/g' /opt/emc/dpa/services/standalone/configuration/standalone.xml
sed -i 's/port="9002FOUR"/port="9002"/g' /opt/emc/dpa/services/standalone/configuration/standalone.xml
cp /opt/emc/dpa/services/standalone/configuration/standalone.xml "$pwd1"/"$tmpdpa"_bak/standalone.xml_modify

service dpa start
