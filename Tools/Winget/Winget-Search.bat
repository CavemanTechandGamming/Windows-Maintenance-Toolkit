@echo off
:: WinGet: Search
:: Prompts for a search term, then runs `winget search`. Useful for finding
:: the exact package ID before adding an Install-<App>.bat script.

echo ============================================================
echo  WinGet: Search Packages
echo ============================================================
echo.

where winget >nul 2>&1
if %errorLevel% NEQ 0 (
    echo WinGet is NOT installed. Run [1] Install WinGet first.
    echo.
    if not defined MAINT_NO_PAUSE pause
    exit /b 1
)

set "_QUERY="
set /p "_QUERY=   Search term:  "
if not defined _QUERY (
    echo No search term entered.
    if not defined MAINT_NO_PAUSE pause
    exit /b 0
)

echo.
winget search "%_QUERY%" --accept-source-agreements
echo.
if not defined MAINT_NO_PAUSE pause
