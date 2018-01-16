#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib

choose_server

echo "$dpaserver:9003:apollo:apollosuperuser:3g1;23#6hFd 05(}c8/F5rB2lL1J79" > /root/.pgpass
chmod 0600 /root/.pgpass

echo -n "
Choose command to run :
1) \"select * from dpa.request_default;\"
2) \"select * from dpa.request_option_default;\"
3) \"select * from dpa.request_assigned;\"
4) \"select f_id,f_agent_id,f_function,f_module,f_overridden_agent_type,f_target_id from dpa.request_assigned;\"
5) \"select f_agent_id,f_target_id,f_function,f_module,f_overridden_agent_type,f_overridden_credential_id,f_overridden_frequency_type,f_overridden_period,f_overridden_proxy_id,f_overridden_retention,f_overridden_schedule_id from dpa.request_assigned;\"
6) \"select f_function,f_module,f_overridden_agent_type,f_overridden_credential_id from dpa.request_assigned;\"
7) \"select f_agent_id,f_function,f_module,f_overridden_agent_type,f_overridden_credential_id from dpa.request_assigned;\"
8) \"select f_agent_id,f_function,f_module,f_overridden_agent_type,f_overridden_credential_id,f_target_id from dpa.request_assigned;\"
9) \"select f_agent_id,f_function,f_module,f_agent_type,f_frequency_type,f_period,f_retention from dpa.request_default;\"
10) \"select * from dpa.request_option_default;\"
11) \"select * from apollo.quartz_job_details;\"

Command to run [ 1 - 7 ] : "
read cmdnk

if [ x"$cmdnk" == x1 ]; then
cmdrun="select * from dpa.request_default;"
elif [ x"$cmdnk" == x2 ]; then
cmdrun="select * from dpa.request_option_default;"
elif [ x"$cmdnk" == x3 ]; then
cmdrun="select * from dpa.request_assigned;"
elif [ x"$cmdnk" == x4 ]; then
cmdrun="select f_id,f_agent_id,f_function,f_module,f_overridden_agent_type,f_target_id from dpa.request_assigned;"
elif [ x"$cmdnk" == x5 ]; then
cmdrun="select f_agent_id,f_target_id,f_function,f_module,f_overridden_agent_type,f_overridden_credential_id,f_overridden_frequency_type,f_overridden_period,f_overridden_proxy_id,f_overridden_retention,f_overridden_schedule_id from dpa.request_assigned;"
elif [ x"$cmdnk" == x6 ]; then
cmdrun="select f_function,f_module,f_overridden_agent_type,f_overridden_credential_id from dpa.request_assigned;"
elif [ x"$cmdnk" == x7 ]; then
cmdrun="select f_agent_id,f_function,f_module,f_overridden_agent_type,f_overridden_credential_id from dpa.request_assigned;"
elif [ x"$cmdnk" == x8 ]; then
cmdrun="select f_agent_id,f_function,f_module,f_overridden_agent_type,f_overridden_credential_id,f_target_id from dpa.request_assigned;"
elif [ x"$cmdnk" == x9 ]; then
cmdrun="select f_agent_id,f_function,f_module,f_agent_type,f_frequency_type,f_period,f_retention from dpa.request_default;"
elif [ x"$cmdnk" == x10 ]; then
cmdrun="select * from dpa.request_option_default;"
elif [ x"$cmdnk" == x11 ]; then
cmdrun="select sched_name,job_name,job_group,description,is_durable,is_nonconcurrent,is_update_data,requests_recovery from apollo.quartz_job_details;"
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
