@echo off
set global_temp=schreport.txt
set global_temp2=newfile.xml
set global_temp3=newfile2.xml
set global_temp4=newfile3.xml
set global_id=
set global_reportname=
for /f "tokens=*" %%a in (report_ids.txt) do (        
   set global_id=%%a   
   Call :getReportNameForId %%a
   Call :replaceReportID %global_temp% %%a 
   Call :parseReportNames %%a
   Call :replaceReportNames %global_temp2% %global_reportname%
   Call :replaceReportDesc %global_temp3% %%a 
   Call :replaceReportOutput %global_temp4% %%a
   Call :sendRequest
    )
goto :eof

:replaceReportID
echo replacing report id
setlocal EnableDelayedExpansion
set file=%~1
echo first file is %file%
(for /F "delims=" %%a in (%file%) do (
   set "line=%%a"
   set "newLine=!line:<id></id>=!"
   if "!newLine!" neq "!line!" (
      set "newLine=<id>%2%</id>"
   )
   echo !newline!
   )) > newfile.xml
goto :eof
   

:replaceReportNames
echo replacing report names
setlocal EnableDelayedExpansion
set file2=%~1
echo second file is %file2%
(for /F "delims=" %%c in (%file2%) do (
   set "line2=%%c"
   set "newLine2=!line2:<name></name>=!"
   if "!newLine2!" neq "!line2!" (
      set "newLine2=%2%"
   )
      echo !newLine2!
   )) > newfile2.xml
goto :eof
   
:replaceReportDesc
echo replacing report description 
set file5=%~1
set file51=%~2
setlocal EnableDelayedExpansion
echo replaceReportDesc second file is %file5% %file53%
(for /F "delims=" %%e in (%file5%) do (
   set "line5=%%e"   
   set "newLine5=!line5:<description></description>=!"
    if "!newLine5!" neq "!line5!" (	  
      set "newLine5=<description>%2%_!time!</description>"
   )
   echo !newLine5!
   )) > newfile3.xml
goto :eof

:replaceReportOutput
echo replacing report output
setlocal EnableDelayedExpansion
set file6=%~1
echo second file is %file6%
(for /F "delims=" %%f in (%file6%) do (
   set "line6=%%f"
   set "newLine6=!line6:<fileName></fileName>=!"
    if "!newLine6!" neq "!line6!" (
      set "newLine6=<fileName>%2%</fileName>"
   )
   echo !newLine6!
   )) > newfile4.xml
goto :eof

:getReportNameForId
setlocal EnableDelayedExpansion
set file4=%~1
C:\temp\curl-7.33.0-win64-nossl\curl.exe -X GET  http://localhost:9004/dpa-api/report-templates/%file4% -H "Content-Type:application/vnd.emc.apollo-v1+xml" -H "Accept:application/vnd.emc.apollo-v1+xml" -u administrator:administrator > C:\temp2\%file4%.txt
goto :eof

:sendRequest   
setlocal EnableDelayedExpansion
C:\temp\curl-7.33.0-win64-nossl\curl.exe -X POST -d @C:\temp\newfile4.xml http://localhost:9004/dpa-api/scheduledreport -H "Content-Type:application/vnd.emc.apollo-v1+xml" -H "Accept:application/vnd.emc.apollo-v1+xml" -u administrator:administrator
goto :eof

:parseReportNames
setlocal EnableDelayedExpansion
set file3=%~1
echo parsing reportNames from reportTemplates using reportIds %file3%
(for /F "delims=" %%d in (%file3%) do (
   set "line3=%%d"
   set "newLine3=!line3:<name>=!"
   if "!newLine3!" neq "!line3!" (
        echo !newLine3!
		set global_reportname=%newline3%
   )
   
   )) 
goto :eof


EXIT /b


:eof
