#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib

choose_server

echo "$dpaserver:9003:apollo:apollosuperuser:3g1;23#6hFd 05(}c8/F5rB2lL1J79" > /root/.pgpass
chmod 0600 /root/.pgpass

####################

echo -n "
Choose command to run :
1) \"select * from apollo.agentless_discovery_settings;\"
2) ALL NODES \"select * from apollo.node;\"
3) NODES \"select f_name,f_display_name,f_isagent from apollo.node;\"
4) PROCESS INFO \"select * from apollo.process_info;\"
5) PROCESS \"select f_host,f_id,f_key from apollo.process_info;\"
6) USERS \"select * from apollo.user;\"
7) \"select f_display_name,f_id,f_logon_name from apollo.user;\"
8) \"select f_logon_name,f_password from apollo.user;\"
9) \"select f_name,f_id,f_lastmodified,f_expiry from dpa.license;\"
10) APOLLO VERSION \"select * from apollo.apollo_version;\"
11) DPA VERSION \"select * from dpa.dpa_version;\"
12) REQUEST HIST \"select * from dpa.request_history;\"
13) REQUEST HIST \"select f_id,f_lastmodified,f_agent_id,f_function,f_module,f_status,f_target_id from dpa.request_history;\"
14) \"select * from dpa.groupevent;\"
15) \"select * from dpa.backupevent;\"
16) \"select * from dpa.reporterjob where f_run_origin='smartGroup';\"

Command to run [ 1 - 14 ] : "
read cmdnk

#####################

if [ x"$cmdnk" == x1 ]; then
cmdrun="select * from apollo.agentless_discovery_settings;"
elif [ x"$cmdnk" == x2 ]; then
cmdrun="select * from apollo.node;"
elif [ x"$cmdnk" == x3 ]; then
cmdrun="select f_name,f_display_name,f_isagent from apollo.node;"
elif [ x"$cmdnk" == x4 ]; then
cmdrun="select * from apollo.process_info;"
elif [ x"$cmdnk" == x5 ]; then
cmdrun="select f_host,f_id,f_key from apollo.process_info;"
elif [ x"$cmdnk" == x6 ]; then
cmdrun="select * from apollo.user;"
elif [ x"$cmdnk" == x7 ]; then
cmdrun="select f_display_name,f_id,f_logon_name from apollo.user;"
elif [ x"$cmdnk" == x8 ]; then
cmdrun="select f_logon_name,f_password from apollo.user;"
elif [ x"$cmdnk" == x9 ]; then
cmdrun="select f_name,f_id,f_lastmodified,f_expiry from dpa.license;"
elif [ x"$cmdnk" == x10 ]; then
cmdrun="select * from apollo.apollo_version;"
elif [ x"$cmdnk" == x11 ]; then
cmdrun="select * from dpa.dpa_version;"
elif [ x"$cmdnk" == x12 ]; then
cmdrun="select * from dpa.request_history;"
elif [ x"$cmdnk" == x13 ]; then
cmdrun="select f_id,f_lastmodified,f_agent_id,f_function,f_module,f_status,f_target_id from dpa.request_history;"
elif [ x"$cmdnk" == x14 ]; then
cmdrun="select * from dpa.groupevent;"
elif [ x"$cmdnk" == x15 ]; then
cmdrun="select * from dpa.backupevent;"
elif [ x"$cmdnk" == x16 ]; then
cmdrun="select * from dpa.reporterjob where f_run_origin='smartGroup';"
else
echo "
Wrong choice = $cmdnk
"

fi

echo; echo 
echo "psql --host $dpaserver --port 9003 --username apollosuperuser -d apollo -c \$CMD"
echo "	\$CMD = \"$cmdrun\" "
echo; echo

/usr/bin/psql --host "$dpaserver" --port 9003 --username apollosuperuser -d apollo -c "$cmdrun"

echo; echo
