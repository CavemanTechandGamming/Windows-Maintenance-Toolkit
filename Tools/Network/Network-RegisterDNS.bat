@echo off
:: Network: Register DNS
:: ipconfig /registerdns manually registers (or refreshes) all DNS names
:: and IP addresses configured on this computer with the DNS server.
:: Most useful on domain-joined networks or after IP changes.

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  Network: Register DNS
echo  Refreshes DNS name/IP registration with the DNS server.
echo ============================================================
echo.
ipconfig /registerdns
echo.
echo (Registration may take a minute or two to propagate.)
echo.
if not defined MAINT_NO_PAUSE pause
