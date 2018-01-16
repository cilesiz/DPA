#!/bin/bash

dpaserver="$1"

for i in `seq 1 1 1000`
do
/root/rosli/JAVA/shpanmulator.sh report run "Backup Job Summary" juggernaut.universe.emc.com timeWindowName="Last Week" -server="$dpaserver"
echo "seq=$i"
sleep 1
done
