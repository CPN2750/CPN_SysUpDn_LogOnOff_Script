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
