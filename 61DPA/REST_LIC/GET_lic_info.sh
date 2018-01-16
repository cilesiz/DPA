#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.txt
tmp2="$tmprundir"/tmp2.txt
tmp3="$tmprundir"/tmp3.txt
tmp4="$tmprundir"/tmp4.txt
tmp5="$tmprundir"/tmp5.txt

curl -k -v -u "$login1":"$paswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL_dpa_licens" > "$tmp1"

echo
echo
xml fo "$tmp1"
echo
echo
echo

cat "$tmp1" | grep -i lastModified | awk -F"=" '{print $2}' | awk -F">" '{print $1}' | awk -F'"' '{print "#"NR"#"$2"#"}' > "$tmp5"

##### CHECK EXPIRY DATE OF LICENSES

cat "$tmp1" | grep "<name>" | awk -v w1=">" -v w2="</" 'match ($0, w1 ".*" w2){print substr($0,RSTART+length(w1),RLENGTH-length(w1 w2))}' | awk '{print "#"NR"#"$0"#"}' > "$tmp2"
echo -n > "$tmp3"
for date1 in `cat "$tmp1" | grep "<expiry>" | awk -v w1=">" -v w2="</" 'match ($0, w1 ".*" w2){print substr($0,RSTART+length(w1),RLENGTH-length(w1 w2))}'`
do
date -d @"$date1" >> "$tmp3"
done
cat "$tmp3" | awk '{print "#"NR"#"$0"#"}' > "$tmprundir"/tmp33.txt && mv "$tmprundir"/tmp33.txt "$tmp3"
paste "$tmp2" "$tmp3" "$tmp5" > "$tmp4"
echo

chk_lic1=`cat "$tmp4" | wc -l`

if [ $chk_lic1 -gt 0 2>/dev/null ]
then

echo "EXPIRY DATE OF DPA LICENSES"
echo "==========================="
echo

for i in `cat "$tmp4" | awk -F"#" '{print $2}'`
do
echo "LICENSE $i"
echo "----------"
echo -n "NAME $i = "
cat "$tmp4" | grep -i "#$i#" | awk -F"#" '{print $3}'
echo -n "ENTERY $i = "
cat "$tmp4" | grep -i "#$i#" | awk -F"#" '{print $(NF-1)}'
echo -n "EXPIRY $i = "
cat "$tmp4" | grep -i "#$i#" | awk -F"#" '{print $6}'
echo
done

else

echo "================"
echo "NO LICENSE FOUND"
echo "================"
echo

fi

rm -rf "$tmprundir"
