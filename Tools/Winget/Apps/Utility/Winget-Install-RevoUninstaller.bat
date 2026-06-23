@echo off
:: WinGet Install: Revo Uninstaller (free)
:: Package ID: RevoUninstaller.RevoUninstaller
:: NOTE: For the paid Pro version, change the ID to
::   RevoUninstaller.RevoUninstallerPro

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  WinGet Install: Revo Uninstaller (free version)
echo  Package ID: RevoUninstaller.RevoUninstaller
echo ============================================================
echo.

where winget >nul 2>&1
if %errorLevel% NEQ 0 (
    echo WinGet is NOT installed. Use the WinGet menu's [1] Install WinGet first.
    echo.
    if not defined MAINT_NO_PAUSE pause
    exit /b 1
)

winget install --id RevoUninstaller.RevoUninstaller -e --accept-source-agreements --accept-package-agreements
echo.
if not defined MAINT_NO_PAUSE pause
