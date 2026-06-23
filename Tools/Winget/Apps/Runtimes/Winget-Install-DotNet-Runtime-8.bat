@echo off
:: WinGet Install: .NET Desktop Runtime 8 (current LTS)
:: Package ID: Microsoft.DotNet.DesktopRuntime.8
:: Required by modern .NET 8 desktop (WinForms / WPF) applications.

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  WinGet Install: .NET Desktop Runtime 8
echo  Package ID: Microsoft.DotNet.DesktopRuntime.8
echo  Required by modern .NET 8 desktop applications.
echo ============================================================
echo.

where winget >nul 2>&1
if %errorLevel% NEQ 0 (
    echo WinGet is NOT installed. Use the WinGet menu's [1] Install WinGet first.
    echo.
    if not defined MAINT_NO_PAUSE pause
    exit /b 1
)

winget install --id Microsoft.DotNet.DesktopRuntime.8 -e --accept-source-agreements --accept-package-agreements
echo.
if not defined MAINT_NO_PAUSE pause
