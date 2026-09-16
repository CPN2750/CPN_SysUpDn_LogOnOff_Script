@echo off
set PATH="D:\[Portable]\PortableApps Platform\PortableApps\7-ZipPortable\App\7-Zip64";%PATH%
set log="%~dp0Log.txt"
echo.
echo %date% %time%	Script [%~n0] Started.>>%log%
echo Script [%~n0] Started.
echo.

set str=Profiles on RamDisk
set "U=U:\"
set RDF=RamDisk@%COMPUTERNAME%
set /a j=0

:CHKLOCK
set /a j+=1
if %j% GEQ 60 (
	echo %date% %time%		....Check Lock Timeout....>>%log%
	echo ....Check Lock Timeout....
	echo.
	goto END
)

if exist "%~dp0!LOCK" (
	timeout /t 1
	goto CHKLOCK
)

if exist "%~dp0!RD-Error" (
echo %date% %time%		....RamDrive Not Function....Terminate...>>%log%
echo 	....RamDrive Not Function....Terminate...
echo.
del /f /q %~dp0!RD-Error
goto END
)

if not exist "%U%" (
echo %date% %time%		....RamDrive Not Function....Terminate...>>%log%
echo 	....RamDrive Not Function....Terminate...
echo.
goto END
)

for /f "tokens=2" %%i in ('whoami /user ^| findstr "S-"') do set SID=%%i
set CPD=%U%!GoogleChromePortable\Data\
set CPF=ChromeProfile@%SID%
set OPD=%U%!OperaPortable\Data\
set OPF=OperaProfile@%SID%
set FPD=%U%!FirefoxPortable\Data\
set FPF=FirefoxProfile@%SID%

set RDBK=^
	"%U%" ^
	"-x!%U%!*" ^
	"-x!%U%TEMP" ^
	"-x!%U%PSAutoRecover" ^
	"-x!%U%TEST" ^
	"-x!%U%System Volume Information"

set CPBK=^
	"PortableApps.comInstaller" ^
	"profile\Local State" ^
	"profile\Default\databases" ^
	"profile\Default\Extension Rules" ^
	"profile\Default\Extension Scripts" ^
	"profile\Default\Extension State" ^
	"profile\Default\Extensions" ^
	"profile\Default\File System" ^
	"profile\Default\Local Extension Settings" ^
	"profile\Default\Local Storage" ^
	"profile\Default\Managed Extension Settings" ^
	"profile\Default\Network" ^
	"profile\Default\Bookmarks" ^
	"profile\Default\Google Profile Picture.png" ^
	"profile\Default\Preferences" ^
	"profile\Default\Secure Preferences" ^
	"profile\Default\trusted_vault.pb" ^
	"profile\Default\Web Data" ^
	"-xr!*.old"

set FPBK=^
	"plugins" ^
	"settings" ^
	"profile\bookmarkbackups" ^
	"profile\extensions" ^
	"profile\gmp-gmpopenh264" ^
	"profile\gmp-widevinecdm" ^
	"profile\settings" ^
	"profile\storage" ^
	"profile\addons.json" ^
	"profile\addonStartup.json.lz4" ^
	"profile\cookies.sqlite" ^
	"profile\cookies.sqlite-shm" ^
	"profile\cookies.sqlite-wal" ^
	"profile\extensions.json" ^
	"profile\extension-preferences.json" ^
	"profile\extension-settings.json" ^
	"profile\formhistory.sqlite" ^
	"profile\key4.db" ^
	"profile\logins.json" ^
	"profile\prefs.js" ^
	"profile\sessionCheckpoints.json" ^
	"profile\signedInUser.json" ^
	"profile\xulstore.json" ^
	"-xr!*.old"

set OPBK=^
	"PortableApps.comInstaller" ^
	"settings" ^
	"profile\data\Default\databases" ^
	"profile\data\Default\Extension Rules" ^
	"profile\data\Default\Extension Scripts" ^
	"profile\data\Default\Extension State" ^
	"profile\data\Default\Extensions" ^
	"profile\data\Default\Local Extension Settings" ^
	"profile\data\Default\Local Storage" ^
	"profile\data\Default\Network" ^
	"profile\data\Default\Bookmarks" ^
	"profile\data\Default\BookmarksExtras" ^
	"profile\data\Default\Login Data" ^
	"profile\data\Default\Preferences" ^
	"profile\data\Default\Web Data" ^
	"profile\data\Local State" ^
	"-xr!*.old"

if /i [%1]==[/on] goto ON
if /i [%1]==[/off] goto OFF
if /i [%1]==[/b] goto BAK
if /i [%1]==[/r] goto RES
if [%1]==[/?] goto HLP
if [%1]==[] goto MENU
goto INVALID

:MENU
echo.
echo 	MENU
echo 	====================================
echo.
echo 	[1] Backup %str%
echo.
echo 	[2] Restore %str%
echo.
echo 	[9] Help
echo.
echo 	====================================
echo 	[0] EXIT
echo.

set OPT=
set /p OPT= "Please Input: "
echo.
if /i "%OPT%"=="1" goto BAK
if /i "%OPT%"=="2" goto RES
if /i "%OPT%"=="9" goto HLP
if /i "%OPT%"=="0" goto END
echo [%OPT%] Invalid, Please Try Again......
echo.
goto MENU

:ON
set "X=User Logon"
goto ONRES

:RES
set "X=Restore"
goto ONRES

:ONRES
echo %date% %time%	-%X% Function Activated.>>%log%
echo 	-%X% Function Activated....
echo.

:RESRD
echo %date% %time%	--Restore RamDisk.....>>%log%
echo 	--Restore RamDisk.....
echo.
7z x -y "%~dp0%RDF%.zip" -o"%U%"
echo %date% %time%	--ErrorLevel=%errorlevel%.>>%log%

:RESCP
echo %date% %time%	--Restore Chrome Profile.....>>%log%
echo 	--Restore Chrome Profile......
echo.
if exist "%~dp0%CPF%.zip" (
	if exist "%CPD%" rmdir /s /q "%CPD%"
	7z x "%~dp0%CPF%.zip" -o"%CPD%"
	echo %date% %time%	--ErrorLevel=%errorlevel%.>>%log%
	echo 	--ErrorLevel=%errorlevel%.
	echo.
)
if not exist %CPD% ( md %CPD% )

:RESFP
echo %date% %time%	--Restore Firefox Profile.....>>%log%
echo 	--Restore Firefox Profile.....
echo.
if exist "%~dp0%FPF%.zip" (
	if exist "%FPD%" rmdir /s /q "%FPD%"
	7z x "%~dp0%FPF%.zip" -o"%FPD%"
	echo %date% %time%	--ErrorLevel=%errorlevel%.>>%log%
	echo 	--ErrorLevel=%errorlevel%.
	echo.
)
if not exist %FPD% ( md %FPD% )

:RESOP
echo %date% %time%	--Restore Opera Profile.....>>%log%
echo 	--Restore Opera Profile.....
echo.
if exist "%~dp0%OPF%.zip" (
	if exist "%OPD%" rmdir /s /q "%OPD%"
	7z x "%~dp0%OPF%.zip" -o"%OPD%"
	echo %date% %time%	--ErrorLevel=%errorlevel%.>>%log%
	echo 	--ErrorLevel=%errorlevel%.
	echo.
)
if not exist %OPD% ( md %OPD% )

:RUN
if not exist "%U%![]" ( md "%U%![]" )
goto ZEND


:OFF
set "X=User Logoff"
goto OFFBAK

:BAK
set "X=Backup"
goto OFFBAK

:OFFBAK
echo %date% %time%	-%X% Function Activated.>>%log%
echo 	-%X% Function Activated.....
echo.

:BAKRD
echo %date% %time%	--Backup RamDisk.....>>%log%
echo 	--Backup RamDisk.....
echo.
if exist "%~dp0%RDF%.old.zip" move /Y "%~dp0%RDF%.old.zip" "%~dp0%RDF%.old"
if exist "%~dp0%RDF%.zip" move /Y "%~dp0%RDF%.zip" "%~dp0%RDF%.old.zip"
7z a -mx0 -mmt=on "%~dp0%RDF%.zip" %RDBK%
echo %date% %time%	--ErrorLevel=%errorlevel%.>>%log%
if exist "%~dp0%RDF%.old" del /f /q "%~dp0%RDF%.old"
echo 	--ErrorLevel=%errorlevel%.
echo.

:BAKCP
if exist %CPD% (
	echo %date% %time%	--Backup Chrome Profile.....>>%log%
	echo 	--Backup Chrome Profile.....
	echo.
	taskkill /F /IM chrome*
	if exist "%~dp0%CPF%.old.zip" move /Y "%~dp0%CPF%.old.zip" "%~dp0%CPF%.old"
	if exist "%~dp0%CPF%.zip" move /Y "%~dp0%CPF%.zip" "%~dp0%CPF%.old.zip"
	cd /d %CPD%
	7z a -mx1 -mmt=on "%~dp0%CPF%.zip" %CPBK%
	echo %date% %time%	--ErrorLevel=%errorlevel%.>>%log%
	echo 	--ErrorLevel=%errorlevel%.
	echo.
	cd /d %~dp0
	if exist "%~dp0%CPF%.old" del /f /q "%~dp0%CPF%.old"
)

:BAKFP
if exist %FPD% (
	echo %date% %time%	--Backup Firefox Profile.....>>%log%
	echo 	--Backup Firefox Profile.....
	echo.
	taskkill /F /IM firefox*
	if exist "%~dp0%FPF%.old.zip" move /Y "%~dp0%FPF%.old.zip" "%~dp0%FPF%.old"
	if exist "%~dp0%FPF%.zip" move /Y "%~dp0%FPF%.zip" "%~dp0%FPF%.old.zip"
	cd /d %FPD%
	7z a -mx1 -mmt=on "%~dp0%FPF%.zip" %FPBK%
	echo %date% %time%	--ErrorLevel=%errorlevel%.>>%log%
	echo 	--ErrorLevel=%errorlevel%.
	echo.
	cd /d %~dp0
	if exist "%~dp0%FPF%.old" del /f /q "%~dp0%FPF%.old"
)

:BAKOP
if exist %OPD% (
	echo %date% %time%	--Backup Opera Profile.....>>%log%
	echo 	--Backup Opera Profile.....
	echo.
	taskkill /F /IM opera*
	if exist "%~dp0%OPF%.old.zip" move /Y "%~dp0%OPF%.old.zip" "%~dp0%OPF%.old"
	if exist "%~dp0%OPF%.zip" move /Y "%~dp0%OPF%.zip" "%~dp0%OPF%.old.zip"
	cd /d %OPD%
	7z a -mx1 -mmt=on "%~dp0%OPF%.zip" %OPBK%
	echo %date% %time%	--ErrorLevel=%errorlevel%.>>%log%
	echo 	--ErrorLevel=%errorlevel%.
	echo.
	cd /d %~dp0
	if exist "%~dp0%OPF%.old" del /f /q "%~dp0%OPF%.old"
)

:ZEND
echo %date% %time%	-%X% Function Completed.>>%log%
echo 	-%X% Function Completed.
echo.
if [%1] neq [] (goto END) else (goto MENU)

:INVALID
echo.
echo %date% %time%	Parameter Invalid.>>%log%
echo Parameter Invalid, /? for Help.
echo.
goto END

:HLP
echo.
echo Help for This Script:
echo.
echo   ThisScript [/parameter]
echo.
echo 	Empty for MENU Mode
echo   /on	Restore %str%s to RamDisk
echo   /off	Backup %str%s from RamDisk
echo   /b	Backup %str%
echo   /r	Restore %str%
echo:  /?	Help
echo.
if [%1] neq [] (goto END) else (goto MENU)

:END
echo %date% %time%	Script [%~n0] Done.>>%log%
echo Script [%~n0] Done.
echo.>>%log%
echo.
if [%1]==[] (timeout 2)
exit /B

