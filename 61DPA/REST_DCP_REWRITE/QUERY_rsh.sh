#!/bin/bash

echo -n "
Pilih server
1) rt-suse11x64 (10.64.255.170)
2) rt-centosx64 (10.64.205.107)
o) Other (give IP)

Server [ 1 / 2 ] : "
read -e dpank

if [ x"$dpank" == x1 -o x"$dpank" == x2 -o x"$dpank" == xo ]; then

if [ x"$dpank" == x1 ]; then
dpaserver=10.64.255.170
elif [ x"$dpank" == x2 ]; then
dpaserver=10.64.205.107
elif [ x"$dpank" == xo ]; then
echo -n "
Give IP : "
read -e dpaserver
fi

echo; echo "DPASERVER = $dpaserver"; echo

chkcfgdpa=`rsh "$dpaserver" -l root ls -al /etc/init.d/\*agent\* | grep -i dpa | wc -l`
if [ $chkcfgdpa -eq 1 ]; then
wheredpa=`rsh "$dpaserver" -l root ls -al /etc/init.d/\*agent\* | grep -i dpa | awk '{print $NF}' | sed -e "s/\/agent\/etc\/dpa//g"`
else
wheredpa=/opt/emc/dpa
fi

# echo; echo "WHEREDPA = $wheredpa"; echo

echo -n "
Choose command to run :
1) dpa ds query \"select * from dpa.request_default;\"
2) dpa ds query \"select * from dpa.request_option_default;\"
3) dpa ds query \"select * from dpa.request_assigned;\"
4) dpa ds query \"select f_id,f_agent_id,f_function,f_module,f_overridden_agent_type,f_target_id from dpa.request_assigned;\"
5) dpa ds query \"select f_agent_id,f_target_id,f_function,f_module,f_overridden_agent_type,f_overridden_credential_id,f_overridden_frequency_type,f_overridden_period,f_overridden_proxy_id,f_overridden_retention,f_overridden_schedule_id from dpa.request_assigned;\"
6) dpa ds query \"select f_function,f_module,f_overridden_agent_type,f_overridden_credential_id from dpa.request_assigned;\"
7) dpa ds query \"select f_agent_id,f_function,f_module,f_overridden_agent_type,f_overridden_credential_id from dpa.request_assigned;\"
8) dpa ds query \"select f_agent_id,f_function,f_module,f_overridden_agent_type,f_overridden_credential_id,f_target_id from dpa.request_assigned;\"

Command to run [ 1 - 7 ] : "
read cmdnk

if [ x"$cmdnk" == x1 ]; then
cmdrun='"select * from dpa.request_default;"'
elif [ x"$cmdnk" == x2 ]; then
cmdrun='"select * from dpa.request_option_default;"'
elif [ x"$cmdnk" == x3 ]; then
cmdrun='"select * from dpa.request_assigned;"'
elif [ x"$cmdnk" == x4 ]; then
cmdrun='"select f_id,f_agent_id,f_function,f_module,f_overridden_agent_type,f_target_id from dpa.request_assigned;"'
elif [ x"$cmdnk" == x5 ]; then
cmdrun='"select f_agent_id,f_target_id,f_function,f_module,f_overridden_agent_type,f_overridden_credential_id,f_overridden_frequency_type,f_overridden_period,f_overridden_proxy_id,f_overridden_retention,f_overridden_schedule_id from dpa.request_assigned;"'
elif [ x"$cmdnk" == x6 ]; then
cmdrun='"select f_function,f_module,f_overridden_agent_type,f_overridden_credential_id from dpa.request_assigned;"'
elif [ x"$cmdnk" == x7 ]; then
cmdrun='"select f_agent_id,f_function,f_module,f_overridden_agent_type,f_overridden_credential_id from dpa.request_assigned;"'
elif [ x"$cmdnk" == x8 ]; then
cmdrun="select f_agent_id,f_function,f_module,f_overridden_agent_type,f_overridden_credential_id,f_target_id from dpa.request_assigned;"
else
echo "
Wrong choice = $cmdnk
"

fi

rsh "$dpaserver" -l root "$wheredpa"/services/bin/dpa.sh ds query "$cmdrun"

else
echo "
Wrong choice = $dpank
"
fi

## ######## DCP
## 
## # check new request history created
## 
## dpa ds query "select * from dpa.request_history;"
## 
## # check report data (esp backup data under groupevent) being process normally
## 
## dpa ds query "select * from dpa.groupevent;"
## dpa ds query "select * from dpa.backupevent;"
## 
## ### baru punya
## 
## dpa ds query "select * from dpa.request_default;"
## dpa ds query "select * from dpa.request_option_default;"
## # dpa ds query "select * from dpa.assigned_request;"
## # dpa ds query "select f_id,f_agent_id,f_function,f_module,f_overridden_agent_type,f_target_id from dpa.assigned_request;"
## # dpa ds query "select f_agent_id,f_target_id,f_function,f_module,f_overridden_agent_type,f_overridden_credential_id,f_overridden_frequency_type,f_overridden_period,f_overridden_proxy_id,f_overridden_retention,f_overridden_schedule_id from dpa.assigned_request;"
## 
## # dpa ds query "select f_function,f_module,f_overridden_agent_type,f_overridden_credential_id from dpa.assigned_request;"
## # dpa ds query "select f_agent_id,f_function,f_module,f_overridden_agent_type,f_overridden_credential_id from dpa.assigned_request;"
## 
## dpa ds query "select * from dpa.request_assigned;"
## dpa ds query "select f_id,f_agent_id,f_function,f_module,f_overridden_agent_type,f_target_id from dpa.request_assigned;"
## dpa ds query "select f_agent_id,f_target_id,f_function,f_module,f_overridden_agent_type,f_overridden_credential_id,f_overridden_frequency_type,f_overridden_period,f_overridden_proxy_id,f_overridden_retention,f_overridden_schedule_id from dpa.request_assigned;"
## 
## dpa ds query "select f_function,f_module,f_overridden_agent_type,f_overridden_credential_id from dpa.request_assigned;"
## dpa ds query "select f_agent_id,f_function,f_module,f_overridden_agent_type,f_overridden_credential_id from dpa.request_assigned;"
## 
## 
## # if defaults request settings have been over ridden, they will be written to assigned_request table
## # if defaults request settings are reused, the field in the assigned request table will be blank and the API will get data from request_default and request_options_default
