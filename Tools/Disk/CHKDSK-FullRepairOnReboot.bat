@echo off
:: CHKDSK C: /f /r
:: Full filesystem + disk surface repair on the system drive. Cannot run
:: while Windows is live, so it schedules itself for the next reboot. The
:: boot-time scan can take 30 minutes to several HOURS depending on disk
:: size and health.

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  CHKDSK C: /f /r
echo  Full filesystem + surface repair on the system drive.
echo  Will SCHEDULE itself for the next reboot.
echo  Boot-time scan can take 30 minutes to several HOURS.
echo ============================================================
echo.
echo Y | chkdsk C: /f /r
echo.
echo CHKDSK has been scheduled. It will run automatically on the
echo next reboot. Save your work before rebooting.
echo.
if not defined MAINT_NO_PAUSE pause
