@echo off
:: Network: Reset TCP/IP Stack
:: netsh int ip reset rewrites the TCP/IP registry keys to defaults.
:: Last resort for "broken networking" symptoms: incorrect IP config that
:: keeps coming back, corrupt routing table, ipconfig errors.
:: REQUIRES A REBOOT for changes to take effect.

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  Network: Reset TCP/IP Stack
echo  Rewrites TCP/IP registry keys to defaults.
echo  Resets IPv4 and IPv6 components.
echo  REBOOT REQUIRED for changes to take effect.
echo ============================================================
echo.
echo [1/3] Resetting TCP/IP stack...
netsh int ip reset
echo.
echo [2/3] Resetting IPv4 components...
netsh interface ipv4 reset
echo.
echo [3/3] Resetting IPv6 components...
netsh interface ipv6 reset
echo.
echo Reboot required for changes to take effect.
echo (Occasional "Access denied" lines on individual registry keys
echo  during these resets are normal and can be ignored.)
echo.
if not defined MAINT_NO_PAUSE pause
