@echo off

REM --------------- Configuration Variables ---------------
set LOGFile=D:\ServerJobs\SyncFileServer\SyncFile.log
set Templogfile=D:\ServerJobs\SyncFileServer\SyncFileTemp.log
set robocopylogfile=D:\ServerJobs\SyncFileServer\robocopy.log
set source_path=\\X.X.X.X\d$\X\WINSWDL
set target_path=D:\TEMP

REM --------------- Cleanup Previous Logs ---------------
if exist %LOGFile% del %LOGFile%
if exist %Templogfile% del %Templogfile%
if exist %robocopylogfile% del %robocopylogfile%

echo ===========================================================================
echo Sync File Server %target_path%, please don't close this Windows, thanks!
echo ===========================================================================

REM --------------- Main Execution ---------------
call :SyncFolder "%source_path%" "%target_path%" "%robocopylogfile%" "%Templogfile%" "%LOGFile%"

goto end

REM --------------- Function Definition ---------------
:SyncFolder
REM Parameters:
REM   %1 = Source path
REM   %2 = Destination path
REM   %3 = Robocopy log path
REM   %4 = Temporary log path
REM   %5 = Final log path

ROBOCOPY %1 %2 /E /R:2 /W:0 /LOG:%3 /TEE

REM Handle Robocopy exit codes
if errorlevel 10 goto fail10  REM Serious error
if errorlevel 8 goto fail8    REM Partial copy failure
if errorlevel 4 goto fail4    REM MISMATCHED items
if errorlevel 2 goto pass2    REM Extra items
if errorlevel 1 goto pass1    REM Success with files copied
if errorlevel 0 goto pass0    REM Success with no changes

:fail10
echo  When sync the files, the error code is "serious error. Robocopy did not copy any files".>>%4
goto AnalyzeLog

:fail8
echo  When sync the files, the error code is "some files or directories could not be copied".>>%4
goto AnalyzeLog

:fail4
echo  When sync the files, the error code is "some mismatched files or directories were detected".>>%4
goto AnalyzeLog

:pass2
echo  When sync the files, the pass code is "some extra files or directories were detected".>>%4
goto AnalyzeLog

:pass1
echo  When sync the files, the pass code is "one or more files were copied successfully".>>%4
goto AnalyzeLog

:pass0
echo  When sync the files, the pass code is "no errors, no copying was done".>>%4
goto AnalyzeLog

:AnalyzeLog
REM Analyze log for errors
find /i "error code" %4
if not errorlevel 1 echo Sync files has error>%5
if errorlevel 1 echo Sync files is OK>%5

goto :EOF

:end