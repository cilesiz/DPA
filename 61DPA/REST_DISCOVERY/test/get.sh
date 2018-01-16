#!/bin/bash

# URL_dpa_dscvry=http://"$HB_DPA"/dpa-api/discovery
# URL_dpa_dsctst=http://"$HB_DPA"/dpa-api/discovery/tests

login1=administrator
paswd1=administrator

URL1="$1"
idtest="$2"

curl -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL1"/"$idtest"

echo
echo
