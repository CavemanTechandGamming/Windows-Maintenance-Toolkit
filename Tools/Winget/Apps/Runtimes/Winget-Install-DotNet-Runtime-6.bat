@echo off
:: WinGet Install: .NET Desktop Runtime 6 (previous LTS, still widely used)
:: Package ID: Microsoft.DotNet.DesktopRuntime.6
:: Required by .NET 6 desktop applications.

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  WinGet Install: .NET Desktop Runtime 6
echo  Package ID: Microsoft.DotNet.DesktopRuntime.6
echo  Required by .NET 6 desktop applications.
echo ============================================================
echo.

where winget >nul 2>&1
if %errorLevel% NEQ 0 (
    echo WinGet is NOT installed. Use the WinGet menu's [1] Install WinGet first.
    echo.
    if not defined MAINT_NO_PAUSE pause
    exit /b 1
)

winget install --id Microsoft.DotNet.DesktopRuntime.6 -e --accept-source-agreements --accept-package-agreements
echo.
if not defined MAINT_NO_PAUSE pause
