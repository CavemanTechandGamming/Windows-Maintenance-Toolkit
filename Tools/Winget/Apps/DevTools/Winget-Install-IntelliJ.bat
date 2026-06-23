@echo off
:: WinGet Install: IntelliJ IDEA Community Edition (free)
:: Package ID: JetBrains.IntelliJIDEA.Community
:: For Ultimate (paid), change the ID to JetBrains.IntelliJIDEA.Ultimate

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  WinGet Install: IntelliJ IDEA Community Edition
echo  Package ID: JetBrains.IntelliJIDEA.Community
echo ============================================================
echo.

where winget >nul 2>&1
if %errorLevel% NEQ 0 (
    echo WinGet is NOT installed. Use the WinGet menu's [1] Install WinGet first.
    echo.
    if not defined MAINT_NO_PAUSE pause
    exit /b 1
)

winget install --id JetBrains.IntelliJIDEA.Community -e --accept-source-agreements --accept-package-agreements
echo.
if not defined MAINT_NO_PAUSE pause
