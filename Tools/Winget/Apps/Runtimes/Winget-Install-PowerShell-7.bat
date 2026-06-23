@echo off
:: WinGet Install: PowerShell 7  (modern cross-platform PowerShell)
:: Package ID: Microsoft.PowerShell
:: Installs alongside Windows PowerShell 5.1 -- does NOT replace it.

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  WinGet Install: PowerShell 7
echo  Package ID: Microsoft.PowerShell
echo  Installs alongside Windows PowerShell 5.1 (does not replace it).
echo ============================================================
echo.

where winget >nul 2>&1
if %errorLevel% NEQ 0 (
    echo WinGet is NOT installed. Use the WinGet menu's [1] Install WinGet first.
    echo.
    if not defined MAINT_NO_PAUSE pause
    exit /b 1
)

winget install --id Microsoft.PowerShell -e --accept-source-agreements --accept-package-agreements
echo.
if not defined MAINT_NO_PAUSE pause
