#!/bin/bash

source /root/rosli/61DPA/LIB/pilih_server.lib
source /root/rosli/61DPA/LIB/listing_URL.lib

choose_server
listing_url

tmp1="$tmprundir"/tmp1.txt

timezone=GB-Eire

echo -n "
Choose Schedule to create :
1) every hour
2) every half an hour
3) every quater an hour

Choose [ 1 / 2 / 3 ] : "
read -e schnak

if [ x"$schnak" == x1 ]; then
name=scheveryanhour
descr="Rosli Schedule - Every An Hour"
elif [ x"$schnak" == x2 ]; then
name=scheveryhalfanhour
descr="Rosli Schedule - Every Half An Hour"
minseq=30
minakh=30
elif [ x"$schnak" == x3 ]; then
name=scheveryquateranhour
descr="Rosli Schedule - Every Quater An Hour"
minseq=15
minakh=45
else
echo "
Wrong choice - $schnak
"
exit
fi

echo "  <schedule version=\"1\">
    <name>$name</name>
    <description>$descr</description>
    <system>false</system>
    <hidden>false</hidden>
    <period>0</period>
    <type>POINT</type> " > "$tmp1"
for hariweek in `seq 0 1 6`
do
for harijam in `seq 0 1 23`
do
if [ $name == scheveryanhour ]; then
hariminit=0
echo -n "    <schedulePart type=\"SchedulePartWeeks\">
      <exclude>false</exclude>
      <fromHour>$harijam</fromHour>
      <fromMinute>$hariminit</fromMinute>
      <fromSecond>0</fromSecond>
      <fromTimeZone class=\"sun.util.calendar.ZoneInfo\">$timezone</fromTimeZone>
      <toHour>$harijam</toHour>
      <toMinute>$hariminit</toMinute>
      <toSecond>0</toSecond>
      <toTimeZone class=\"sun.util.calendar.ZoneInfo\">$timezone</toTimeZone>
      <toWeekDay>$hariweek</toWeekDay>
      <fromWeekDay>$hariweek</fromWeekDay>
    </schedulePart>
" >> "$tmp1"
else
for hariminit in `seq 0 "$minseq" "$minakh"`
do
echo -n "    <schedulePart type=\"SchedulePartWeeks\">
      <exclude>false</exclude>
      <fromHour>$harijam</fromHour>
      <fromMinute>$hariminit</fromMinute>
      <fromSecond>0</fromSecond>
      <fromTimeZone class=\"sun.util.calendar.ZoneInfo\">$timezone</fromTimeZone>
      <toHour>$harijam</toHour>
      <toMinute>$hariminit</toMinute>
      <toSecond>0</toSecond>
      <toTimeZone class=\"sun.util.calendar.ZoneInfo\">$timezone</toTimeZone>
      <toWeekDay>$hariweek</toWeekDay>
      <fromWeekDay>$hariweek</fromWeekDay>
    </schedulePart> 
" >> "$tmp1"
done
fi
done
done
echo -n "  </schedule> " >> "$tmp1" 

curl -k -v -u "$login1":"$paswd1" \
-H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" \
-X POST -T "$tmp1" "$URL_apollo_sch"

rm -rf "$tmprundir"
