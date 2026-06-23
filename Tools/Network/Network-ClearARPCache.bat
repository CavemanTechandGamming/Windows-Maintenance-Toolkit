@echo off
:: Network: Clear ARP Cache
:: arp -d * removes all dynamic entries from the ARP cache, forcing
:: Windows to re-resolve MAC addresses for LAN devices on next contact.
:: Useful after IP/MAC changes on the LAN.

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  Network: Clear ARP Cache
echo  Removes all dynamic ARP entries.
echo ============================================================
echo.
arp -d *
echo Done.
echo.
if not defined MAINT_NO_PAUSE pause
