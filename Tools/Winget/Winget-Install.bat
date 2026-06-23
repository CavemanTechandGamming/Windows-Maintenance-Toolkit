@echo off
:: WinGet: Install
:: Downloads the latest App Installer (which provides the `winget` command)
:: from Microsoft's official redirect URL and installs it as an Appx package.
:: Works on Windows 10 1809+ and Windows 11.

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  WinGet: Install
echo  Downloads the latest App Installer (Microsoft.DesktopAppInstaller)
echo  and installs it as an Appx package. This provides `winget`.
echo ============================================================
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference = 'Stop'; ^
   $url = 'https://aka.ms/getwinget'; ^
   $out = Join-Path $env:TEMP 'Microsoft.DesktopAppInstaller.msixbundle'; ^
   Write-Host 'Downloading App Installer from'; Write-Host ('  ' + $url); ^
   Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing; ^
   Write-Host 'Installing...'; ^
   Add-AppxPackage -Path $out; ^
   Remove-Item $out -ErrorAction SilentlyContinue; ^
   Write-Host 'Install command completed.'"

echo.
echo Verifying...
where winget >nul 2>&1
if %errorLevel% EQU 0 (
    echo WinGet is available:
    winget --version
) else (
    echo WinGet command not yet on PATH.
    echo You may need to sign out and back in (or restart^) for it to appear.
)
echo.
if not defined MAINT_NO_PAUSE pause
