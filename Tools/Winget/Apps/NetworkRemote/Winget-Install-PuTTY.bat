@echo off
:: WinGet Install: PuTTY
:: Package ID: PuTTY.PuTTY

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  WinGet Install: PuTTY
echo  Package ID: PuTTY.PuTTY
echo ============================================================
echo.

where winget >nul 2>&1
if %errorLevel% NEQ 0 (
    echo WinGet is NOT installed. Use the WinGet menu's [1] Install WinGet first.
    echo.
    if not defined MAINT_NO_PAUSE pause
    exit /b 1
)

winget install --id PuTTY.PuTTY -e --accept-source-agreements --accept-package-agreements
echo.
if not defined MAINT_NO_PAUSE pause
