@echo off
:: WinGet: Ensure Up To Date
:: Verifies WinGet is installed, then upgrades the App Installer package
:: itself so future winget commands use the latest engine.

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  WinGet: Ensure Up To Date
echo  Verifies WinGet is installed, then upgrades it.
echo ============================================================
echo.

where winget >nul 2>&1
if %errorLevel% NEQ 0 (
    echo WinGet is NOT installed.
    echo Run [1] Install WinGet first.
    echo.
    if not defined MAINT_NO_PAUSE pause
    exit /b 1
)

echo Current version:
winget --version
echo.

echo Checking for App Installer update...
winget upgrade --id Microsoft.AppInstaller -e --accept-source-agreements --accept-package-agreements
echo.

echo Done. Now running:
winget --version
echo.
if not defined MAINT_NO_PAUSE pause
