#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator

URL1=http://"$HB_DPA":9004/dpa-api/policies/chargeback

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X PUT -d '
<chargebackPolicy system="false" hidden = "false">
    <name>Rosli_test_chargeback</name>
    <description>Rosli_test_chargeback TEST JER NI</description>
    <enabled>1</enabled>
        <!-- backupChargebackRule is optional. 0 or 1 of these can exist -->
    <backupChargebackRule>
        <!-- All values below are of type 'double' supporting decimal points -->
        <!-- These first 3 fields relate to 'Cost per GB backed up' on the UI screen -->
        <firstUnitThreshold>1</firstUnitThreshold>
        <firstCostPerUnit>1</firstCostPerUnit>
        <additionalCostPerUnit>1</additionalCostPerUnit>
        <!-- These remaining fields related to 'Other backup costs' on the UI screen -->
        <costPerBackup>1</costPerBackup>
        <costPerUnitRetained>1</costPerUnitRetained>
        <costPerRestore>1</costPerRestore>
        <costPerUnitRestored>1</costPerUnitRestored>
        <costPerTape>1</costPerTape>
    </backupChargebackRule>
        <!-- storageChargebackRule is optional. 0 or 1 of these can exist -->
    <storageChargebackRule>
        <storageCostMethod>used</storageCostMethod>
                <!-- All values below are of type 'double' supporting decimal points -->
        <storageFirstUnitThreshold>1</storageFirstUnitThreshold>
        <storageFirstCostPerUnit>1</storageFirstCostPerUnit>
        <storageAdditionalCostPerUnit>1</storageAdditionalCostPerUnit>
        <replFirstUnitThreshold>1</replFirstUnitThreshold>
        <replFirstCostPerUnit>1</replFirstCostPerUnit>
        <replAdditionalCostPerUnit>1</replAdditionalCostPerUnit>
        <snapCostPerUnit>1</snapCostPerUnit>
    </storageChargebackRule>
</chargebackPolicy>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp1.txt 

