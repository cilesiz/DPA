#!/bin/bash

chkcfgdpa=`ls -al /etc/init.d/*agent* | grep -i dpa | wc -l`
if [ x"$chkcfgdpa" == x1 ]; then

wheredpa=`ls -al /etc/init.d/*agent* | grep -i dpa | awk '{print $NF}' | sed -e "s/\/agent\/etc\/dpa//g"`

"$wheredpa"/services/bin/dpa.sh svc stop

cp "$wheredpa"/services/datastore/data/pg_hba.conf "$wheredpa"/services/datastore/data/pg_hba.conf_org1
echo "host    all     all            10.64.0.0/16            md5" >> "$wheredpa"/services/datastore/data/pg_hba.conf
echo "host    all     all            152.62.0.0/16            md5" >> "$wheredpa"/services/datastore/data/pg_hba.conf

cp "$wheredpa"/services/datastore/data/postgresql.conf "$wheredpa"/services/datastore/data/postgresql.conf_org1
sed -i "s/listen_addresses.*/listen_addresses = '*'  /g" "$wheredpa"/services/datastore/data/postgresql.conf

"$wheredpa"/services/bin/dpa.sh svc start

else
echo "Cannot find DPA installation directory"
exit
fi
