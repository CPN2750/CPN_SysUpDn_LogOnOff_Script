@echo off
set PATH="D:\[Portable]\PortableApps Platform\PortableApps\7-ZipPortable\App\7-Zip64";%PATH%
set log="%~dp0Log.txt"
echo.
echo %date% %time%	Script [%~n0] Started.>>%log%
echo Script [%~n0] Started.
echo.

cd.>%~dp0!LOCK
if exist %~dp0!RD-Error del /f /q %~dp0!RD-Error
set "U=U:\"
set RDF=RamDisk@%COMPUTERNAME%
set RD=0
set /a i=0

if /i [%1]==[/up] goto UP
if /i [%1]==[/dn] goto DN
if [%1]==[/?] goto HLP
if [%1]==[] goto MENU
goto INVALID

:MENU
echo.
echo Script [%~n0] 
echo.
echo 	MENU
echo 	====================================
echo.
echo 	[1] Run System Start-Up Scripts
echo.
echo 	[2] Run System Shut-Down Scripts
echo.
echo 	[9] Help
echo.
echo 	====================================
echo 	[0] EXIT
echo.

set OPT=
set /p OPT= "Please Input: "
echo.
if /i "%OPT%"=="1" goto UP
if /i "%OPT%"=="2" goto DN
if /i "%OPT%"=="9" goto HLP
if /i "%OPT%"=="0" goto END
echo [%OPT%] Invalid, Please Try Again......
echo.
goto MENU

:UP
echo %date% %time%	-System Start-Up Function Activated.>>%log%
echo 	-System Start-Up Function Activated....
echo.
echo %date% %time%		....waiting RamDrive Activate....>>%log%
echo 	....waiting RamDrive Activate....
echo.

:UP-CHK
set /a i+=1
if %i% GEQ 60 (
	echo %date% %time%		....RamDrive Not Function....>>%log%
	echo. RamDrive Not Function.
	echo.
	cd.>%~dp0!RD-Error
	goto UP-END
)

CALL :CHK
if "%RD%"=="0" (
	timeout /t 1
	goto UP-CHK
)

echo %date% %time%		....RamDrive Activated....>>%log%
echo 	....RamDrive Activated....
echo.

:UP-RUN
if not exist "%U%TEMP" ( md "%U%TEMP" )
if not exist "%U%![]" ( md "%U%![]" )

:UP-END
echo %date% %time%	-System Start-Up Function Completed.>>%log%
echo 	-System Start-Up Function Completed.
echo.
if [%1] neq [] (goto END) else (goto MENU)

:DN
echo %date% %time%	-System Shut-Down Function Activated.>>%log%
echo 	-System Shut-Down Function Activated......
echo.
CALL :CHK
if "%RD%"=="0" goto DN-END

:DN-RUN

:DN-END
echo %date% %time%	-System Shut-Down Function Completed.>>%log%
echo 	-System Shut-Down Function Completed.
echo.
if [%1] neq [] (goto END) else (goto MENU)

:INVALID
echo %date% %time%	Parameter Invalid.>>%log%
echo.
echo Parameter Invalid, /? for Help
echo.
goto END

:HLP
echo.
echo Help for This Script:
echo.
echo   ThisScript [/parameter]
echo.
echo 	Empty for MENU Mode
echo   /up	Run System Start-Up Scripts
echo   /dn	Run System Shut-Down Scripts
echo:  /?	Help
echo.
if [%1] neq [] (goto END) else (goto MENU)

:CHK
if not exist "%U%" (
	echo %date% %time%	....Checked RamDrive Not Exist....>>%log%
	echo 	....Checked RamDrive Not Exist....
	echo.
	set RD=0
) else (set RD=1)
exit /B

:END
del /f /q %~dp0!LOCK
echo %date% %time%	Script [%~n0] Done.>>%log%
echo Script [%~n0] Done.
echo.>>%log%
echo.
if [%1]==[] (timeout 2)
exit /B

