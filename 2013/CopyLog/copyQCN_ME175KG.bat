net use \\192.168.168.74 /user:admin btco

net use \\192.168.168.76 /user:admin btco
net use \\192.168.168.77 /user:admin btco

net use \\192.168.168.91 /user:admin btco
net use \\192.168.168.88 /user:admin btco

net use \\192.168.123.81 /user:admin btco
net use \\192.168.123.82 /user:admin btco
net use \\192.168.123.84 /user:admin btco
net use \\192.168.123.97 /user:admin btco
net use \\192.168.123.98 /user:admin btco

setlocal enabledelayedexpansion

::start
TITLE "QCN_ME175KG"
for /f "tokens=2,3,4,5 delims=/ " %%i in ("%date%") do set dd=%%k-%%i-%%j
for /f "tokens=1,2,3 delims=-" %%i in ('dateadd.exe -8') do set deld=%%j/%%k/%%i
call :copyME175KGQCN \\192.168.168.74\vol1\MESSAGE\SFCS\PCBA\QCN_ME175KG

call :copyME175KGQCN \\192.168.168.88\vol1\MESSAGE\SFCS\FA\QCN_ME175KG
call :copyME175KGQCN \\192.168.168.91\vol1\MESSAGE\SFCS\FA\QCN_ME175KG

call :copyME175KGQCN \\192.168.123.84\vol1\MESSAGE\SFCS\PCBA\QCN_ME175KG

call :copyME175KGQCN \\192.168.123.97\vol1\MESSAGE\SFCS\FA\QCN_ME175KG
call :copyME175KGQCN \\192.168.123.98\vol1\MESSAGE\SFCS\FA\QCN_ME175KG

::pause
exit

::goto Start

:copyME175KGQCN
echo %1
if not exist E:\QCN\QCN_ME175KG\ME175KG_QCN%dd% mkdir E:\QCN\QCN_ME175KG\ME175KG_QCN%dd%
::for %%i in (%1\*.*) do (
:: set a=%%~ni
:: set a=!a:~0,2!
:: copy %%i E:\QCN\QCN_ME175KG\ME175KG_QCN%dd%\%%~ni /Y

::)

pushd "%1"
xcopy "%1" E:\QCN\QCN_ME175KG\ME175KG_QCN%dd% /e /d /y
for /f "delims==" %%i in ('dir /b') do if "%%~ti" lss "%deld% 01:00 AM" del "%%i" /q

::pause
popd

goto :EOF