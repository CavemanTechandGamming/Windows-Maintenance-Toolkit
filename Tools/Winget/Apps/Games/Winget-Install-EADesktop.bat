@echo off
:: WinGet Install: EA app
:: Package ID: ElectronicArts.EADesktop

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  WinGet Install: EA app
echo  Package ID: ElectronicArts.EADesktop
echo ============================================================
echo.

where winget >nul 2>&1
if %errorLevel% NEQ 0 (
    echo WinGet is NOT installed. Use the WinGet menu's [1] Install WinGet first.
    echo.
    if not defined MAINT_NO_PAUSE pause
    exit /b 1
)

winget install --id ElectronicArts.EADesktop -e --accept-source-agreements --accept-package-agreements
echo.
if not defined MAINT_NO_PAUSE pause
