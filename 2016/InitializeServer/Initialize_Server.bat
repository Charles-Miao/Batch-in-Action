chcp 437

set ntp_server=192.168.123.71
set ntp_password=TBUITEMEZ900!!
set logfile=c:\initialize_server.txt
if exist %logfile% del %logfile%

echo XP and Server 2003 mainly includes the following functions
echo 1. disable firewall
echo 2. create disk paration
echo 3. enable remote control services
echo 4. change the ip config
echo 5. add new user

echo Win7 and Server 2008 mainly includes the following functions
echo 1. disable firewall
echo 2. sync time
echo 3. active the os
echo 4. create disk paration
echo 5. enable remote control services
echo 6. rename computher
echo 7. change the ip config
echo 8. setting the share folder
echo 9. add new user

:distinguish server OS version
ver | find "6.1"
if not errorlevel 1 goto initialize_Win7_Server2008

:initialize_XP_Server2003

:======================================
echo disable XP or Server2003 firewall
:======================================
:check_firewall_state
netsh firewall show state | find /i "Operational mode                  = Enable"
if errorlevel 1 goto initialize_XP_Server2003_firewall_end
:disable_XP_Server2003_firewall
netsh firewall set opmode mode=disable profile=ALL
if errorlevel 1 call :fail_function "disable XP or Server2003 firewall fail"
:initialize_XP_Server2003_firewall_end

:======================================
echo enable remote desktop
:======================================
reg import "EnableRemoteDesktop.reg"
if errorlevel 1 call :fail_function "enable XP or Server2003 remote desktop fail"

goto END

:initialize_Win7_Server2008

:======================================
echo disable Win7 or Server2008 firewall
:======================================
:check_firewall_state
netsh advfirewall show currentprofile | find /i "State                                 ON"
if errorlevel 1 goto initialize_Win7_Server2008_firewall_end
:disable_Win7_Server2008_firewall
netsh advfirewall set currentprofile state off
if errorlevel 1 call :fail_function "disable Win7 or Server2008 firewall fail"
:initialize_Win7_Server2008_firewall_end

:======================================
echo Sync Win7 or Server2008 time
:======================================
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "lmcompatibilitylevel" /t REG_DWORD /d 0x00000001 /f
Tzutil /s "China Standard Time"
net use \\%ntp_server% /user:administrator %ntp_password%
net time \\%ntp_server% /set /y
if errorlevel 1 call :fail_function "sync Win7 or Server2008 time fail"

:======================================
echo enable remote desktop
:======================================
reg import "EnableRemoteDesktop.reg"
if errorlevel 1 call :fail_function "enable Win7 or Server2008 remote desktop fail"

goto END

:fail_function
echo %1 >> %logfile%
echo.>PRN >> %logfile%
goto :EOF

:END