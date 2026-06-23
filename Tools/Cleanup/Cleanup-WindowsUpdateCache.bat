@echo off
:: Cleanup: Windows Update Cache
:: Stops Windows Update services, clears the SoftwareDistribution\Download
:: cache, then restarts the services. Useful when updates are stuck,
:: downloads are corrupted, or "Pending" updates won't progress.

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  Cleanup: Windows Update Cache
echo  Resets %WINDIR%\SoftwareDistribution\Download
echo  Stops and restarts wuauserv, bits, cryptsvc.
echo ============================================================
echo.

echo Stopping Windows Update services...
net stop wuauserv >nul 2>&1
net stop bits     >nul 2>&1
net stop cryptsvc >nul 2>&1

echo Clearing %WINDIR%\SoftwareDistribution\Download ...
del /f /q /s "%WINDIR%\SoftwareDistribution\Download\*" >nul 2>&1
for /d %%D in ("%WINDIR%\SoftwareDistribution\Download\*") do rd /s /q "%%D" >nul 2>&1

echo Restarting Windows Update services...
net start cryptsvc >nul 2>&1
net start bits     >nul 2>&1
net start wuauserv >nul 2>&1

echo.
echo Done.
echo.
if not defined MAINT_NO_PAUSE pause
