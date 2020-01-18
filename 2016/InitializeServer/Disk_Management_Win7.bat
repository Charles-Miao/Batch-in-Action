set set_disk_offline_command=set_disk_offline.txt
set set_disk_offline_log=set_disk_offline.log
set assign_DVD_command=assign_DVD.txt
set assign_DVD_log=assign_DVD.log
set initialize_offline_disk_command=initialize_offline_disk.txt
set initialize_offline_disk_log=initialize_offline_disk.log
set create_D_E_partition_command=create_D_E_partition.txt
set create_D_E_partition_log=create_D_E_partition.log

set temp=temp.txt

:========================set disk offline=========================
if exist %temp% del %temp%
echo list disk > list_disk.txt
diskpart /s list_disk.txt > %set_disk_offline_log%
findstr /i "online" %set_disk_offline_log% > %temp%
echo.>PRN > %set_disk_offline_command%
for /f "tokens=1,2 delims= " %%i in (%temp%) do (
echo select %%i %%j >> %set_disk_offline_command%
echo offline disk NOERR >> %set_disk_offline_command%
)
diskpart /s %set_disk_offline_command% > %set_disk_offline_log%

:========================assign DVD-ROM F:========================
if exist %temp% del %temp%
echo list volume > list_volume.txt
diskpart /s list_volume.txt > %assign_DVD_log%
findstr /i "DVD-ROM" %assign_DVD_log%
if not errorlevel 1 (
findstr /i "DVD-ROM" %assign_DVD_log% > %temp%
for /f "tokens=1,2 delims= " %%i in (%temp%) do echo select %%i %%j > %assign_DVD_command%
echo assign letter=F NOERR >> %assign_DVD_command%
diskpart /s %assign_DVD_command% > %assign_DVD_log%
)

:========================initialize offline disk==================
if exist %temp% del %temp%
echo list disk > list_disk.txt
diskpart /s list_disk.txt > %initialize_offline_disk_log%
findstr /i "Offline" %initialize_offline_disk_log%
if not errorlevel 1 (
findstr /i "Offline" %initialize_offline_disk_log% > %temp%
echo.>PRN > %initialize_offline_disk_command%
for /f "tokens=1,2 delims= " %%i in (%temp%) do (
echo select %%i %%j >> %initialize_offline_disk_command%
echo attributes disk clear readonly NOERR >> %initialize_offline_disk_command%
echo online disk NOERR >> %initialize_offline_disk_command%
echo convert gpt NOERR >> %initialize_offline_disk_command%
echo create partition primary NOERR >> %initialize_offline_disk_command%
echo format quick NOERR >> %initialize_offline_disk_command%
)
diskpart /s %initialize_offline_disk_command% > %initialize_offline_disk_log%
)
:========================create d and e partition=================
if exist %temp% del %temp%
echo list disk > list_disk.txt
diskpart /s list_disk.txt > %create_D_E_partition_log%
findstr /i "online" %create_D_E_partition_log% > %temp%
for /f "tokens=1,2 delims= " %%i in (%temp%) do set value=%%j
if %value% GTR 1 (
echo select disk 1 > %create_D_E_partition_command%
echo select partition 2 >> %create_D_E_partition_command%
echo assign letter=D >> %create_D_E_partition_command%
echo select disk 2 >> %create_D_E_partition_command%
echo select partition 2 >> %create_D_E_partition_command%
echo assign letter=E >> %create_D_E_partition_command%
diskpart /s %create_D_E_partition_command% > %create_D_E_partition_log%
goto END
)
echo select disk 1 > %create_D_E_partition_command%
echo select partition 2 >> %create_D_E_partition_command%
echo assign letter=D >> %create_D_E_partition_command%
echo select disk 0 >> %create_D_E_partition_command%
echo create partition primary NOERR >> %create_D_E_partition_command%
echo format quick NOERR >> %create_D_E_partition_command%
echo assign letter=E >> %create_D_E_partition_command%
diskpart /s %create_D_E_partition_command% > %create_D_E_partition_log%
goto END
:========================END======================================
:END
if exist %temp% del %temp%