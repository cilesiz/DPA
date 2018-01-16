#!/bin/bash

pwd1=/root/rosli/DPA
port1=9002
port2=9004

echo
echo "Choose port to use : "
echo "1) 9002"
echo "2) 9004"
echo
echo -n "Your choice [1/2] : "
read -e choice1

if [ $choice1 -eq 1 2>/dev/null ]
then
portuse="$port1"

for file1 in `find "$pwd1" -name "*.sh" -print`
do
sed -i "s/\:9004\//\:$portuse\//g" "$file1"
done
echo

elif [ $choice1 -eq 2 2>/dev/null ]
then
portuse="$port2"

for file1 in `find "$pwd1" -name "*.sh" -print`
do
sed -i "s/\:9002\//\:$portuse\//g" "$file1"
done
echo

else
echo
echo "WRONG INPUT"
echo
exit
fi
