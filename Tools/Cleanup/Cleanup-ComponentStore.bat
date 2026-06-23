@echo off
:: Cleanup: Component Store (WinSxS)
:: DISM /StartComponentCleanup removes superseded Windows update components
:: from the component store, freeing disk space. This is the SAFE variant:
:: updates can still be uninstalled for ~30 days after install.
::
:: For the aggressive permanent variant, append /ResetBase -- but after that,
:: previously installed updates can no longer be uninstalled.

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  Cleanup: Component Store (WinSxS)
echo  DISM /StartComponentCleanup
echo  Removes superseded update components. Safe: updates remain
echo  uninstallable for ~30 days. Expect several minutes.
echo ============================================================
echo.
DISM /Online /Cleanup-Image /StartComponentCleanup
echo.
if not defined MAINT_NO_PAUSE pause
