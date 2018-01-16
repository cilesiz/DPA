#!/bin/bash

#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib
source /root/rosli/61DPA/LIB/listing_id.lib

choose_server
listing_url

for i in `seq 1 1 100`
do

for userldap in userldap1 userldap2 userldap3 userldap4 testnew123 testldap1 testldap2 testldap3 testldap4 testldap5 testldap6 testldap7 testldap8 testldap9
do
echo "
USER = $userldap
"
login1="$userldap"
paswd1="$userldap"
echo
curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_apollo_usr"/administrator | xml fo
echo

done
done
