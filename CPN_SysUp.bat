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
