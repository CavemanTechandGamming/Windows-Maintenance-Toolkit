@echo off
:: WinGet Install: Microsoft Edge WebView2 Runtime
:: Package ID: Microsoft.EdgeWebView2Runtime
:: Embedded browser component used by many modern Windows desktop apps.
:: Usually already present on Windows 11; install ensures latest version.

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  WinGet Install: WebView2 Runtime
echo  Package ID: Microsoft.EdgeWebView2Runtime
echo  Embedded browser component used by many modern desktop apps.
echo ============================================================
echo.

where winget >nul 2>&1
if %errorLevel% NEQ 0 (
    echo WinGet is NOT installed. Use the WinGet menu's [1] Install WinGet first.
    echo.
    if not defined MAINT_NO_PAUSE pause
    exit /b 1
)

winget install --id Microsoft.EdgeWebView2Runtime -e --accept-source-agreements --accept-package-agreements
echo.
if not defined MAINT_NO_PAUSE pause
