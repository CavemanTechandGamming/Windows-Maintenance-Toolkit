@echo off
:: DISM /CheckHealth
:: Quick check: reports whether the component store has already been flagged
:: as corrupt. Does not scan. Takes seconds.

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  DISM /CheckHealth
echo  Quick check: is the component store flagged as corrupt?
echo  No repair, no deep scan. Takes seconds.
echo ============================================================
echo.
DISM /Online /Cleanup-Image /CheckHealth
echo.
if not defined MAINT_NO_PAUSE pause
