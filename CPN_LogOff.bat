@echo off
set PATH="D:\[Portable]\PortableApps Platform\PortableApps\7-ZipPortable\App\7-Zip64";%PATH%
set WKP=D:\[CPN]\#Scripts
set log="%WKP%\Log.txt"
echo %date% %time%	Script [%~n0] Start.>>%log%

:CHKOFF
if not exist "U:\" (
	echo %date% %time%	....Missing RamDrive....Script [%~n0] Terminate...>>%log%
	goto END
)

for /f "tokens=2" %%i in ('whoami /user ^| findstr "S-"') do set SID=%%i
set RDF=RamDisk@%COMPUTERNAME%
set CPD=U:\!GoogleChromePortable\Data\
set CPF=ChromeProfile@%SID%
set CP64D=U:\!GoogleChromePortable64\Data\
set CP64F=ChromeProfile64@%SID%
set OPD=U:\!OperaPortable\Data\
set OPF=OperaProfile@%SID%
set FPD=U:\!FirefoxPortable\Data\
set FPF=FirefoxProfile@%SID%
set str=User Profile

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

:OFF

:BAK
echo Backup %str%......
echo %date% %time%	-Start Backup %str%.>>%log%
echo.

:BAKRD
echo Backup RamDisk......
echo %date% %time%	--Backup RamDisk.>>%log%
if exist "%WKP%\%RDF%.old.zip" move /Y "%WKP%\%RDF%.old.zip" "%WKP%\%RDF%.old"
if exist "%WKP%\%RDF%.zip" move /Y "%WKP%\%RDF%.zip" "%WKP%\%RDF%.old.zip"
7z a "%WKP%\%RDF%.zip" "U:\" -mx0 -mmt=on "-x!U:\TEMP" "-x!U:\TEST" "-x!U:\!*" "-x!U:\System Volume Information"
echo %date% %time%	--ErrorLevel=%errorlevel%.>>%log%
if exist "%WKP%\%RDF%.old" del /f /q "%WKP%\%RDF%.old"
echo.

:BAKCP
echo Backup Chrome %str%......
echo %date% %time%	--Backup Chrome %str%.>>%log%
if exist %CPD% (
	taskkill /F /IM chrome*
	if exist "%WKP%\%CPF%.old.zip" move /Y "%WKP%\%CPF%.old.zip" "%WKP%\%CPF%.old"
	if exist "%WKP%\%CPF%.zip" move /Y "%WKP%\%CPF%.zip" "%WKP%\%CPF%.old.zip"
	cd /d %CPD%
	7z a -mx1 -mmt=on "%WKP%\%CPF%.zip" %CPBK%
	echo %date% %time%	--ErrorLevel=%errorlevel%.>>%log%
	cd /d %WKP%\
	if exist "%WKP%\%CPF%.old" del /f /q "%WKP%\%CPF%.old"
)
echo.

:BAKCP64
echo Backup Chrome64 %str%......
echo %date% %time%	--Backup Chrome64 %str%.>>%log%
if exist %CP64D% (
	taskkill /F /IM chrome*
	if exist "%WKP%\%CP64F%.old.zip" move /Y "%WKP%\%CP64F%.old.zip" "%WKP%\%CP64F%.old"
	if exist "%WKP%\%CP64F%.zip" move /Y "%WKP%\%CP64F%.zip" "%WKP%\%CP64F%.old.zip"
	cd /d %CP64D%
	7z a -mx1 -mmt=on "%WKP%\%CP64F%.zip" %CPBK%
	echo %date% %time%	--ErrorLevel=%errorlevel%.>>%log%
	cd /d %WKP%\
	if exist "%WKP%\%CP64F%.old" del /f /q "%WKP%\%CP64F%.old"
)
echo.

:BAKFP
echo Backup Firefox %str%......
echo %date% %time%	--Backup Firefox %str%.>>%log%
if exist %FPD% (
	taskkill /F /IM firefox*
	if exist "%WKP%\%FPF%.old.zip" move /Y "%WKP%\%FPF%.old.zip" "%WKP%\%FPF%.old"
	if exist "%WKP%\%FPF%.zip" move /Y "%WKP%\%FPF%.zip" "%WKP%\%FPF%.old.zip"
	cd /d %FPD%
	7z a -mx1 -mmt=on "%WKP%\%FPF%.zip" %FPBK%
	echo %date% %time%	--ErrorLevel=%errorlevel%.>>%log%
	cd /d %WKP%\
	if exist "%WKP%\%FPF%.old" del /f /q "%WKP%\%FPF%.old"
)
echo.

:BAKOP
echo Backup Opera %str%......
echo %date% %time%	--Backup Opera %str%.>>%log%
if exist %OPD% (
	taskkill /F /IM opera*
	if exist "%WKP%\%OPF%.old.zip" move /Y "%WKP%\%OPF%.old.zip" "%WKP%\%OPF%.old"
	if exist "%WKP%\%OPF%.zip" move /Y "%WKP%\%OPF%.zip" "%WKP%\%OPF%.old.zip"
	cd /d %OPD%
	7z a -mx1 -mmt=on "%WKP%\%OPF%.zip" %OPBK%
	echo %date% %time%	--ErrorLevel=%errorlevel%.>>%log%
	cd /d %WKP%\
	if exist "%WKP%\%OPF%.old" del /f /q "%WKP%\%OPF%.old"
)
echo.

echo %date% %time%	-Backup %str% Done.>>%log%

:END
echo.
echo Script [%~n0] Done.
echo %date% %time%	Script [%~n0] Done.>>%log%
echo.>>%log%
exit
