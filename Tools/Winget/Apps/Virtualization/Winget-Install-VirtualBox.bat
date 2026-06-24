@echo off
:: WinGet Install: VirtualBox
:: Package ID: Oracle.VirtualBox

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  WinGet Install: VirtualBox
echo  Package ID: Oracle.VirtualBox
echo ============================================================
echo.

where winget >nul 2>&1
if %errorLevel% NEQ 0 (
    echo WinGet is NOT installed. Use the WinGet menu's [1] Install WinGet first.
    echo.
    if not defined MAINT_NO_PAUSE pause
    exit /b 1
)

winget install --id Oracle.VirtualBox -e --accept-source-agreements --accept-package-agreements
echo.
if not defined MAINT_NO_PAUSE pause
