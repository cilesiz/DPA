#!/bin/bash

masa=`date +%H_%M_%S`
tmpdpa=/tmp/tmp_labnas_"$masa"

mkdir "$tmpdpa"
mount -t cifs //hb-labnas.corp.emc.com/share "$tmpdpa" -o user=istech,pass=H0meBase
echo
echo "SUCCESSFULLY MOUNT hb-labnas directory to $tmpdpa"
echo

