@echo off
:: DISM /RestoreHealth
:: Repairs the component store using clean files pulled from Windows Update.
:: Requires internet. Must run BEFORE SFC for SFC to be effective.

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  DISM /RestoreHealth
echo  Repairs the component store from Windows Update.
echo  Requires internet. Expect 5-20 minutes.
echo  Run this BEFORE SFC /scannow.
echo ============================================================
echo.
DISM /Online /Cleanup-Image /RestoreHealth
echo.
if not defined MAINT_NO_PAUSE pause
