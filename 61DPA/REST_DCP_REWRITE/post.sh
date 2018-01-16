#!/bin/bash

# URL_dpa_dscvry=http://"$HB_DPA"/dpa-api/discovery
# URL_dpa_dsctst=http://"$HB_DPA"/dpa-api/discovery/tests

login1=administrator
paswd1=administrator

URL1="$1"
file1="$2"

echo "
XML INPUT
---------
"
xml fo "$file1"
echo "
URL = $URL1
"

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X POST -T "$file1" "$URL1"

echo
echo
