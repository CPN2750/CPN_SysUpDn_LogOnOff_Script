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
