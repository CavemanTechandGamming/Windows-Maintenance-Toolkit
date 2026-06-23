@echo off
:: WinGet: List Installed
:: Shows every package WinGet recognizes on this system, including ones
:: installed outside of WinGet that it can still detect.

echo ============================================================
echo  WinGet: List Installed Apps
echo ============================================================
echo.

where winget >nul 2>&1
if %errorLevel% NEQ 0 (
    echo WinGet is NOT installed. Run [1] Install WinGet first.
    echo.
    if not defined MAINT_NO_PAUSE pause
    exit /b 1
)

winget list --accept-source-agreements
echo.
if not defined MAINT_NO_PAUSE pause
