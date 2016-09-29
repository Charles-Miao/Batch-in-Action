@echo off

set listfile=D:\ServerCheck\CheckSVN\list.txt
set headfile=D:\ServerCheck\CheckSVN\Head.txt
set tempfile=D:\ServerCheck\CheckSVN\temp.txt
set tempfile2=D:\ServerCheck\CheckSVN\temp2.txt
set sendfile=D:\ServerCheck\CheckSVN\CheckMollyB1SVN.txt

if exist %listfile% del %listfile%
if exist %headfile% del %headfile%
if exist %tempfile% del %tempfile%
if exist %tempfile2% del %tempfile2%
if exist %sendfile% del %sendfile%

d:
cd D:\ServerCheck\CheckSVN

for /f "tokens=1,2 delims=," %%i in (Config.ini) do (
call :CheckSVN %%i %%j
)

goto send

echo ***************************************Check SVN Function************************************************
:CheckSVN
set ProgramPath=%1
set VerFile=%2
::judge version is changed or not, if not change skip record function
svn list -v %ProgramPath% >%listfile%
type %listfile% | linex -l 1 >%headfile%
for /f "tokens=1 delims= " %%i in (%Headfile%) do (
set /a j=%%i-1
set /a k=%%i)
for /f %%i in ('type %VerFile%') do set lastver=%%i
if "%k%"=="%lastver%" goto CheckSVN_END
::record versions and modifier and time
svn log -r %k% %ProgramPath% > %tempfile%
findstr /i "+0800" %tempfile% > %tempfile2%

for /f "tokens=1,2,3 delims=|" %%i in (%tempfile2%) do (
echo ------------------------------------------------------------------------ >> %sendfile%
echo ---------------------versions and modifier and time--------------------- >> %sendfile%
echo ------------------------------------------------------------------------ >> %sendfile%
echo Versions:  %%i >> %sendfile%
echo Modifier: %%j >> %sendfile%
echo Modified time: %%k >> %sendfile%
echo.>PRN >> %sendfile%
)
::record commit description
echo ------------------------------------------------------------------------ >> %sendfile%
echo ---------------------commit description--------------------------------- >> %sendfile%
svn log -r %k% %ProgramPath% > %tempfile%
findstr /i /v "+0800" %tempfile% >> %sendfile%
::record detail messages
echo ---------------------detail messages------------------------------------ >> %sendfile%
svn log -r %k% -v %ProgramPath% >> %sendfile%
::svn log -r %k% -v %ProgramPath%>>%sendfile%
::svn diff -r %j%:%k% %ProgramPath%>>%sendfile% 
echo %k%
echo %k% >%VerFile%
:CheckSVN_END
if exist %listfile% del %listfile%
if exist %headfile% del %headfile%
if exist %tempfile% del %tempfile%
if exist %tempfile2% del %tempfile2%

goto :EOF
echo ***************************************Check SVN Function************************************************

:send
echo open 192.168.123.71>tmp_ftp.txt
echo imagecrc>>tmp_ftp.txt
echo 5CTEconsole>>tmp_ftp.txt
echo put %sendfile%>>tmp_ftp.txt
echo bye>>tmp_ftp.txt
ftp -s:tmp_ftp.txt
:end