@echo off
:: WinGet Install: itch.io desktop app
:: Package ID: ItchIo.Itch
:: NOTE: If WinGet reports "no package found", use the WinGet menu's [6]
:: Search option with the query "itch" to confirm the current ID and update
:: this script.

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  WinGet Install: itch.io
echo  Package ID: ItchIo.Itch
echo ============================================================
echo.

where winget >nul 2>&1
if %errorLevel% NEQ 0 (
    echo WinGet is NOT installed. Use the WinGet menu's [1] Install WinGet first.
    echo.
    if not defined MAINT_NO_PAUSE pause
    exit /b 1
)

winget install --id ItchIo.Itch -e --accept-source-agreements --accept-package-agreements
echo.
if not defined MAINT_NO_PAUSE pause
