#!/bin/bash

echo "LIST OR GENERATE?"
echo "1) IMPORT CA ROOT"
echo "2) IMPORT CA INTERMEDIATE"
echo "3) IMPORT CERTIFICATE"
echo "4) LIST OF CERTIFICATE"
echo "5) DELETE CERTIFICATE"
echo
echo -n "1 / 2 / 3 / 4 / 5 : "
read -e apanak

if [ $apanak == 1 ]
then

echo
echo -n "Give input file name (CA ROOT) : "
read -e file1
echo
echo -n "Give alias (suggest root) : "
read -e ca_alias

/opt/emc/dpa/services/_jre/bin/keytool -import -trustcacerts -alias "$ca_alias" \
-keystore /opt/emc/dpa/services/standalone/configuration/apollo.keystore \
-file `pwd`/"$file1"

elif [ $apanak == 2 ]
then

echo
echo -n "Give input file name (CA INTERMEDIATE) : "
read -e file1
echo
echo -n "Give alias (suggest intermediate) : "
read -e ca_alias

/opt/emc/dpa/services/_jre/bin/keytool -import -trustcacerts -alias "$ca_alias" \
-keystore /opt/emc/dpa/services/standalone/configuration/apollo.keystore \
-file `pwd`/"$file1"

elif [ $apanak == 3 ]
then

echo
echo -n "Give input file name : "
read -e file1
echo
echo -n "Give alias (suggest myownalias) : "
read -e ca_alias

/opt/emc/dpa/services/_jre/bin/keytool -import -trustcacerts -alias "$ca_alias" \
-keystore /opt/emc/dpa/services/standalone/configuration/apollo.keystore \
-file `pwd`/"$file1"

elif [ $apanak == 4 ]
then

/opt/emc/dpa/services/_jre/bin/keytool -list -v -keystore \
/opt/emc/dpa/services/standalone/configuration/apollo.keystore

elif [ $apanak == 5 ]
then

echo
echo -n "Give alias : "
read -e ca_alias

/opt/emc/dpa/services/_jre/bin/keytool -storepass apollo -alias "$ca_alias" \
-delete -v -keystore \
/opt/emc/dpa/services/standalone/configuration/apollo.keystore

else
echo
echo "WRONG CHOICE - $apanak is not in a list"
echo
fi
