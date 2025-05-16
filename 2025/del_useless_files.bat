@echo off
echo ***************************************Delete useless files*************************************************
set DaysAgo=-10
set FolderName=D:\TRS_Backup
set FolderDepth=10
call :DeleteFile %FolderName% %DaysAgo%
call :DeleteEmptyFolders %FolderName% %FolderDepth%
echo ***************************************Delete useless files*************************************************
goto :end

echo ***************************************Delete empty folders function*************************************
:DeleteEmptyFolders
set count=0
set count_max=%2

:del_empty_dir
if %count% GTR %count_max% goto end_del_dir
for /f "delims=" %%i in ('dir /ad /b /s %1') do rd %%i 2>nul
set /a count=%count%+1
goto del_empty_dir 
:end_del_dir

goto :EOF
echo ***************************************Delete empty folders function*************************************


echo ***************************************Delete files function************************************************
:DeleteFile
forfiles /P %1 /S /M * /d %2 /c "cmd /c del /f /q /a @path"
goto :EOF
echo ***************************************Delete files Function************************************************

:end