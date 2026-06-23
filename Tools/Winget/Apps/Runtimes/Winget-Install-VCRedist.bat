@echo off
:: WinGet Install: Visual C++ Redistributables (2015-2022)
:: Installs BOTH the x64 and x86 Microsoft Visual C++ runtime components.
:: Required by countless Windows applications and games. Safe to run --
:: WinGet skips packages already at the latest version.
::
:: Package IDs:
::   Microsoft.VCRedist.2015+.x64
::   Microsoft.VCRedist.2015+.x86

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  WinGet Install: Visual C++ Redistributables (2015-2022)
echo  Installs both x64 and x86 packages from Microsoft.
echo ============================================================
echo.

where winget >nul 2>&1
if %errorLevel% NEQ 0 (
    echo WinGet is NOT installed. Use the WinGet menu's [1] Install WinGet first.
    echo.
    if not defined MAINT_NO_PAUSE pause
    exit /b 1
)

echo [1/2] Installing x64 redistributable...
winget install --id Microsoft.VCRedist.2015+.x64 -e --accept-source-agreements --accept-package-agreements
echo.

echo [2/2] Installing x86 redistributable...
winget install --id Microsoft.VCRedist.2015+.x86 -e --accept-source-agreements --accept-package-agreements
echo.

if not defined MAINT_NO_PAUSE pause
