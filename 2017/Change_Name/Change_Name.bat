@echo off

::设定svg格式文件所在目录
set floder=C:\Users\fengk\Desktop\Change_Name
::设定svg格式文件所在盘符，此处放在C盘
C:

cd %floder%

for /f "delims=" %%i in ('dir /b %floder%') do call :RenameFile %%i


:RenameFile
echo %1 | find /i "35kV黄坑变电站"
if not errorlevel 1 (
for /F "eol= delims=_ tokens=1*" %%i in ("%1")  do ren %1 仁化黄坑变电站_%%j )

echo %1 | find /i "35kV江湾变电站"
if not errorlevel 1 (
for /F "eol= delims=_ tokens=1*" %%i in ("%1")  do ren %1 曲江江湾变电站_%%j )
goto :EOF