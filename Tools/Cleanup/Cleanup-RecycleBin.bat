@echo off
:: Cleanup: Recycle Bin
:: Empties the Recycle Bin on every drive for every user.

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  Cleanup: Recycle Bin
echo  Empties the Recycle Bin on all drives.
echo ============================================================
echo.
powershell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue"
echo Done.
echo.
if not defined MAINT_NO_PAUSE pause
