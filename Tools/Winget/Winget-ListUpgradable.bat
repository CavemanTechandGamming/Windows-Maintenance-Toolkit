@echo off
:: WinGet: List Upgradable
:: Lists installed apps that have updates available. Does NOT install.

echo ============================================================
echo  WinGet: List Upgradable Apps
echo  Shows what updates are available -- does NOT install anything.
echo ============================================================
echo.

where winget >nul 2>&1
if %errorLevel% NEQ 0 (
    echo WinGet is NOT installed. Run [1] Install WinGet first.
    echo.
    if not defined MAINT_NO_PAUSE pause
    exit /b 1
)

winget upgrade --accept-source-agreements
echo.
if not defined MAINT_NO_PAUSE pause
