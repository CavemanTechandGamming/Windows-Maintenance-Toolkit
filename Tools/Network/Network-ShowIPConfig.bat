@echo off
:: Network: Show IP Configuration
:: ipconfig /all displays the full TCP/IP configuration for every adapter:
:: IPs, default gateway, DNS servers, MAC addresses, DHCP lease times, etc.
:: Read-only -- safe to run any time. Admin not required.

echo ============================================================
echo  Network: Show IP Configuration
echo  Full output of ipconfig /all
echo ============================================================
echo.
ipconfig /all
echo.
if not defined MAINT_NO_PAUSE pause
