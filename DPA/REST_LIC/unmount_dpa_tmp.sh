#!/bin/sh

echo
chek1=`df | grep -i /tmp/tmp_dpa | awk '{print $NF}' | wc -l`

if [ $chek1 -gt 0 2>/dev/null ]
then

for tmpdpauncle in `df | grep -i /tmp/tmp_dpa | awk '{print $NF}'`
do
echo
echo "Unmount $tmpdpauncle"
umount "$tmpdpauncle" && rmdir "$tmpdpauncle"
echo
echo "Successfully unmounted $tmpdpauncle"
echo
done

else

echo
echo "Nothing uncle.wysdm directory mounted"
echo

fi
