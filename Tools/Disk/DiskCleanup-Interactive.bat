@echo off
:: Disk Cleanup (Interactive)
:: Launches the standard Windows Disk Cleanup GUI (cleanmgr.exe).
:: Inside the GUI, click "Clean up system files" to expose the full set
:: of categories (Windows Update cleanup, old installations, etc.).

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  Disk Cleanup (Interactive)
echo  Launching Windows Disk Cleanup GUI.
echo  Tip: click "Clean up system files" for the full category list.
echo ============================================================
echo.
cleanmgr
echo.
echo Disk Cleanup GUI closed.
echo.
if not defined MAINT_NO_PAUSE pause
