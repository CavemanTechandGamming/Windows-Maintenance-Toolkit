@echo off
:: CHKDSK C: /scan
:: Online (read-only) scan of the system drive. Safe to run while Windows
:: is in use. Reports problems but does NOT repair them.

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  CHKDSK C: /scan
echo  Online (read-only) check of the system drive.
echo  Safe to run live. Does NOT repair.
echo  Use CHKDSK-FullRepairOnReboot.bat if issues are reported.
echo ============================================================
echo.
chkdsk C: /scan
echo.
if not defined MAINT_NO_PAUSE pause
