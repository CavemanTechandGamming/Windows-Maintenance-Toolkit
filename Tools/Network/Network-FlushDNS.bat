@echo off
:: Network: Flush DNS Cache
:: ipconfig /flushdns clears the local DNS resolver cache. Use when websites
:: suddenly fail to load, after changing DNS servers, or after VPN connect/
:: disconnect glitches. No admin required.

echo ============================================================
echo  Network: Flush DNS Cache
echo  Clears the local DNS resolver cache.
echo ============================================================
echo.
ipconfig /flushdns
echo.
if not defined MAINT_NO_PAUSE pause
