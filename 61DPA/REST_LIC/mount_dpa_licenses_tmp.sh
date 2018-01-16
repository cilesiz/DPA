#!/bin/bash

masa=`date +%Y%m%d_%H%M%S`
tmpdpalic=/tmp/tmp_dpa_lic_"$masa"
checkosversn=`cat /etc/*release | head -1 | awk '{print $1}'`
checkversion=`cat /etc/*release | head -1 | sed 's/ /\n/g' | grep [0-9] | grep -vi [a-z] | awk -F"." '{print $1}'`

mkdir "$tmpdpalic"

if [ x"$checkosversn" == xSUSE -a "$checkversion" -ge 11 ]; then
mount -t cifs //uncle.wysdm.lab.emc.com/wysdm/QA-Lab/Licenses "$tmpdpalic" -o ro,user=WYSDM/talibr,pass=irix293
elif [ x"$checkosversn" == xCentOS -a "$checkversion" -ge 7 ]; then
mount -t cifs //uncle.wysdm.lab.emc.com/wysdm/QA-Lab/Licenses "$tmpdpalic" -o ro,domain=WYSDM,username=talibr,password=irix293
else
mount -t cifs //uncle.wysdm.lab.emc.com/wysdm/QA-Lab/Licenses "$tmpdpalic" -o ro,user=WYSDM/talibr,pass=irix293
fi

echo
echo "SUCCESSFULLY MOUNT DPA's stockwell license directory to $tmpdpalic"
echo
echo
echo "DPA's QA-Lab Licenses mounted"
echo "-----------------------------"
df | grep -i /tmp/tmp_dpa_lic | awk '{print NR"\t"$NF}'
echo
# \\uncle.wysdm.lab.emc.com\wysdm\QA-Lab\Licenses\Valid DPA Licenses
