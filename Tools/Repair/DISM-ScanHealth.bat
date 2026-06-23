@echo off
:: DISM /ScanHealth
:: Deep scan of the component store for corruption. Reports only; does not
:: repair. Expect several minutes.

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  DISM /ScanHealth
echo  Deep scan of the component store. Does NOT repair.
echo  Expect several minutes.
echo ============================================================
echo.
DISM /Online /Cleanup-Image /ScanHealth
echo.
if not defined MAINT_NO_PAUSE pause
