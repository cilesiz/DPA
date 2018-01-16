#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib
source /root/rosli/61DPA/LIB/listing_id.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.txt
tmp2="$tmprundir"/tmp2.txt

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X GET "$URL_dpa_sptque" > "$tmp1"

echo
echo
xml fo "$tmp1"
echo
echo "
SIMPLIFY RESULT :
=================
"

cat "$tmp1" | grep -i "name=" | grep -vi link | awk -F"name=" '{print $2}' | awk -F">" '{print NR"   "$1}'

echo

xml sel -t -m queues/queue \
-o "CurrntTotalQ=" -v currentTotalMessageCount \
-o " msgInCsmrQ=" -v messagesInConsumerQueues \
-o " msgStillPrimeQ=" -v messagesStillInPrimaryQueue \
-o " msgAddSncRstrt=" -v messagesAddedSinceRestart \
-o " noOfCnsmr=" -v numberOfConsumers \
-n "$tmp1" | grep -i [0-9,a-z] | awk '{print NR"   "$0}' 

echo

rm -rf "$tmprundir"

