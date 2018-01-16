#!/bin/bash

echo "LIST OR GENERATE?"
echo "1) LIST"
echo "2) GENERATE"
echo "3) DELETE"
echo "4) CREATE CERT REQ"
echo "5) EXPORT .CER CERT"
echo
echo -n "1 / 2 / 3 / 4 / 5 : "
read -e apanak

if [ $apanak == 1 ]
then

# Listing the Certificates
# ------------------------
/opt/emc/dpa/services/_jre/bin/keytool -list -v -storepass apollo -keystore \
/opt/emc/dpa/services/standalone/configuration/apollo.keystore

elif [ $apanak == 2 ]
then

# Generating a new certificate into the keystore
# ----------------------------------------------
/opt/emc/dpa/services/_jre/bin/keytool -genkeypair -v -storepass apollo -alias apollokey -keyalg RSA \
-validity 465 -keystore \
/opt/emc/dpa/services/standalone/configuration/apollo.keystore -storetype JKS

elif [ $apanak == 3 ]
then

# Deleting the Certificate
# ------------------------

/opt/emc/dpa/services/_jre/bin/keytool -storepass apollo -alias apollokey \
-delete -v -keystore \
/opt/emc/dpa/services/standalone/configuration/apollo.keystore

elif [ $apanak == 4 ]
then

# Keytool generates the request
echo
echo -n "Give output file name : "
read -e file1

/opt/emc/dpa/services/_jre/bin/keytool -certreq -alias apollokey -v -keystore /opt/emc/dpa/services/standalone/configuration/apollo.keystore -file `pwd`/"$file1"

echo
cat `pwd`/"$file1"
echo

elif [ $apanak == 5 ]
then

# Export in Binary
# ----------------
echo
echo -n "Give output file name (.cer format) : "
read -e file1

/opt/emc/dpa/services/_jre/bin/keytool -storepass apollo -alias apollokey \
-export -file `pwd`/"$file1" -v -keystore \
/opt/emc/dpa/services/standalone/configuration/apollo.keystore

else
echo
echo "WRONG CHOICE - $apanak is not in a list"
echo
fi
