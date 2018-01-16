#!/bin/bash

echo 
echo -n "PUT NEW DPA SERVER IP ADDRESS : "
read -e new_ip
echo

for file1 in `find . -name "*.sh" -print | grep -v TUKAR | grep -v OTHER_DPA_SERVER`
do
sed -i "s/HB_DPA=.*/HB_DPA=$new_ip/g" "$file1"
sed -i "s/HBS_DPA=.*/HBS_DPA=$new_ip/g" "$file1"
echo "SUCCESSFULLY CHANGE $file1"
done
echo
echo "FINISH - NEW IP ADDRESS = $new_ip"
echo
