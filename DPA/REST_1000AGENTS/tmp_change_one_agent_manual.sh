#!/bin/bash

curl -v -u administrator:administrator -H "Accept: application/vnd.emc.apollo-v1+xml" -H "Content-Type: application/vnd.emc.apollo-v1+xml" -X PUT -d '
<agentSettings version="1" lastModified="2012-01-06T10:34:12.17Z">
   <name>limalapan_7</name>
   <id>0a69f24f-c510-4f2a-b68b-d0be0fb90533</id>
   <port>3741</port>
   <concurrency>8</concurrency>
   <logFile>C:\log\dpa58\mylogfile.log</logFile>
   <logLevel>Info</logLevel>
   <maxLogFileSize>5</maxLogFileSize>
   <maxLogFiles>10</maxLogFiles>
   <maxStoreFwdQueueLength>100</maxStoreFwdQueueLength>
   <maxStoreFwdQueueSize>10</maxStoreFwdQueueSize>
   <agentVersion>5.8.1 (5991)</agentVersion>
</agentSettings>
' http://10.64.213.60:9004/dpa-api/settings/agents/0a69f24f-c510-4f2a-b68b-d0be0fb90533


