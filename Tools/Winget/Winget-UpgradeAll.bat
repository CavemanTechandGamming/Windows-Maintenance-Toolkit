@echo off
:: WinGet: Upgrade All
:: Upgrades every WinGet-managed application to its latest version.

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  WinGet: Upgrade All Installed Apps
echo  winget upgrade --all
echo  Can take a while if many apps need updating.
echo ============================================================
echo.

where winget >nul 2>&1
if %errorLevel% NEQ 0 (
    echo WinGet is NOT installed. Run [1] Install WinGet first.
    echo.
    if not defined MAINT_NO_PAUSE pause
    exit /b 1
)

winget upgrade --all --accept-source-agreements --accept-package-agreements
echo.
if not defined MAINT_NO_PAUSE pause
