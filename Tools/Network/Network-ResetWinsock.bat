@echo off
:: Network: Reset Winsock
:: netsh winsock reset rewrites the Winsock catalog to factory defaults.
:: Often fixes "connected but no internet" caused by misbehaving LSPs --
:: leftover hooks from uninstalled antivirus, VPNs, or proxy clients.
:: REQUIRES A REBOOT for changes to take effect.

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  Network: Reset Winsock
echo  Rewrites the Winsock catalog to factory defaults.
echo  REBOOT REQUIRED for changes to take effect.
echo ============================================================
echo.
netsh winsock reset
echo.
echo Reboot required for changes to take effect.
echo.
if not defined MAINT_NO_PAUSE pause
