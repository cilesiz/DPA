#!/bin/bash

HB_DPA=10.64.205.162
user1=sst4
pswd1=sst4

URL1=http://"$HB_DPA":9004/dpa-api/alert/alerts

echo
echo
curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X POST -d '
<alertsFilter pageSize="10" pageNumber="0" sortBy="issued" sortOrder="Descending">
     <rootFilterEntity type="CompoundCondition">
      <rightSide type="ScalarCondition">
         <field>state</field>
         <operand>Equals</operand>
         <value>New</value>
      </rightSide>
      <logicalOperator>OR</logicalOperator>
      <leftSide type="CompoundCondition">
         <rightSide type="CollectionCondition">
            <field>severity</field>
            <operand>In</operand>
            <values>
               <value>Error</value>
               <value>Warning</value>
            </values>
         </rightSide>
         <logicalOperator>AND</logicalOperator>
         <leftSide type="ScalarCondition">
            <field>category</field>
            <operand>Equals</operand>
            <value>Configuration</value>
         </leftSide>
      </leftSide>
   </rootFilterEntity>
   <type>Advanced</type>
  </alertsFilter>
' "$URL1" > tmp1.txt

echo
cat tmp1.txt 
echo
echo
rm -rf tmp1.txt 

