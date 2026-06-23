@echo off
:: Network: Renew IP Address
:: Releases the current DHCP lease, then requests a new one. Briefly
:: disconnects from the network. No effect on adapters using static IPs.

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  Network: Renew IP Address (DHCP release/renew)
echo  Briefly disconnects from the network.
echo  No effect on adapters using static IPs.
echo ============================================================
echo.
echo Releasing current IP lease...
ipconfig /release
echo.
echo Requesting new IP lease...
ipconfig /renew
echo.
if not defined MAINT_NO_PAUSE pause
