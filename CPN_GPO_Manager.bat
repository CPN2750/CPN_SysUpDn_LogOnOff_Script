@echo off
chcp 65001 >nul
title CPN GPO Deploy Control Console

:: 宣告工作路徑
set "WKP=%~dp0"
set "GPO_M=C:\Windows\System32\GroupPolicy\Machine\Scripts"
set "GPO_U=C:\Windows\System32\GroupPolicy\User\Scripts"
set "REG_S=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\Scripts"
set "REG_UP=%REG_S%\Startup"
set "REG_DN=%REG_S%\Shutdown"

:: 判斷是否需要提權架構
net session >nul 2>&1
if %errorLevel%==0 goto PRIVILEGE_OK

:: 建立一個臨時的 VBS 腳本來調用 Windows 認可的最高權限 Shell
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\uac.vbs"
echo UAC.ShellExecute "cmd.exe", "/c """"%~f0"""" %1", "", "runas", 1 >> "%temp%\uac.vbs"

:: 執行 VBS 提權並立刻將其刪除乾淨
wscript.exe "%temp%\uac.vbs"
del /f /q "%temp%\uac.vbs" >nul 2>&1
exit /b

:PRIVILEGE_OK
cd /d "%~dp0"

:: 參數分流檢查
if /i "%~1" == "/setup"	goto SETUP
if /i "%~1" == "/clean"	goto CLEAN
if /i "%~1" == "/?"	goto HELP
if "%~1" == ""		goto MENU

:MENU
cls
echo ==================================================
echo     CPN GPO AUTOMATIC DEPLOY CONTROL CONSOLE
echo     Working Directory: %WKP%
echo ==================================================
echo.
echo     [1] Deploy All GPO Configurations (Setup)
echo.
echo     [2] Clear All GPO Configurations (Clean)
echo.
echo     [9] View Parameters Specification (Help)
echo.
echo --------------------------------------------------
echo     [0] Exit Console (EXIT)
echo ==================================================
set "CHOICE="
set /p CHOICE="Please Input Option (0-9): "
echo.

if "%CHOICE%" == "1" goto SETUP
if "%CHOICE%" == "2" goto CLEAN
if "%CHOICE%" == "9" goto HELP
if "%CHOICE%" == "0" goto :EOF
goto MENU

:SETUP
echo [Progress] Creating physical directories...
if not exist "%GPO_M%" md "%GPO_M%"
if not exist "%GPO_U%" md "%GPO_U%"

echo [Progress] Writing GPO INI configuration files...
(
    echo [Startup]
    echo 0CmdLine=%WKP%#CPN_SysUpDn.bat
    echo 0Parameters=/up
    echo [Shutdown]
    echo 0CmdLine=%WKP%#CPN_SysUpDn.bat
    echo 0Parameters=/dn
) > "%GPO_M%\scripts.ini"

(
    echo [Logon]
    echo 0CmdLine=%WKP%$CPN_LogOnOff.bat
    echo 0Parameters=/on
    echo [Logoff]
    echo 0CmdLine=%WKP%$CPN_LogOnOff.bat
    echo 0Parameters=/off
) > "%GPO_U%\scripts.ini"

echo [Progress] Registering computer startup script registry...
reg add "%REG_UP%\0" /v "GPO-ID" /t REG_SZ /d "LocalGPO" /f >nul
reg add "%REG_UP%\0" /v "SOM-ID" /t REG_SZ /d "LocalGPO" /f >nul
reg add "%REG_UP%\0\0" /v "CmdLine" /t REG_SZ /d "%WKP%#CPN_SysUpDn.bat" /f >nul
reg add "%REG_UP%\0\0" /v "Parameters" /t REG_SZ /d "/up" /f >nul

echo [Progress] Registering computer shutdown script registry...
reg add "%REG_DN%\0" /v "GPO-ID" /t REG_SZ /d "LocalGPO" /f >nul
reg add "%REG_DN%\0" /v "SOM-ID" /t REG_SZ /d "LocalGPO" /f >nul
reg add "%REG_DN%\0\0" /v "CmdLine" /t REG_SZ /d "%WKP%#CPN_SysUpDn.bat" /f >nul
reg add "%REG_DN%\0\0" /v "Parameters" /t REG_SZ /d "/dn" /f >nul
goto REFRESH

:CLEAN
echo [Progress] Removing physical configuration files...
del /f /q /a "%GPO_M%\scripts.ini" >nul 2>&1
del /f /q /a "%GPO_U%\scripts.ini" >nul 2>&1

echo [Progress] Erasing system registry remnants...
reg delete "%REG_S%\0" /f >nul 2>&1
goto REFRESH

:REFRESH
echo [Progress] Forcing group policy update...
gpupdate /force
echo [Success] Command executed successfully.
echo.
if "%~1" == "" ( pause & goto MENU )
goto :EOF

:HELP
echo --------------------------------------------------
echo  Manual Double-Click	==^> Activate Interactive Menu Mode
echo  Command Parameter	==^> %~nx0 /setup	(Auto Deploy)
echo  Command Parameter	==^> %~nx0 /clean	(Auto Remove)
echo  Command Parameter	==^> %~nx0 /?	(View Usage Help)
echo --------------------------------------------------
echo.
if "%~1" == "" ( pause & goto MENU )
exit /b 0
