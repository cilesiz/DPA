#!/bin/bash

HB_DPA=10.64.205.162
user1=administrator
pswd1=administrator
URL1=http://"$HB_DPA":9004/apollo-api/ldap-settings

echo

curl -v -u "$user1":"$pswd1" -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X PUT -d '
<ldapSettings lastModified="2012-01-04T18:08:58.373Z" version="1">
<server>10.64.213.66</server>
<port>389</port>
<useSSL>false</useSSL>
<ldapVersion>3</ldapVersion>
<baseDN>CN=Users,DC=emcqa,DC=corp,DC=emc,DC=com</baseDN>
<uidAttribute>sAMAccountName</uidAttribute>
<bindUser>CN=usertest1,CN=Users,DC=emcqa,DC=corp,DC=emc,DC=com</bindUser>
<bindPassword>CP2HEFnGciqg3K/OF9qHxQWhw==</bindPassword>
<allowAutoLogon>true</allowAutoLogon>
<defaultRole></defaultRole>
<baseDNForGroup>CN=Users,DC=emcqa,DC=corp,DC=emc,DC=com</baseDNForGroup>
<groupAttribute>cn</groupAttribute>
<groupMemberAttribute>member</groupMemberAttribute>
<groupRoles>
	<groupRole>
		<group>testgrp1</group>
		<role>User</role>
	</groupRole>
      	<groupRole>
		<group>testgrp2</group>
		<role>Engineer</role>
	</groupRole>
</groupRoles>
</ldapSettings>
' "$URL1"

echo
