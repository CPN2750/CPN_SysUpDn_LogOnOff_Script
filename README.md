# CPN SysUpDn & LogOnOff Script
## 📌 專案簡介
此專案提供一組 Windows 批次檔，在 **系統啟動 / 關機 / 使用者登入 / 登出** 時自動執行，備份與還原**RAMDISK**中的設定檔。  

---

## 📂 專案結構
```
CPN-SysUpDn-LogOnOff/
├── README.md              # 專案說明文件
├── CPN_SysUp.bat          # 系統開機批次檔
├── CPN_LogOn.bat          # 使用者登入批次檔
├── CPN_LogOff.bat         # 使用者登出批次檔
├── CPN_SysDn.bat          # 系統關機批次檔
└── LICENSE                # 授權條款 (MIT)
```

---

## 🔑重點說明
+ 🖥️ 系統啟動 `CPN_SysUp.bat`
	- 啟動時檢查並等待 U:\ RamDisk 是否掛載成功（最多 60 秒）。
	- 建立 !LOCK 避免後續檔案執行錯誤。
	- 若失敗則記錄錯誤並建立 !RD-Error。
	- 成功後建立 U:\TEMP 目錄。
	
+ 👤 使用者登入 `CPN_LogOn.bat`
	- 登入時檢查 RamDisk 狀態，若缺失則終止。
	- 使用 whoami /user 取得 SID，生成對應的 Profile 名稱。
	- 依序還原使用者設定檔，透過 7z x 解壓縮 .zip 檔到 RamDisk。
	
+ 👤 使用者登出 `CPN_LogOff.bat`
	- 登出時檢查 RamDisk，若存在則進行備份。
	- 定義各設定檔需要備份的檔案與目錄（排除 .old）。
	- 執行 taskkill 關閉應用，避免檔案被鎖定。
	- 使用 7z a 壓縮成 .zip，並保留 .old.zip 作為前一版本。
	
+ 🖥️ 系統關機 `CPN_SysDn.bat`
	- 系統關機流程，目前是空殼，僅記錄開始與結束。
	- 可依照需求擴充腳本。
	
---

## 📝程式碼
### [CPN_SysUp.bat](/CPN_SysUp.bat)
```bat
@echo off
set PATH="D:\[Portable]\PortableApps Platform\PortableApps\7-ZipPortable\App\7-Zip64";%PATH%
set WKP=D:\[CPN]\#Scripts
set log="%WKP%\Log.txt"
echo %date% %time%	Script [%~n0] Start.>>%log%
set RDF=%WKP%\RamDisk@%COMPUTERNAME%
del /f /q %WKP%\!RD-Error
cd.>%WKP%\!LOCK
set /a i=0

:UP
echo %date% %time%	-Run System Start-Up.>>%log%
echo Run System Start-Up Scripts......
echo.
echo %date% %time%	....wait RamDrive Activate....>>%log%
echo 	....wait RamDrive Activate....

:CHKUP
set /a i+=1
if %i% GEQ 60 (
	echo %date% %time%	....RamDrive Not Working....>>%log%
	msg * RamDrive Not Working.
	cd.>%WKP%\!RD-Error
	goto END
)
if not exist "U:\" (
	timeout /t 1
	goto CHKUP
)
echo %date% %time%	....RamDrive Activated....>>%log%

:RUN
if exist "U:\" (
	if not exist "U:\TEMP" ( md "U:\TEMP" )
)

:END
echo.
echo Done.
echo %date% %time%	Script [%~n0] Done.>>%log%
echo.>>%log%
del /f /q %WKP%\!LOCK
exit

``` 

---

### [CPN_SysDn.bat](CPN_SysDn.bat)
```bat
@echo off
set PATH="D:\[Portable]\PortableApps Platform\PortableApps\7-ZipPortable\App\7-Zip64";%PATH%
set WKP=D:\[CPN]\#Scripts
set log="%WKP%\Log.txt"
echo %date% %time%	Script [%~n0] Start.>>%log%
set RDF=%WKP%\RamDisk@%COMPUTERNAME%

:DN
echo %date% %time%	-Run System Shut-Down.>>%log%
echo.
echo Run System Shut-Down Scripts......

:CHKDN

:RUN

:END
echo.
echo Done.
echo %date% %time%	Script [%~n0] Done.>>%log%
echo.>>%log%
del /f /q %WKP%\!LOCK
exit
```
---
### [CPN_LogOn.bat](CPN_LogOn.bat)
```bat
@echo off
set PATH="D:\[Portable]\PortableApps Platform\PortableApps\7-ZipPortable\App\7-Zip64";%PATH%
set WKP=D:\[CPN]\#Scripts
set log="%WKP%\Log.txt"
echo %date% %time%	Script [%~n0] Start.>>%log%
set /a j=0

:CHKON
if exist "%WKP%\!LOCK" (
	timeout /t 1 >nul
	set /a j+=1
	if %j% GEQ 60 (
		echo %date% %time%	....Timeout waiting for lock....>>%log%
		goto END
	)
	goto CHKON
)

if exist "%WKP%\!RD-Error" (
	echo %date% %time%	....Missing RamDrive....Script [%~n0] Terminate...>>%log%
	del /f /q %WKP%\!RD-Error
	goto END
)

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

:ON
echo %date% %time%	-Start User Logon Scripts.>>%log%
echo Run User Logon Scripts......

:RUN
if not exist "U:\![]" ( md "U:\![]" )

:RES
echo %date% %time%	--Start Restore %str%.>>%log%
echo Start Restore %str%......
echo.

:RESRD
echo Restore RamDisk......
echo %date% %time%	---Restore RamDisk.>>%log%
if exist "%WKP%\%RDF%.zip" (
	7z x "%WKP%\%RDF%.zip" -o"U:\" -aoa
	echo %date% %time%	---ErrorLevel=%errorlevel%.>>%log%
)
echo.

:RESCP
echo Restore Chrome %str%......
echo %date% %time%	---Restore Chrome %str%.>>%log%
if exist "%WKP%\%CPF%.zip" (
	if exist "%CPD%" rmdir /s /q "%CPD%"
	7z x "%WKP%\%CPF%.zip" -o"%CPD%"
	echo %date% %time%	---ErrorLevel=%errorlevel%.>>%log%
)
echo.

:RESCP64
echo Restore Chrome64 %str%......
echo %date% %time%	---Restore Chrome64 %str%.>>%log%
if exist "%WKP%\%CP64F%.zip" (
	if exist "%CP64D%" rmdir /s /q "%CP64D%"
	7z x "%WKP%\%CP64F%.zip" -o"%CP64D%"
	echo %date% %time%	---ErrorLevel=%errorlevel%.>>%log%
)
echo.

:RESFP
echo Restore Firefox %str%......
echo %date% %time%	---Restore Firefox %str%.>>%log%
if exist "%WKP%\%FPF%.zip" (
	if exist "%FPD%" rmdir /s /q "%FPD%"
	7z x "%WKP%\%FPF%.zip" -o"%FPD%"
	echo %date% %time%	---ErrorLevel=%errorlevel%.>>%log%
)
echo.

:RESOP
echo Restore Opera %str%......
echo %date% %time%	---Restore Opera %str%.>>%log%
if exist "%WKP%\%OPF%.zip" (
	if exist "%OPD%" rmdir /s /q "%OPD%"
	7z x "%WKP%\%OPF%.zip" -o"%OPD%"
	echo %date% %time%	---ErrorLevel=%errorlevel%.>>%log%
)
echo.

echo %date% %time%	--Restore %str% Done.>>%log%
echo %date% %time%	-User Logon Script Done.>>%log%

:END
echo.
echo Script [%~n0] Done.
echo %date% %time%	Script [%~n0] Done.>>%log%
echo.>>%log%
exit
```
---
### [CPN_LogOff.bat](CPN_LogOff.bat)
```bat
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
```
---
