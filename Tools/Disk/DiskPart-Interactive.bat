@echo off
:: DiskPart with Notepad guide and pre-listed disks/volumes

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

set "GUIDE=%~dp0DiskPart-Guide.txt"
if not exist "%GUIDE%" (
    echo ERROR: Guide not found: %GUIDE%
    echo.
    if not defined MAINT_NO_PAUSE pause
    exit /b 1
)

echo ============================================================
echo  DiskPart
echo  Opening DiskPart-Guide.txt in Notepad.
echo  Disk and volume lists print below, then interactive DiskPart.
echo  Type EXIT in DiskPart when finished.
echo ============================================================
echo.

start "" notepad "%GUIDE%"

echo --- LIST DISK ---
echo list disk | diskpart
echo.
echo --- LIST VOLUME ---
echo list volume | diskpart
echo.
echo --- Interactive DiskPart ---
diskpart
echo.
if not defined MAINT_NO_PAUSE pause
