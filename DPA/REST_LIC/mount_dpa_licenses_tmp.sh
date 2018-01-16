#!/bin/bash

masa=`date +%Y%m%d_%H%M%S`
tmpdpalic=/tmp/tmp_dpa_lic_"$masa"

mkdir "$tmpdpalic"
mount -t cifs //uncle.wysdm.lab.emc.com/wysdm/QA-Lab/Licenses "$tmpdpalic" -o user=WYSDM/talibr,pass=irix293
echo
echo "SUCCESSFULLY MOUNT DPA's stockwell directory to $tmpdpalic"
echo
echo
echo "DPA's QA-Lab Licenses mounted"
echo "-----------------------------"
df | grep -i /tmp/tmp_dpa_lic | awk '{print NR"\t"$NF}' 
echo
# \\uncle.wysdm.lab.emc.com\wysdm\QA-Lab\Licenses\Valid DPA Licenses
