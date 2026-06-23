@echo off
:: WinGet Install: Rust (MSVC toolchain)
:: Package ID: Rustlang.Rust.MSVC
:: MSVC variant is the standard choice on Windows.

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  WinGet Install: Rust (MSVC toolchain)
echo  Package ID: Rustlang.Rust.MSVC
echo ============================================================
echo.

where winget >nul 2>&1
if %errorLevel% NEQ 0 (
    echo WinGet is NOT installed. Use the WinGet menu's [1] Install WinGet first.
    echo.
    if not defined MAINT_NO_PAUSE pause
    exit /b 1
)

winget install --id Rustlang.Rust.MSVC -e --accept-source-agreements --accept-package-agreements
echo.
if not defined MAINT_NO_PAUSE pause
