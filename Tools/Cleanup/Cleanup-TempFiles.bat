@echo off
:: Cleanup: Temp Files
:: Deletes contents of the per-user TEMP folder and the system TEMP folder.
:: Files currently in use will be skipped silently (this is expected).

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  Cleanup: Temp Files
echo  Clearing user TEMP and system TEMP folders.
echo  Locked files will be skipped (normal).
echo ============================================================
echo.

echo Clearing user TEMP: %TEMP%
del /f /q /s "%TEMP%\*" >nul 2>&1
for /d %%D in ("%TEMP%\*") do rd /s /q "%%D" >nul 2>&1

echo Clearing system TEMP: %WINDIR%\Temp
del /f /q /s "%WINDIR%\Temp\*" >nul 2>&1
for /d %%D in ("%WINDIR%\Temp\*") do rd /s /q "%%D" >nul 2>&1

echo.
echo Done.
echo.
if not defined MAINT_NO_PAUSE pause
