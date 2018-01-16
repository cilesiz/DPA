#!/bin/bash

echo "host    all             all             10.64.0.0/16            md5" >> /opt/emc/dpa/services/datastore/data/pg_hba.conf
echo "host    all             all             152.62.0.0/16            md5" >> /opt/emc/dpa/services/datastore/data/pg_hba.conf

cp /opt/emc/dpa/services/datastore/data/postgresql.conf /opt/emc/dpa/services/datastore/data/postgresql.conf_org1
sed -i "s/listen_addresses.*/listen_addresses = '*'     # what IP address(es) to listen on;/g" /opt/emc/dpa/services/datastore/data/postgresql.conf

/opt/emc/dpa/services/bin/dpa.sh svc restart
