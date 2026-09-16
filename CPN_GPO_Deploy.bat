@echo off
chcp 65001 >nul
title CPN GPO 自動化觸發部署工具

:: 宣告工作路徑
set "WKP=D:\[CPN]\#Scripts"
set "GPO_M=C:\Windows\System32\GroupPolicy\Machine\Scripts"
set "GPO_U=C:\Windows\System32\GroupPolicy\User\Scripts"
set "REG_S=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\Scripts"

:: 檢查管理員最高權限並分行提權
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -NoProfile -ExecutionPolicy Bypass ^
        -Command "Start-Process cmd -ArgumentList '/c ""%~f0""' -Verb RunAs"
    exit /b
)

echo [進度] 建立實體資料夾...
if not exist "%GPO_M%" md "%GPO_M%"
if not exist "%GPO_U%" md "%GPO_U%"

echo [進度] 寫入 GPO INI 設定檔...
:: 電腦設定：開機與關機
(
    echo [Startup]
    echo 0CmdLine=%WKP%\#CPN_SysUpDn.bat
    echo 0Parameters=/up
    echo [Shutdown]
    echo 0CmdLine=%WKP%\#CPN_SysUpDn.bat
    echo 0Parameters=/dn
) > "%GPO_M%\scripts.ini"

:: 使用者設定：登入與登出
(
    echo [Logon]
    echo 0CmdLine=%WKP%\$CPN_LogOnOff.bat
    echo 0Parameters=/on
    echo [Logoff]
    echo 0CmdLine=%WKP%\$CPN_LogOnOff.bat
    echo 0Parameters=/off
) > "%GPO_U%\scripts.ini"

echo [進度] 註冊電腦開機系統識別碼...
reg add "%REG_S%\Startup\0" ^
    /v "GPO-ID" /t REG_SZ /d "LocalGPO" /f >nul
reg add "%REG_S%\Startup\0" ^
    /v "SOM-ID" /t REG_SZ /d "LocalGPO" /f >nul
reg add "%REG_S%\Startup\0\0" ^
    /v "CmdLine" /t REG_SZ /d "%WKP%\#CPN_SysUpDn.bat" /f >nul
reg add "%REG_S%\Startup\0\0" ^
    /v "Parameters" /t REG_SZ /d "/up" /f >nul

echo [進度] 註冊電腦關機系統識別碼...
reg add "%REG_S%\Shutdown\0" ^
    /v "GPO-ID" /t REG_SZ /d "LocalGPO" /f >nul
reg add "%REG_S%\Shutdown\0" ^
    /v "SOM-ID" /t REG_SZ /d "LocalGPO" /f >nul
reg add "%REG_S%\Shutdown\0\0" ^
    /v "CmdLine" /t REG_SZ /d "%WKP%\#CPN_SysUpDn.bat" /f >nul
reg add "%REG_S%\Shutdown\0\0" ^
    /v "Parameters" /t REG_SZ /d "/dn" /f >nul

echo [進度] 強制重新整理群組原則...
gpupdate /force
echo [成功] CPN 全套 GPO 部署完畢。
timeout /t 3 >nul
exit /b 0
