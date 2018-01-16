#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/license

hari=`date +%Y%m%d_%H%M%S`
tmp1=/tmp/tmp1_"$hari".txt
tmp2=/tmp/tmp2_"$hari".txt
tmp3=/tmp/tmp3_"$hari".txt
tmp4=/tmp/tmp4_"$hari".txt
tmp5=/tmp/tmp5_"$hari".txt

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X GET "$URL1" > "$tmp1"

echo
echo
cat "$tmp1" 
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
cat "$tmp3" | awk '{print "#"NR"#"$0"#"}' > /tmp/tmp33.txt && mv /tmp/tmp33.txt "$tmp3"
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

rm -rf "$tmp1" "$tmp2" "$tmp3" "$tmp4" "$tmp5"
