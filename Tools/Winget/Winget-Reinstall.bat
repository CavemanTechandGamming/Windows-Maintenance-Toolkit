@echo off
:: WinGet: Reinstall
:: Removes the existing App Installer package and installs the latest one
:: from scratch. Use when WinGet is broken, partially registered, or
:: behaving incorrectly.

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  WinGet: Reinstall  (force fresh install)
echo  Step 1: remove the existing App Installer package
echo  Step 2: download + install the latest version
echo  Use this if WinGet is broken or behaving incorrectly.
echo ============================================================
echo.

echo [Step 1/2] Removing existing App Installer package...
powershell -NoProfile -Command ^
  "Get-AppxPackage -AllUsers -Name Microsoft.DesktopAppInstaller | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue; ^
   Get-AppxPackage -Name Microsoft.DesktopAppInstaller | Remove-AppxPackage -ErrorAction SilentlyContinue; ^
   Write-Host 'Removal step finished.'"
echo.

echo [Step 2/2] Downloading and installing latest App Installer...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference = 'Stop'; ^
   $url = 'https://aka.ms/getwinget'; ^
   $out = Join-Path $env:TEMP 'Microsoft.DesktopAppInstaller.msixbundle'; ^
   Write-Host 'Downloading...'; ^
   Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing; ^
   Write-Host 'Installing...'; ^
   Add-AppxPackage -Path $out; ^
   Remove-Item $out -ErrorAction SilentlyContinue; ^
   Write-Host 'Install complete.'"
echo.

echo Verifying...
where winget >nul 2>&1
if %errorLevel% EQU 0 (
    winget --version
) else (
    echo WinGet command not yet on PATH.
    echo Sign out and back in if it still doesn't work.
)
echo.
if not defined MAINT_NO_PAUSE pause
