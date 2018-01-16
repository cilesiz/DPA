#!/bin/bash

echo
chkcfgdpa=`ls -al /etc/init.d/*agent* | wc -l`

if [ x"$chkcfgdpa" == x1 -o x"$chkcfgdpa" == x2 -o x"$chkcfgdpa" == x3 ]; then

wheredpa=`ls -al /etc/init.d/*agent* | grep -i dpa | awk '{print $NF}' | sed -e "s/\/agent\/etc\/dpa//g"`

current_build=`xml fo -t -o "$wheredpa"/_uninstall/.com.zerog.registry.xml | grep -i "Data Protection Advisor" | grep -i " version=" | tail -1 | awk -F"version=" '{print $2}' | awk -F'"' '{print $2}'`
date_build=`xml fo -t -o "$wheredpa"/_uninstall/.com.zerog.registry.xml | grep -i "Data Protection Advisor" | grep -i " version=" | tail -1 | awk -F"last_modified=" '{print $2}' | awk -F'"' '{print $2}'`

echo
echo "RUNNING BUILD = $current_build (INSTALLED_DATE = $date_build)"
echo "INSTALL_DIR = $wheredpa"
echo
xml fo "$wheredpa"/_uninstall/.com.zerog.registry.xml | grep -i "component id=" | grep -Po '(?<=(version=)).*(?= location=)' | awk '{print "version="$0}' | sort
echo

else
echo; echo "No DPA install in this server"; echo
# exit

fi
