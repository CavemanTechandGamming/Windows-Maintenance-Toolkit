@echo off
:: WinGet Install: .NET Desktop Runtime 9
:: Package ID: Microsoft.DotNet.DesktopRuntime.9

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  WinGet Install: .NET Desktop Runtime 9
echo  Package ID: Microsoft.DotNet.DesktopRuntime.9
echo ============================================================
echo.

where winget >nul 2>&1
if %errorLevel% NEQ 0 (
    echo WinGet is NOT installed. Use the WinGet menu's [1] Install WinGet first.
    echo.
    if not defined MAINT_NO_PAUSE pause
    exit /b 1
)

winget install --id Microsoft.DotNet.DesktopRuntime.9 -e --accept-source-agreements --accept-package-agreements
echo.
if not defined MAINT_NO_PAUSE pause
