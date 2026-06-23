@echo off
:: SFC /scannow
:: Scans and repairs protected Windows system files. Pulls replacement files
:: from the component store, so run DISM /RestoreHealth first if the store
:: itself may be damaged.

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  SFC /scannow
echo  Scans and repairs protected system files.
echo  For best results, run DISM /RestoreHealth first.
echo  Expect 5-15 minutes.
echo ============================================================
echo.
sfc /scannow
echo.
if not defined MAINT_NO_PAUSE pause
