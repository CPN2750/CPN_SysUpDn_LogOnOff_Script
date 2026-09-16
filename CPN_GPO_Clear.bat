@echo off
chcp 65001 >nul
title CPN GPO 自動化配置清理工具

:: 宣告工作路徑
set "GPO_M=C:\Windows\System32\GroupPolicy\Machine\Scripts"
set "GPO_U=C:\Windows\System32\GroupPolicy\User\Scripts"
set "REG_S=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\Scripts"

:: 【核心加固】檢查最高權限並提權
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -NoProfile -ExecutionPolicy Bypass ^
        -Command "Start-Process cmd -ArgumentList '/c ""%~f0""' -Verb RunAs"
    exit /b
)

echo [進度] 強制移除實體設定檔...
del /f /q /a "%GPO_M%\scripts.ini" >nul 2>&1
del /f /q /a "%GPO_U%\scripts.ini" >nul 2>&1

echo [進度] 抹除系統註冊表殘留...
reg delete "%REG_S%\Startup" /f >nul 2>&1
reg delete "%REG_S%\Shutdown" /f >nul 2>&1

echo [進度] 強制重新整理群組原則...
gpupdate /force

echo [成功] GPO 全套配置已完全還原空白。
timeout /t 3 >nul
exit /b 0
