@echo off

::�趨svg��ʽ�ļ�����Ŀ¼
set floder=C:\Users\fengk\Desktop\Change_Name
::�趨svg��ʽ�ļ������̷����˴�����C��
C:

cd %floder%

for /f "delims=" %%i in ('dir /b %floder%') do call :RenameFile %%i


:RenameFile
echo %1 | find /i "35kV�ƿӱ��վ"
if not errorlevel 1 (
for /F "eol= delims=_ tokens=1*" %%i in ("%1")  do ren %1 �ʻ��ƿӱ��վ_%%j )

echo %1 | find /i "35kV������վ"
if not errorlevel 1 (
for /F "eol= delims=_ tokens=1*" %%i in ("%1")  do ren %1 ����������վ_%%j )
goto :EOF