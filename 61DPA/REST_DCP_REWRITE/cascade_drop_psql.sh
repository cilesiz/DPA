#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib

choose_server

echo "$dpaserver:9003:apollo:apollosuperuser:3g1;23#6hFd 05(}c8/F5rB2lL1J79" > /root/.pgpass
chmod 0600 /root/.pgpass

cmdrun="DROP SCHEMA IF EXISTS apollo CASCADE; DROP SCHEMA IF EXISTS dpa CASCADE; DROP SCHEMA IF EXISTS dpa_ra CASCADE;"
echo; echo 
echo "psql --host $dpaserver --port 9003 --username apollosuperuser -d apollo -c \$CMD"
echo "	\$CMD = \"$cmdrun\" "
echo; echo

/root/rosli/61DPA/REST_DCP_REWRITE/ds_psql/psql/psql --host "$dpaserver" --port 9003 --username apollosuperuser -d apollo -c "$cmdrun"

echo; echo

################


