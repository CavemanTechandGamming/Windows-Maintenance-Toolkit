@echo off
setlocal EnableExtensions
title  Windows Maintenance Launcher

:: ============================================================
::  Maintenance Launcher
::  Menu-driven runner for the scripts in .\Tools\.
::   * Single command, or pre-set sequence.
::   * Every run is logged to .\Logs\Maintenance_<timestamp>.log
:: ============================================================

:: --- Console size & buffer -----------------------------------
::  Default height fits main/WinGet menus (65 lines). Install Apps uses category submenus.
call :SetConsoleSize 65 LOCK
chcp 65001 >nul
for /f "tokens=2 delims=:." %%I in ('chcp') do set "_ORIGCP=%%I"

:: --- Console colors ------------------------------------------
color 0F

:: Capture an ESC character into %ESC% for ANSI sequences.
for /f %%i in ('powershell -NoProfile -Command "[char]27"') do set "ESC=%%i"

:: 24-bit truecolor: Goldenrod (#DAA520) - readable gold on black.
set "GOLD=%ESC%[38;2;218;165;32m"
set "WHITE=%ESC%[97m"
set "DIM=%ESC%[90m"
set "RESET=%ESC%[0m"

:: --- Admin elevation (elevate once; children inherit) --------
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo  Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: --- Restore working dir after UAC relaunch ------------------
cd /d "%~dp0"
set "TOOLS=%~dp0Tools"
set "LOGDIR=%~dp0Logs"

if not exist "%TOOLS%\" (
    echo.
    echo  ERROR: Tools folder not found.
    echo    Expected at: %TOOLS%
    echo.
    pause
    goto :END
)

:: --- Set up session log --------------------------------------
if not exist "%LOGDIR%" mkdir "%LOGDIR%"
for /f %%I in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HHmmss"') do set "STAMP=%%I"
set "MAINT_LOG=%LOGDIR%\Maintenance_%STAMP%.log"

>  "%MAINT_LOG%" echo ============================================================
>> "%MAINT_LOG%" echo  Maintenance session started %DATE% %TIME%
>> "%MAINT_LOG%" echo  Computer: %COMPUTERNAME%
>> "%MAINT_LOG%" echo  User:     %USERNAME%
>> "%MAINT_LOG%" echo  Log:      %MAINT_LOG%
>> "%MAINT_LOG%" echo ============================================================

:: ============================================================
::  MAIN MENU
:: ============================================================

:MENU
call :SetConsoleSize 65 LOCK
cls
powershell -NoProfile -Command "try { [Console]::SetCursorPosition(0,0) } catch {}" >nul 2>&1
echo.
echo   %GOLD%╔══════════════════════════════════════════════════════════════════════════════════════╗%RESET%
echo   %GOLD%║                                                                                      ║%RESET%
echo   %GOLD%║                      W I N D O W S   M A I N T E N A N C E                           ║%RESET%
echo   %GOLD%║                                                                                      ║%RESET%
echo   %GOLD%╚══════════════════════════════════════════════════════════════════════════════════════╝%RESET%
echo     %GOLD%Log:%RESET%  %DIM%Logs\Maintenance_%STAMP%.log%RESET%
echo.
echo   %GOLD%── SYSTEM REPAIR ──%RESET%
echo      %GOLD%[ 1]%RESET%  DISM CheckHealth
echo      %GOLD%[ 2]%RESET%  DISM ScanHealth
echo      %GOLD%[ 3]%RESET%  DISM RestoreHealth
echo      %GOLD%[ 4]%RESET%  SFC /scannow
echo      %GOLD%[ 5]%RESET%  CHKDSK read-only scan
echo      %GOLD%[ 6]%RESET%  CHKDSK full repair
echo.
echo   %GOLD%── CLEANUP ──%RESET%
echo      %GOLD%[ 7]%RESET%  Temp files
echo      %GOLD%[ 8]%RESET%  Windows Update cache
echo      %GOLD%[ 9]%RESET%  Recycle Bin
echo      %GOLD%[10]%RESET%  Component store (WinSxS)
echo      %GOLD%[11]%RESET%  Disk Cleanup (GUI)
echo      %GOLD%[12]%RESET%  DiskPart
echo.
echo   %GOLD%── NETWORK ──%RESET%
echo      %GOLD%[13]%RESET%  Flush DNS cache
echo      %GOLD%[14]%RESET%  Renew IP address
echo      %GOLD%[15]%RESET%  Register DNS
echo      %GOLD%[16]%RESET%  Clear ARP cache
echo      %GOLD%[17]%RESET%  Reset Winsock
echo      %GOLD%[18]%RESET%  Reset TCP/IP stack
echo      %GOLD%[19]%RESET%  Show IP configuration
echo.
echo   %GOLD%── PACKAGE MANAGEMENT ──%RESET%
echo      %GOLD%[W]%RESET%  WinGet Manager
echo.
echo   %GOLD%── SEQUENCES ──%RESET%
echo      %GOLD%[R]%RESET%  Full repair
echo      %GOLD%[L]%RESET%  Full cleanup
echo      %GOLD%[N]%RESET%  Network refresh
echo      %GOLD%[F]%RESET%  Full maintenance
echo.
echo   %GOLD%── UTILITY ──%RESET%
echo      %GOLD%[V]%RESET%  View session log
echo      %GOLD%[O]%RESET%  Open logs folder
echo      %GOLD%[Q]%RESET%  Quit
echo   %GOLD%──────────────────────────────────────────────────────────────────────────────────────%RESET%
echo.
set "choice="
set /p "choice=   %GOLD%Select option:%RESET%  "
if not defined choice goto MENU

if /i "%choice%"=="1"  call :RunOne "Repair\DISM-CheckHealth.bat"           & goto MENU
if /i "%choice%"=="2"  call :RunOne "Repair\DISM-ScanHealth.bat"            & goto MENU
if /i "%choice%"=="3"  call :RunOne "Repair\DISM-RestoreHealth.bat"         & goto MENU
if /i "%choice%"=="4"  call :RunOne "Repair\SFC-Scannow.bat"                & goto MENU
if /i "%choice%"=="5"  call :RunOne "Disk\CHKDSK-ReadOnlyScan.bat"        & goto MENU
if /i "%choice%"=="6"  call :RunOne "Disk\CHKDSK-FullRepairOnReboot.bat"  & goto MENU
if /i "%choice%"=="7"  call :RunOne "Cleanup\Cleanup-TempFiles.bat"          & goto MENU
if /i "%choice%"=="8"  call :RunOne "Cleanup\Cleanup-WindowsUpdateCache.bat" & goto MENU
if /i "%choice%"=="9"  call :RunOne "Cleanup\Cleanup-RecycleBin.bat"         & goto MENU
if /i "%choice%"=="10" call :RunOne "Cleanup\Cleanup-ComponentStore.bat"     & goto MENU
if /i "%choice%"=="11" call :RunOne "Disk\DiskCleanup-Interactive.bat"    & goto MENU
if /i "%choice%"=="12" call :RunOne "Disk\DiskPart-Interactive.bat"       & goto MENU
if /i "%choice%"=="13" call :RunOne "Network\Network-FlushDNS.bat"           & goto MENU
if /i "%choice%"=="14" call :RunOne "Network\Network-RenewIPAddress.bat"     & goto MENU
if /i "%choice%"=="15" call :RunOne "Network\Network-RegisterDNS.bat"        & goto MENU
if /i "%choice%"=="16" call :RunOne "Network\Network-ClearARPCache.bat"      & goto MENU
if /i "%choice%"=="17" call :RunOne "Network\Network-ResetWinsock.bat"       & goto MENU
if /i "%choice%"=="18" call :RunOne "Network\Network-ResetTCPIPStack.bat"    & goto MENU
if /i "%choice%"=="19" call :RunOne "Network\Network-ShowIPConfig.bat"       & goto MENU
if /i "%choice%"=="W"  call :WingetMenu   & if defined _QUIT goto :END & goto MENU
if /i "%choice%"=="R"  call :SeqRepair    & goto MENU
if /i "%choice%"=="L"  call :SeqCleanup   & goto MENU
if /i "%choice%"=="N"  call :SeqNetwork   & goto MENU
if /i "%choice%"=="F"  call :SeqFull      & goto MENU
if /i "%choice%"=="V"  call :ViewLog      & goto MENU
if /i "%choice%"=="O"  start "" "%LOGDIR%" & goto MENU
if /i "%choice%"=="Q"  goto :END

echo.
echo   Invalid choice: "%choice%"
echo.
pause
goto MENU

:: ============================================================
::  WINGET SUBMENU
:: ============================================================

:WingetMenu
:WingetLoop
call :SetConsoleSize 65 LOCK
cls
echo.
echo   %GOLD%╔══════════════════════════════════════════════════════════════════════════════════════╗%RESET%
echo   %GOLD%║                                                                                      ║%RESET%
echo   %GOLD%║                            W I N G E T   M A N A G E R                               ║%RESET%
echo   %GOLD%║                                                                                      ║%RESET%
echo   %GOLD%╚══════════════════════════════════════════════════════════════════════════════════════╝%RESET%
echo     %GOLD%Session log:%RESET%  %DIM%%MAINT_LOG%%RESET%
echo     %DIM%WinGet output streams live and is NOT added to the session log.%RESET%
echo     %DIM%Use [L] below to open WinGet's own diagnostic log folder.%RESET%
echo.
echo   %GOLD%── WINGET ITSELF ─────────────────────────────────────────────────────────────────────%RESET%
echo      %GOLD%[ 1]%RESET%  Install WinGet            Get the latest App Installer
echo      %GOLD%[ 2]%RESET%  Verify / update WinGet    Ensure latest version
echo      %GOLD%[ 3]%RESET%  Reinstall WinGet          Force fresh install (fix breakage)
echo.
echo   %GOLD%── WINGET QUERIES ────────────────────────────────────────────────────────────────────%RESET%
echo      %GOLD%[ 4]%RESET%  List upgradable apps      Show available updates (no install)
echo      %GOLD%[ 5]%RESET%  List installed apps       winget list
echo      %GOLD%[ 6]%RESET%  Search for a package      Interactive search
echo.
echo   %GOLD%── WINGET ACTIONS ────────────────────────────────────────────────────────────────────%RESET%
echo      %GOLD%[ 7]%RESET%  Upgrade ALL installed     winget upgrade --all
echo      %GOLD%[ P]%RESET%  Install preset bundle...  Preset 1-4 (edit in Notepad)
echo      %GOLD%[ I]%RESET%  Install Apps...           Browse apps by category
echo.
echo   %GOLD%── UTILITY ───────────────────────────────────────────────────────────────────────────%RESET%
echo      %GOLD%[L]%RESET%   Open WinGet log folder    Native WinGet diagnostic logs
echo      %GOLD%[B]%RESET%   Back to main menu
echo      %GOLD%[Q]%RESET%   Quit launcher
echo   %GOLD%──────────────────────────────────────────────────────────────────────────────────────%RESET%
echo.
set "choice="
set /p "choice=   %GOLD%Select option:%RESET%  "
if not defined choice goto WingetLoop

:: Navigation first (these jump away from the loop entirely).
if /i "%choice%"=="B" goto :eof
if /i "%choice%"=="M" goto :eof
if /i "%choice%"=="Q" set "_QUIT=1" & goto :eof

if /i "%choice%"=="1"  call :RunOneNoTee "Winget\Winget-Install.bat"          & goto WingetLoop
if /i "%choice%"=="2"  call :RunOneNoTee "Winget\Winget-EnsureUpToDate.bat"   & goto WingetLoop
if /i "%choice%"=="3"  call :RunOneNoTee "Winget\Winget-Reinstall.bat"        & goto WingetLoop
if /i "%choice%"=="4"  call :RunOneNoTee "Winget\Winget-ListUpgradable.bat"   & goto WingetLoop
if /i "%choice%"=="5"  call :RunOneNoTee "Winget\Winget-ListInstalled.bat"    & goto WingetLoop
if /i "%choice%"=="6"  call :RunOneNoTee "Winget\Winget-Search.bat"           & goto WingetLoop
if /i "%choice%"=="7"  call :RunOneNoTee "Winget\Winget-UpgradeAll.bat"       & goto WingetLoop
if /i "%choice%"=="P"  call :PresetMenu                                         & if defined _QUIT goto :eof & goto WingetLoop
if /i "%choice%"=="I"  call :AppsMenu                                         & if defined _QUIT goto :eof & if defined _BACK_TO_MAIN ( set "_BACK_TO_MAIN=" & goto :eof ) & goto WingetLoop
if /i "%choice%"=="L"  call :OpenWingetLog                                    & goto WingetLoop

echo.
echo   Invalid choice: "%choice%"
echo.
pause
goto WingetLoop

:: ============================================================
::  PRESET BUNDLES  (WinGet -> P)
:: ============================================================

:PresetMenu
:PresetLoop
call :SetConsoleSize 65 LOCK
cls
echo.
echo   %GOLD%╔══════════════════════════════════════════════════════════════════════════════════════╗%RESET%
echo   %GOLD%║                            P R E S E T   B U N D L E S                               ║%RESET%
echo   %GOLD%╚══════════════════════════════════════════════════════════════════════════════════════╝%RESET%
echo     %DIM%Edit list files in Notepad. One script path per line.%RESET%
echo     %DIM%Folder: %TOOLS%\Winget\Presets\Preset-1.txt ... Preset-4.txt%RESET%
echo.
echo   %GOLD%── INSTALL ──%RESET%
echo      %GOLD%[ 1]%RESET%  Install Preset 1
echo      %GOLD%[ 2]%RESET%  Install Preset 2
echo      %GOLD%[ 3]%RESET%  Install Preset 3
echo      %GOLD%[ 4]%RESET%  Install Preset 4
echo.
echo   %GOLD%── EDIT IN NOTEPAD ──%RESET%
echo      %GOLD%[E1]%RESET%  Edit Preset 1              %GOLD%[E3]%RESET%  Edit Preset 3
echo      %GOLD%[E2]%RESET%  Edit Preset 2              %GOLD%[E4]%RESET%  Edit Preset 4
echo.
echo   %GOLD%── NAVIGATION ──%RESET%  %GOLD%[B]%RESET% WinGet menu   %GOLD%[Q]%RESET% Quit
echo   %GOLD%──────────────────────────────────────────────────────────────────────────────────────%RESET%
echo.
set "choice="
set /p "choice=   %GOLD%Select option:%RESET%  "
if not defined choice goto PresetLoop
if /i "%choice%"=="B" goto :eof
if /i "%choice%"=="Q" set "_QUIT=1" & goto :eof
if /i "%choice%"=="1"  call :SeqInstallPreset 1 & goto PresetLoop
if /i "%choice%"=="2"  call :SeqInstallPreset 2 & goto PresetLoop
if /i "%choice%"=="3"  call :SeqInstallPreset 3 & goto PresetLoop
if /i "%choice%"=="4"  call :SeqInstallPreset 4 & goto PresetLoop
if /i "%choice%"=="E1" call :EditPreset 1 & goto PresetLoop
if /i "%choice%"=="E2" call :EditPreset 2 & goto PresetLoop
if /i "%choice%"=="E3" call :EditPreset 3 & goto PresetLoop
if /i "%choice%"=="E4" call :EditPreset 4 & goto PresetLoop
echo.
echo   Invalid choice: "%choice%"
echo.
pause
goto PresetLoop

:EditPreset
:: %~1 = preset number 1-4
set "_PF=%TOOLS%\Winget\Presets\Preset-%~1.txt"
if not exist "%_PF%" (
    echo.
    echo   Preset file not found: %_PF%
    echo.
    pause
    goto :eof
)
echo.
echo   Opening Preset %~1 in Notepad:
echo     %_PF%
echo   Save the file when finished editing.
echo.
start "" notepad "%_PF%"
pause
goto :eof

:SeqInstallPreset
:: %~1 = preset number 1-4
set "_PF=%TOOLS%\Winget\Presets\Preset-%~1.txt"
if not exist "%_PF%" (
    echo.
    echo   Preset file not found: %_PF%
    echo.
    pause
    goto :eof
)
cls
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                  %GOLD%S E Q U E N C E   :   I N S T A L L   P R E S E T   %~1%RESET%
echo     %DIM%%_PF%%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
set /p "_PRESET_GO=   Install all apps listed in Preset %~1? [Y/N]:  "
if /i not "%_PRESET_GO%"=="Y" goto :eof
>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ############################################################
>> "%MAINT_LOG%" echo  SEQUENCE: Install Preset %~1  -  %DATE% %TIME%
>> "%MAINT_LOG%" echo  File: %_PF%
>> "%MAINT_LOG%" echo ############################################################
set "MAINT_NO_PAUSE=1"
for /f "usebackq eol=# tokens=* delims=" %%L in ("%_PF%") do call :RunOneNoTee "%%L"
set "MAINT_NO_PAUSE="
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Preset %~1 install sequence complete.%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof

:: ============================================================
::  APPS SUB-SUBMENU  (Main -> WinGet -> Install Apps)
:AppsMenu
:AppsLoop
call :SetConsoleSize 65 LOCK
cls
powershell -NoProfile -Command "try { [Console]::SetCursorPosition(0,0) } catch {}" >nul 2>&1
echo.
echo   %GOLD%╔══════════════════════════════════════════════════════════════════════════════════════╗%RESET%
echo   %GOLD%║                                                                                      ║%RESET%
echo   %GOLD%║                     I N S T A L L   A P P S   V I A   W I N G E T                    ║%RESET%
echo   %GOLD%║                                                                                      ║%RESET%
echo   %GOLD%╚══════════════════════════════════════════════════════════════════════════════════════╝%RESET%
echo     %GOLD%Session log:%RESET%  %DIM%%MAINT_LOG%%RESET%
echo     %DIM%WinGet output streams live and is NOT added to the session log.%RESET%
echo.
echo   %GOLD%── CATEGORIES ──%RESET%
echo        %GOLD%[ 1]%RESET%  BROWSERS                   %GOLD%[ 2]%RESET%  COMMUNICATION
echo        %GOLD%[ 3]%RESET%  DEV TOOLS                  %GOLD%[ 4]%RESET%  GAMES
echo        %GOLD%[ 5]%RESET%  HARDWARE ^& DIAGNOSTICS    %GOLD%[ 6]%RESET%  LANGUAGES
echo        %GOLD%[ 7]%RESET%  MEDIA                      %GOLD%[ 8]%RESET%  NETWORK ^& REMOTE
echo        %GOLD%[ 9]%RESET%  OFFICE ^& DOCUMENTS        %GOLD%[10]%RESET%  RUNTIMES ^& FRAMEWORKS
echo        %GOLD%[11]%RESET%  SECURITY ^& PRIVACY        %GOLD%[12]%RESET%  SYSTEM TOOLS
echo        %GOLD%[13]%RESET%  VIRTUALIZATION ^& CONTAINERS
echo.
echo   %GOLD%── NAVIGATION ──%RESET%  %GOLD%[A]%RESET% Install EVERYTHING   %GOLD%[B]%RESET% WinGet menu   %GOLD%[M]%RESET% Main menu   %GOLD%[Q]%RESET% Quit
echo   %GOLD%──────────────────────────────────────────────────────────────────────────────────────%RESET%
echo.
set "choice="
set /p "choice=   %GOLD%Select option:%RESET%  "
if not defined choice goto AppsLoop

:: Navigation first.
if /i "%choice%"=="B" goto :eof
if /i "%choice%"=="M" set "_BACK_TO_MAIN=1" & goto :eof
if /i "%choice%"=="Q" set "_QUIT=1" & goto :eof
if /i "%choice%"=="A" call :SeqInstallAllApps & goto AppsLoop

if /i "%choice%"=="1" call :AppsCatBrowsers & if defined _QUIT goto :eof & goto AppsLoop
if /i "%choice%"=="2" call :AppsCatCommunication & if defined _QUIT goto :eof & goto AppsLoop
if /i "%choice%"=="3" call :AppsCatDeveloper & if defined _QUIT goto :eof & goto AppsLoop
if /i "%choice%"=="4" call :AppsCatGames & if defined _QUIT goto :eof & goto AppsLoop
if /i "%choice%"=="5" call :AppsCatHardware & if defined _QUIT goto :eof & goto AppsLoop
if /i "%choice%"=="6" call :AppsCatLanguages & if defined _QUIT goto :eof & goto AppsLoop
if /i "%choice%"=="7" call :AppsCatMedia & if defined _QUIT goto :eof & goto AppsLoop
if /i "%choice%"=="8" call :AppsCatNetworkRemote & if defined _QUIT goto :eof & goto AppsLoop
if /i "%choice%"=="9" call :AppsCatOffice & if defined _QUIT goto :eof & goto AppsLoop
if /i "%choice%"=="10" call :AppsCatRuntimes & if defined _QUIT goto :eof & goto AppsLoop
if /i "%choice%"=="11" call :AppsCatSecurity & if defined _QUIT goto :eof & goto AppsLoop
if /i "%choice%"=="12" call :AppsCatSystemTools & if defined _QUIT goto :eof & goto AppsLoop
if /i "%choice%"=="13" call :AppsCatVirtualization & if defined _QUIT goto :eof & goto AppsLoop

echo.
echo   Invalid choice: "%choice%"
echo.
pause
goto AppsLoop

:AppsCatBrowsers
:AppsCatBrowsersLoop
call :SetConsoleSize 65 LOCK
cls
powershell -NoProfile -Command "try { [Console]::SetCursorPosition(0,0) } catch {}" >nul 2>&1
echo.
echo   %GOLD%── BROWSERS ──%RESET%
echo        %GOLD%[ 1]%RESET%  Brave Browser              %GOLD%[ 2]%RESET%  Google Chrome
echo        %GOLD%[ 3]%RESET%  LibreWolf                  %GOLD%[ 4]%RESET%  Mozilla Firefox
echo        %GOLD%[ 5]%RESET%  Opera GX                   %GOLD%[ 6]%RESET%  Install ALL browsers
echo.
echo   %GOLD%── NAVIGATION ──%RESET%  %GOLD%[B]%RESET% Categories   %GOLD%[Q]%RESET% Quit
echo   %GOLD%──────────────────────────────────────────────────────────────────────────────────────%RESET%
echo.
set "choice="
set /p "choice=   %GOLD%Select option:%RESET%  "
if not defined choice goto AppsCatBrowsersLoop
if /i "%choice%"=="B" goto AppsLoop
if /i "%choice%"=="Q" set "_QUIT=1" & goto :eof
if /i "%choice%"=="6" call :SeqInstallBrowsers & goto AppsCatBrowsersLoop
if /i "%choice%"=="1" call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-Brave.bat" & goto AppsCatBrowsersLoop
if /i "%choice%"=="2" call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-Chrome.bat" & goto AppsCatBrowsersLoop
if /i "%choice%"=="3" call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-LibreWolf.bat" & goto AppsCatBrowsersLoop
if /i "%choice%"=="4" call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-Firefox.bat" & goto AppsCatBrowsersLoop
if /i "%choice%"=="5" call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-OperaGX.bat" & goto AppsCatBrowsersLoop
echo.
echo   Invalid choice: "%choice%"
echo.
pause
goto AppsCatBrowsersLoop

:AppsCatCommunication
:AppsCatCommunicationLoop
call :SetConsoleSize 65 LOCK
cls
powershell -NoProfile -Command "try { [Console]::SetCursorPosition(0,0) } catch {}" >nul 2>&1
echo.
echo   %GOLD%── COMMUNICATION ──%RESET%
echo        %GOLD%[ 1]%RESET%  Discord                    %GOLD%[ 2]%RESET%  Microsoft Teams
echo        %GOLD%[ 3]%RESET%  Mozilla Thunderbird        %GOLD%[ 4]%RESET%  Signal
echo        %GOLD%[ 5]%RESET%  Slack                      %GOLD%[ 6]%RESET%  Telegram Desktop
echo        %GOLD%[ 7]%RESET%  Zoom Workplace             %GOLD%[ 8]%RESET%  Install ALL communication
echo.
echo   %GOLD%── NAVIGATION ──%RESET%  %GOLD%[B]%RESET% Categories   %GOLD%[Q]%RESET% Quit
echo   %GOLD%──────────────────────────────────────────────────────────────────────────────────────%RESET%
echo.
set "choice="
set /p "choice=   %GOLD%Select option:%RESET%  "
if not defined choice goto AppsCatCommunicationLoop
if /i "%choice%"=="B" goto AppsLoop
if /i "%choice%"=="Q" set "_QUIT=1" & goto :eof
if /i "%choice%"=="8" call :SeqInstallCommunication & goto AppsCatCommunicationLoop
if /i "%choice%"=="1" call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Discord.bat" & goto AppsCatCommunicationLoop
if /i "%choice%"=="2" call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Teams.bat" & goto AppsCatCommunicationLoop
if /i "%choice%"=="3" call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Thunderbird.bat" & goto AppsCatCommunicationLoop
if /i "%choice%"=="4" call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Signal.bat" & goto AppsCatCommunicationLoop
if /i "%choice%"=="5" call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Slack.bat" & goto AppsCatCommunicationLoop
if /i "%choice%"=="6" call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Telegram.bat" & goto AppsCatCommunicationLoop
if /i "%choice%"=="7" call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Zoom.bat" & goto AppsCatCommunicationLoop
echo.
echo   Invalid choice: "%choice%"
echo.
pause
goto AppsCatCommunicationLoop

:AppsCatDeveloper
:AppsCatDeveloperLoop
call :SetConsoleSize 65 LOCK
cls
powershell -NoProfile -Command "try { [Console]::SetCursorPosition(0,0) } catch {}" >nul 2>&1
echo.
echo   %GOLD%── DEV TOOLS ──%RESET%
echo        %GOLD%[ 1]%RESET%  CMake                      %GOLD%[ 2]%RESET%  Cursor
echo        %GOLD%[ 3]%RESET%  Git                        %GOLD%[ 4]%RESET%  GitHub Desktop
echo        %GOLD%[ 5]%RESET%  IntelliJ IDEA (Community)  %GOLD%[ 6]%RESET%  Visual Studio Code
echo        %GOLD%[ 7]%RESET%  VS Community 2022          %GOLD%[ 8]%RESET%  VS Community 2026
echo        %GOLD%[ 9]%RESET%  Install ALL developer tools
echo.
echo   %GOLD%── NAVIGATION ──%RESET%  %GOLD%[B]%RESET% Categories   %GOLD%[Q]%RESET% Quit
echo   %GOLD%──────────────────────────────────────────────────────────────────────────────────────%RESET%
echo.
set "choice="
set /p "choice=   %GOLD%Select option:%RESET%  "
if not defined choice goto AppsCatDeveloperLoop
if /i "%choice%"=="B" goto AppsLoop
if /i "%choice%"=="Q" set "_QUIT=1" & goto :eof
if /i "%choice%"=="9" call :SeqInstallDeveloper & goto AppsCatDeveloperLoop
if /i "%choice%"=="1" call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-CMake.bat" & goto AppsCatDeveloperLoop
if /i "%choice%"=="2" call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-Cursor.bat" & goto AppsCatDeveloperLoop
if /i "%choice%"=="3" call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-Git.bat" & goto AppsCatDeveloperLoop
if /i "%choice%"=="4" call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-GitHubDesktop.bat" & goto AppsCatDeveloperLoop
if /i "%choice%"=="5" call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-IntelliJ.bat" & goto AppsCatDeveloperLoop
if /i "%choice%"=="6" call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-VSCode.bat" & goto AppsCatDeveloperLoop
if /i "%choice%"=="7" call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-VSCommunity2022.bat" & goto AppsCatDeveloperLoop
if /i "%choice%"=="8" call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-VSCommunity2026.bat" & goto AppsCatDeveloperLoop
echo.
echo   Invalid choice: "%choice%"
echo.
pause
goto AppsCatDeveloperLoop

:AppsCatGames
:AppsCatGamesLoop
call :SetConsoleSize 65 LOCK
cls
powershell -NoProfile -Command "try { [Console]::SetCursorPosition(0,0) } catch {}" >nul 2>&1
echo.
echo   %GOLD%── GAMES ──%RESET%
echo        %GOLD%[ 1]%RESET%  Battle.net                 %GOLD%[ 2]%RESET%  EA app
echo        %GOLD%[ 3]%RESET%  Epic Games Launcher        %GOLD%[ 4]%RESET%  GOG Galaxy
echo        %GOLD%[ 5]%RESET%  itch.io                    %GOLD%[ 6]%RESET%  Moonlight
echo        %GOLD%[ 7]%RESET%  NVIDIA GeForce NOW         %GOLD%[ 8]%RESET%  Steam
echo        %GOLD%[ 9]%RESET%  Ubisoft Connect            %GOLD%[10]%RESET%  Install ALL games
echo.
echo   %GOLD%── NAVIGATION ──%RESET%  %GOLD%[B]%RESET% Categories   %GOLD%[Q]%RESET% Quit
echo   %GOLD%──────────────────────────────────────────────────────────────────────────────────────%RESET%
echo.
set "choice="
set /p "choice=   %GOLD%Select option:%RESET%  "
if not defined choice goto AppsCatGamesLoop
if /i "%choice%"=="B" goto AppsLoop
if /i "%choice%"=="Q" set "_QUIT=1" & goto :eof
if /i "%choice%"=="10" call :SeqInstallGames & goto AppsCatGamesLoop
if /i "%choice%"=="1" call :RunOneNoTee "Winget\Apps\Games\Winget-Install-BattleNet.bat" & goto AppsCatGamesLoop
if /i "%choice%"=="2" call :RunOneNoTee "Winget\Apps\Games\Winget-Install-EADesktop.bat" & goto AppsCatGamesLoop
if /i "%choice%"=="3" call :RunOneNoTee "Winget\Apps\Games\Winget-Install-EpicGames.bat" & goto AppsCatGamesLoop
if /i "%choice%"=="4" call :RunOneNoTee "Winget\Apps\Games\Winget-Install-GOGGalaxy.bat" & goto AppsCatGamesLoop
if /i "%choice%"=="5" call :RunOneNoTee "Winget\Apps\Games\Winget-Install-Itch.bat" & goto AppsCatGamesLoop
if /i "%choice%"=="6" call :RunOneNoTee "Winget\Apps\Games\Winget-Install-Moonlight.bat" & goto AppsCatGamesLoop
if /i "%choice%"=="7" call :RunOneNoTee "Winget\Apps\Games\Winget-Install-GeForceNow.bat" & goto AppsCatGamesLoop
if /i "%choice%"=="8" call :RunOneNoTee "Winget\Apps\Games\Winget-Install-Steam.bat" & goto AppsCatGamesLoop
if /i "%choice%"=="9" call :RunOneNoTee "Winget\Apps\Games\Winget-Install-UbisoftConnect.bat" & goto AppsCatGamesLoop
echo.
echo   Invalid choice: "%choice%"
echo.
pause
goto AppsCatGamesLoop

:AppsCatHardware
:AppsCatHardwareLoop
call :SetConsoleSize 65 LOCK
cls
powershell -NoProfile -Command "try { [Console]::SetCursorPosition(0,0) } catch {}" >nul 2>&1
echo.
echo   %GOLD%── HARDWARE ^& DIAGNOSTICS ──%RESET%
echo        %GOLD%[ 1]%RESET%  CPU-Z                      %GOLD%[ 2]%RESET%  CrystalDiskInfo
echo        %GOLD%[ 3]%RESET%  CrystalDiskMark            %GOLD%[ 4]%RESET%  Display Driver Uninstaller
echo        %GOLD%[ 5]%RESET%  FanControl                 %GOLD%[ 6]%RESET%  GPU-Z
echo        %GOLD%[ 7]%RESET%  HWiNFO                     %GOLD%[ 8]%RESET%  HWMonitor
echo        %GOLD%[ 9]%RESET%  MSI Afterburner            %GOLD%[10]%RESET%  OpenRGB
echo        %GOLD%[11]%RESET%  Snappy Driver Installer Origin %GOLD%[12]%RESET%  Install ALL hardware
echo.
echo   %GOLD%── NAVIGATION ──%RESET%  %GOLD%[B]%RESET% Categories   %GOLD%[Q]%RESET% Quit
echo   %GOLD%──────────────────────────────────────────────────────────────────────────────────────%RESET%
echo.
set "choice="
set /p "choice=   %GOLD%Select option:%RESET%  "
if not defined choice goto AppsCatHardwareLoop
if /i "%choice%"=="B" goto AppsLoop
if /i "%choice%"=="Q" set "_QUIT=1" & goto :eof
if /i "%choice%"=="12" call :SeqInstallHardware & goto AppsCatHardwareLoop
if /i "%choice%"=="1" call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-CPU-Z.bat" & goto AppsCatHardwareLoop
if /i "%choice%"=="2" call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-CrystalDiskInfo.bat" & goto AppsCatHardwareLoop
if /i "%choice%"=="3" call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-CrystalDiskMark.bat" & goto AppsCatHardwareLoop
if /i "%choice%"=="4" call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-DisplayDriverUninstaller.bat" & goto AppsCatHardwareLoop
if /i "%choice%"=="5" call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-FanControl.bat" & goto AppsCatHardwareLoop
if /i "%choice%"=="6" call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-GPU-Z.bat" & goto AppsCatHardwareLoop
if /i "%choice%"=="7" call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-HWiNFO.bat" & goto AppsCatHardwareLoop
if /i "%choice%"=="8" call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-HWMonitor.bat" & goto AppsCatHardwareLoop
if /i "%choice%"=="9" call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-MSIAfterburner.bat" & goto AppsCatHardwareLoop
if /i "%choice%"=="10" call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-OpenRGB.bat" & goto AppsCatHardwareLoop
if /i "%choice%"=="11" call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-SnappyDriverInstaller.bat" & goto AppsCatHardwareLoop
echo.
echo   Invalid choice: "%choice%"
echo.
pause
goto AppsCatHardwareLoop

:AppsCatLanguages
:AppsCatLanguagesLoop
call :SetConsoleSize 65 LOCK
cls
powershell -NoProfile -Command "try { [Console]::SetCursorPosition(0,0) } catch {}" >nul 2>&1
echo.
echo   %GOLD%── LANGUAGES ──%RESET%
echo        %GOLD%[ 1]%RESET%  Go (Golang)                %GOLD%[ 2]%RESET%  Microsoft OpenJDK 21
echo        %GOLD%[ 3]%RESET%  Microsoft OpenJDK 25       %GOLD%[ 4]%RESET%  Node.js (Current)
echo        %GOLD%[ 5]%RESET%  Node.js (LTS)              %GOLD%[ 6]%RESET%  Python
echo        %GOLD%[ 7]%RESET%  Rust (MSVC)                %GOLD%[ 8]%RESET%  Install ALL languages
echo.
echo   %GOLD%── NAVIGATION ──%RESET%  %GOLD%[B]%RESET% Categories   %GOLD%[Q]%RESET% Quit
echo   %GOLD%──────────────────────────────────────────────────────────────────────────────────────%RESET%
echo.
set "choice="
set /p "choice=   %GOLD%Select option:%RESET%  "
if not defined choice goto AppsCatLanguagesLoop
if /i "%choice%"=="B" goto AppsLoop
if /i "%choice%"=="Q" set "_QUIT=1" & goto :eof
if /i "%choice%"=="8" call :SeqInstallLanguages & goto AppsCatLanguagesLoop
if /i "%choice%"=="1" call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-Go.bat" & goto AppsCatLanguagesLoop
if /i "%choice%"=="2" call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-OpenJDK-21.bat" & goto AppsCatLanguagesLoop
if /i "%choice%"=="3" call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-OpenJDK-25.bat" & goto AppsCatLanguagesLoop
if /i "%choice%"=="4" call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-NodeJS-Current.bat" & goto AppsCatLanguagesLoop
if /i "%choice%"=="5" call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-NodeJS-LTS.bat" & goto AppsCatLanguagesLoop
if /i "%choice%"=="6" call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-Python.bat" & goto AppsCatLanguagesLoop
if /i "%choice%"=="7" call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-Rust.bat" & goto AppsCatLanguagesLoop
echo.
echo   Invalid choice: "%choice%"
echo.
pause
goto AppsCatLanguagesLoop

:AppsCatMedia
:AppsCatMediaLoop
call :SetConsoleSize 65 LOCK
cls
powershell -NoProfile -Command "try { [Console]::SetCursorPosition(0,0) } catch {}" >nul 2>&1
echo.
echo   %GOLD%── MEDIA ──%RESET%
echo        %GOLD%[ 1]%RESET%  AIMP                       %GOLD%[ 2]%RESET%  Blender
echo        %GOLD%[ 3]%RESET%  HandBrake                  %GOLD%[ 4]%RESET%  Jellyfin Media Player
echo        %GOLD%[ 5]%RESET%  Jellyfin Server            %GOLD%[ 6]%RESET%  OBS Studio
echo        %GOLD%[ 7]%RESET%  Plex Desktop               %GOLD%[ 8]%RESET%  Plex Media Server
echo        %GOLD%[ 9]%RESET%  VLC media player           %GOLD%[10]%RESET%  Install ALL media
echo.
echo   %GOLD%── NAVIGATION ──%RESET%  %GOLD%[B]%RESET% Categories   %GOLD%[Q]%RESET% Quit
echo   %GOLD%──────────────────────────────────────────────────────────────────────────────────────%RESET%
echo.
set "choice="
set /p "choice=   %GOLD%Select option:%RESET%  "
if not defined choice goto AppsCatMediaLoop
if /i "%choice%"=="B" goto AppsLoop
if /i "%choice%"=="Q" set "_QUIT=1" & goto :eof
if /i "%choice%"=="10" call :SeqInstallMedia & goto AppsCatMediaLoop
if /i "%choice%"=="1" call :RunOneNoTee "Winget\Apps\Media\Winget-Install-AIMP.bat" & goto AppsCatMediaLoop
if /i "%choice%"=="2" call :RunOneNoTee "Winget\Apps\Media\Winget-Install-Blender.bat" & goto AppsCatMediaLoop
if /i "%choice%"=="3" call :RunOneNoTee "Winget\Apps\Media\Winget-Install-HandBrake.bat" & goto AppsCatMediaLoop
if /i "%choice%"=="4" call :RunOneNoTee "Winget\Apps\Media\Winget-Install-JellyfinMediaPlayer.bat" & goto AppsCatMediaLoop
if /i "%choice%"=="5" call :RunOneNoTee "Winget\Apps\Media\Winget-Install-JellyfinServer.bat" & goto AppsCatMediaLoop
if /i "%choice%"=="6" call :RunOneNoTee "Winget\Apps\Media\Winget-Install-OBS.bat" & goto AppsCatMediaLoop
if /i "%choice%"=="7" call :RunOneNoTee "Winget\Apps\Media\Winget-Install-PlexDesktop.bat" & goto AppsCatMediaLoop
if /i "%choice%"=="8" call :RunOneNoTee "Winget\Apps\Media\Winget-Install-PlexMediaServer.bat" & goto AppsCatMediaLoop
if /i "%choice%"=="9" call :RunOneNoTee "Winget\Apps\Media\Winget-Install-VLC.bat" & goto AppsCatMediaLoop
echo.
echo   Invalid choice: "%choice%"
echo.
pause
goto AppsCatMediaLoop

:AppsCatNetworkRemote
:AppsCatNetworkRemoteLoop
call :SetConsoleSize 65 LOCK
cls
powershell -NoProfile -Command "try { [Console]::SetCursorPosition(0,0) } catch {}" >nul 2>&1
echo.
echo   %GOLD%── NETWORK ^& REMOTE ──%RESET%
echo        %GOLD%[ 1]%RESET%  Nmap                       %GOLD%[ 2]%RESET%  PuTTY
echo        %GOLD%[ 3]%RESET%  Tailscale                  %GOLD%[ 4]%RESET%  WinSCP
echo        %GOLD%[ 5]%RESET%  WireGuard                  %GOLD%[ 6]%RESET%  Wireshark
echo        %GOLD%[ 7]%RESET%  Install ALL network ^& remote
echo.
echo   %GOLD%── NAVIGATION ──%RESET%  %GOLD%[B]%RESET% Categories   %GOLD%[Q]%RESET% Quit
echo   %GOLD%──────────────────────────────────────────────────────────────────────────────────────%RESET%
echo.
set "choice="
set /p "choice=   %GOLD%Select option:%RESET%  "
if not defined choice goto AppsCatNetworkRemoteLoop
if /i "%choice%"=="B" goto AppsLoop
if /i "%choice%"=="Q" set "_QUIT=1" & goto :eof
if /i "%choice%"=="7" call :SeqInstallNetworkRemote & goto AppsCatNetworkRemoteLoop
if /i "%choice%"=="1" call :RunOneNoTee "Winget\Apps\NetworkRemote\Winget-Install-Nmap.bat" & goto AppsCatNetworkRemoteLoop
if /i "%choice%"=="2" call :RunOneNoTee "Winget\Apps\NetworkRemote\Winget-Install-PuTTY.bat" & goto AppsCatNetworkRemoteLoop
if /i "%choice%"=="3" call :RunOneNoTee "Winget\Apps\NetworkRemote\Winget-Install-Tailscale.bat" & goto AppsCatNetworkRemoteLoop
if /i "%choice%"=="4" call :RunOneNoTee "Winget\Apps\NetworkRemote\Winget-Install-WinSCP.bat" & goto AppsCatNetworkRemoteLoop
if /i "%choice%"=="5" call :RunOneNoTee "Winget\Apps\NetworkRemote\Winget-Install-WireGuard.bat" & goto AppsCatNetworkRemoteLoop
if /i "%choice%"=="6" call :RunOneNoTee "Winget\Apps\NetworkRemote\Winget-Install-Wireshark.bat" & goto AppsCatNetworkRemoteLoop
echo.
echo   Invalid choice: "%choice%"
echo.
pause
goto AppsCatNetworkRemoteLoop

:AppsCatOffice
:AppsCatOfficeLoop
call :SetConsoleSize 65 LOCK
cls
powershell -NoProfile -Command "try { [Console]::SetCursorPosition(0,0) } catch {}" >nul 2>&1
echo.
echo   %GOLD%── OFFICE ^& DOCUMENTS ──%RESET%
echo        %GOLD%[ 1]%RESET%  Audacity                   %GOLD%[ 2]%RESET%  GIMP
echo        %GOLD%[ 3]%RESET%  Inkscape                   %GOLD%[ 4]%RESET%  Krita
echo        %GOLD%[ 5]%RESET%  LibreOffice                %GOLD%[ 6]%RESET%  Notepad++
echo        %GOLD%[ 7]%RESET%  Paint.NET                  %GOLD%[ 8]%RESET%  Sumatra PDF
echo        %GOLD%[ 9]%RESET%  Install ALL office        
echo.
echo   %GOLD%── NAVIGATION ──%RESET%  %GOLD%[B]%RESET% Categories   %GOLD%[Q]%RESET% Quit
echo   %GOLD%──────────────────────────────────────────────────────────────────────────────────────%RESET%
echo.
set "choice="
set /p "choice=   %GOLD%Select option:%RESET%  "
if not defined choice goto AppsCatOfficeLoop
if /i "%choice%"=="B" goto AppsLoop
if /i "%choice%"=="Q" set "_QUIT=1" & goto :eof
if /i "%choice%"=="9" call :SeqInstallOffice & goto AppsCatOfficeLoop
if /i "%choice%"=="1" call :RunOneNoTee "Winget\Apps\Office\Winget-Install-Audacity.bat" & goto AppsCatOfficeLoop
if /i "%choice%"=="2" call :RunOneNoTee "Winget\Apps\Office\Winget-Install-GIMP.bat" & goto AppsCatOfficeLoop
if /i "%choice%"=="3" call :RunOneNoTee "Winget\Apps\Office\Winget-Install-Inkscape.bat" & goto AppsCatOfficeLoop
if /i "%choice%"=="4" call :RunOneNoTee "Winget\Apps\Office\Winget-Install-Krita.bat" & goto AppsCatOfficeLoop
if /i "%choice%"=="5" call :RunOneNoTee "Winget\Apps\Office\Winget-Install-LibreOffice.bat" & goto AppsCatOfficeLoop
if /i "%choice%"=="6" call :RunOneNoTee "Winget\Apps\Office\Winget-Install-NotepadPlusPlus.bat" & goto AppsCatOfficeLoop
if /i "%choice%"=="7" call :RunOneNoTee "Winget\Apps\Office\Winget-Install-PaintDotNet.bat" & goto AppsCatOfficeLoop
if /i "%choice%"=="8" call :RunOneNoTee "Winget\Apps\Office\Winget-Install-SumatraPDF.bat" & goto AppsCatOfficeLoop
echo.
echo   Invalid choice: "%choice%"
echo.
pause
goto AppsCatOfficeLoop

:AppsCatRuntimes
:AppsCatRuntimesLoop
call :SetConsoleSize 65 LOCK
cls
powershell -NoProfile -Command "try { [Console]::SetCursorPosition(0,0) } catch {}" >nul 2>&1
echo.
echo   %GOLD%── RUNTIMES ^& FRAMEWORKS ──%RESET%
echo        %GOLD%[ 1]%RESET%  .NET Desktop Runtime 10    %GOLD%[ 2]%RESET%  .NET Desktop Runtime 6
echo        %GOLD%[ 3]%RESET%  .NET Desktop Runtime 8     %GOLD%[ 4]%RESET%  .NET Desktop Runtime 9
echo        %GOLD%[ 5]%RESET%  PowerShell 7               %GOLD%[ 6]%RESET%  VC++ 2015-2022 Redist
echo        %GOLD%[ 7]%RESET%  WebView2 Runtime           %GOLD%[ 8]%RESET%  Install ALL runtimes
echo.
echo   %GOLD%── NAVIGATION ──%RESET%  %GOLD%[B]%RESET% Categories   %GOLD%[Q]%RESET% Quit
echo   %GOLD%──────────────────────────────────────────────────────────────────────────────────────%RESET%
echo.
set "choice="
set /p "choice=   %GOLD%Select option:%RESET%  "
if not defined choice goto AppsCatRuntimesLoop
if /i "%choice%"=="B" goto AppsLoop
if /i "%choice%"=="Q" set "_QUIT=1" & goto :eof
if /i "%choice%"=="8" call :SeqInstallRuntimes & goto AppsCatRuntimesLoop
if /i "%choice%"=="1" call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-10.bat" & goto AppsCatRuntimesLoop
if /i "%choice%"=="2" call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-6.bat" & goto AppsCatRuntimesLoop
if /i "%choice%"=="3" call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-8.bat" & goto AppsCatRuntimesLoop
if /i "%choice%"=="4" call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-9.bat" & goto AppsCatRuntimesLoop
if /i "%choice%"=="5" call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-PowerShell-7.bat" & goto AppsCatRuntimesLoop
if /i "%choice%"=="6" call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-VCRedist.bat" & goto AppsCatRuntimesLoop
if /i "%choice%"=="7" call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-WebView2.bat" & goto AppsCatRuntimesLoop
echo.
echo   Invalid choice: "%choice%"
echo.
pause
goto AppsCatRuntimesLoop

:AppsCatSecurity
:AppsCatSecurityLoop
call :SetConsoleSize 65 LOCK
cls
powershell -NoProfile -Command "try { [Console]::SetCursorPosition(0,0) } catch {}" >nul 2>&1
echo.
echo   %GOLD%── SECURITY ^& PRIVACY ──%RESET%
echo        %GOLD%[ 1]%RESET%  Bitwarden                  %GOLD%[ 2]%RESET%  KeePass
echo        %GOLD%[ 3]%RESET%  Malwarebytes               %GOLD%[ 4]%RESET%  Install ALL security
echo.
echo   %GOLD%── NAVIGATION ──%RESET%  %GOLD%[B]%RESET% Categories   %GOLD%[Q]%RESET% Quit
echo   %GOLD%──────────────────────────────────────────────────────────────────────────────────────%RESET%
echo.
set "choice="
set /p "choice=   %GOLD%Select option:%RESET%  "
if not defined choice goto AppsCatSecurityLoop
if /i "%choice%"=="B" goto AppsLoop
if /i "%choice%"=="Q" set "_QUIT=1" & goto :eof
if /i "%choice%"=="4" call :SeqInstallSecurity & goto AppsCatSecurityLoop
if /i "%choice%"=="1" call :RunOneNoTee "Winget\Apps\Security\Winget-Install-Bitwarden.bat" & goto AppsCatSecurityLoop
if /i "%choice%"=="2" call :RunOneNoTee "Winget\Apps\Security\Winget-Install-KeePass.bat" & goto AppsCatSecurityLoop
if /i "%choice%"=="3" call :RunOneNoTee "Winget\Apps\Security\Winget-Install-Malwarebytes.bat" & goto AppsCatSecurityLoop
echo.
echo   Invalid choice: "%choice%"
echo.
pause
goto AppsCatSecurityLoop

:AppsCatSystemTools
:AppsCatSystemToolsLoop
call :SetConsoleSize 65 LOCK
cls
powershell -NoProfile -Command "try { [Console]::SetCursorPosition(0,0) } catch {}" >nul 2>&1
echo.
echo   %GOLD%── SYSTEM TOOLS ──%RESET%
echo        %GOLD%[ 1]%RESET%  7-Zip                      %GOLD%[ 2]%RESET%  Autoruns
echo        %GOLD%[ 3]%RESET%  Balena Etcher              %GOLD%[ 4]%RESET%  BCUninstaller
echo        %GOLD%[ 5]%RESET%  PowerToys                  %GOLD%[ 6]%RESET%  Process Explorer
echo        %GOLD%[ 7]%RESET%  qBittorrent                %GOLD%[ 8]%RESET%  Rainmeter
echo        %GOLD%[ 9]%RESET%  Revo Uninstaller           %GOLD%[10]%RESET%  Rufus
echo        %GOLD%[11]%RESET%  ShareX                     %GOLD%[12]%RESET%  Ventoy
echo        %GOLD%[13]%RESET%  WinRAR                     %GOLD%[14]%RESET%  WizTree
echo        %GOLD%[15]%RESET%  Install ALL system tools  
echo.
echo   %GOLD%── NAVIGATION ──%RESET%  %GOLD%[B]%RESET% Categories   %GOLD%[Q]%RESET% Quit
echo   %GOLD%──────────────────────────────────────────────────────────────────────────────────────%RESET%
echo.
set "choice="
set /p "choice=   %GOLD%Select option:%RESET%  "
if not defined choice goto AppsCatSystemToolsLoop
if /i "%choice%"=="B" goto AppsLoop
if /i "%choice%"=="Q" set "_QUIT=1" & goto :eof
if /i "%choice%"=="15" call :SeqInstallSystemTools & goto AppsCatSystemToolsLoop
if /i "%choice%"=="1" call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-7Zip.bat" & goto AppsCatSystemToolsLoop
if /i "%choice%"=="2" call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-Autoruns.bat" & goto AppsCatSystemToolsLoop
if /i "%choice%"=="3" call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-BalenaEtcher.bat" & goto AppsCatSystemToolsLoop
if /i "%choice%"=="4" call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-BulkCrapUninstaller.bat" & goto AppsCatSystemToolsLoop
if /i "%choice%"=="5" call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-PowerToys.bat" & goto AppsCatSystemToolsLoop
if /i "%choice%"=="6" call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-ProcessExplorer.bat" & goto AppsCatSystemToolsLoop
if /i "%choice%"=="7" call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-qBittorrent.bat" & goto AppsCatSystemToolsLoop
if /i "%choice%"=="8" call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-Rainmeter.bat" & goto AppsCatSystemToolsLoop
if /i "%choice%"=="9" call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-RevoUninstaller.bat" & goto AppsCatSystemToolsLoop
if /i "%choice%"=="10" call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-Rufus.bat" & goto AppsCatSystemToolsLoop
if /i "%choice%"=="11" call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-ShareX.bat" & goto AppsCatSystemToolsLoop
if /i "%choice%"=="12" call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-Ventoy.bat" & goto AppsCatSystemToolsLoop
if /i "%choice%"=="13" call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-WinRAR.bat" & goto AppsCatSystemToolsLoop
if /i "%choice%"=="14" call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-WizTree.bat" & goto AppsCatSystemToolsLoop
echo.
echo   Invalid choice: "%choice%"
echo.
pause
goto AppsCatSystemToolsLoop

:AppsCatVirtualization
:AppsCatVirtualizationLoop
call :SetConsoleSize 65 LOCK
cls
powershell -NoProfile -Command "try { [Console]::SetCursorPosition(0,0) } catch {}" >nul 2>&1
echo.
echo   %GOLD%── VIRTUALIZATION ^& CONTAINERS ──%RESET%
echo        %GOLD%[ 1]%RESET%  Docker Desktop             %GOLD%[ 2]%RESET%  Helm
echo        %GOLD%[ 3]%RESET%  k9s                        %GOLD%[ 4]%RESET%  kubectl
echo        %GOLD%[ 5]%RESET%  Minikube                   %GOLD%[ 6]%RESET%  Terraform
echo        %GOLD%[ 7]%RESET%  Vagrant                    %GOLD%[ 8]%RESET%  VirtualBox
echo        %GOLD%[ 9]%RESET%  Install ALL virtualization
echo.
echo   %GOLD%── NAVIGATION ──%RESET%  %GOLD%[B]%RESET% Categories   %GOLD%[Q]%RESET% Quit
echo   %GOLD%──────────────────────────────────────────────────────────────────────────────────────%RESET%
echo.
set "choice="
set /p "choice=   %GOLD%Select option:%RESET%  "
if not defined choice goto AppsCatVirtualizationLoop
if /i "%choice%"=="B" goto AppsLoop
if /i "%choice%"=="Q" set "_QUIT=1" & goto :eof
if /i "%choice%"=="9" call :SeqInstallVirtualization & goto AppsCatVirtualizationLoop
if /i "%choice%"=="1" call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-DockerDesktop.bat" & goto AppsCatVirtualizationLoop
if /i "%choice%"=="2" call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-Helm.bat" & goto AppsCatVirtualizationLoop
if /i "%choice%"=="3" call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-k9s.bat" & goto AppsCatVirtualizationLoop
if /i "%choice%"=="4" call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-kubectl.bat" & goto AppsCatVirtualizationLoop
if /i "%choice%"=="5" call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-Minikube.bat" & goto AppsCatVirtualizationLoop
if /i "%choice%"=="6" call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-Terraform.bat" & goto AppsCatVirtualizationLoop
if /i "%choice%"=="7" call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-Vagrant.bat" & goto AppsCatVirtualizationLoop
if /i "%choice%"=="8" call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-VirtualBox.bat" & goto AppsCatVirtualizationLoop
echo.
echo   Invalid choice: "%choice%"
echo.
pause
goto AppsCatVirtualizationLoop
::  CONSOLE SIZE
:: ============================================================

:SetConsoleSize
:: %1 = visible window height in lines (cols fixed at 100)
:: Optional %2 = lock buffer height to window (no vertical scroll; use for tall menus)
mode con cols=100 lines=%~1 >nul 2>&1
if /i "%~2"=="LOCK" (
    powershell -NoProfile -Command "try { $h=%~1; [Console]::SetBufferSize(100,$h); [Console]::WindowHeight=$h } catch {}" >nul 2>&1
) else (
    powershell -NoProfile -Command "try { [Console]::SetBufferSize(100, 3000) } catch {}" >nul 2>&1
)
goto :eof

:: ============================================================
::  RUNNERS
:: ============================================================

:RunOne
:: %~1 = script path relative to Tools\ (may include subfolder)
:: Default runner. Pipes stdout+stderr through Tee-Object so the child's
:: full output ends up in the session log.
set "_SCRIPT=%TOOLS%\%~1"
set "_NAME=%~n1"
if not exist "%_SCRIPT%" (
    echo.
    echo   Missing tool: %~1
    echo   Expected at:  %_SCRIPT%
    echo.
    pause
    goto :eof
)
if not defined MAINT_NO_PAUSE cls

>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ------------------------------------------------------------
>> "%MAINT_LOG%" echo  %_NAME%   started %DATE% %TIME%
>> "%MAINT_LOG%" echo ------------------------------------------------------------

call "%_SCRIPT%" 2>&1 | powershell -NoProfile -Command "$input | Tee-Object -FilePath '%MAINT_LOG%' -Append"

>> "%MAINT_LOG%" echo  %_NAME%   finished %DATE% %TIME%
goto :eof

:RunOneNoTee
:: %~1 = script path relative to Tools\ (may include subfolder)
:: Same contract as :RunOne but does NOT pipe stdout through Tee-Object.
:: Used for tools whose progress UI relies on a real TTY (WinGet, etc.).
:: Output is shown live; only start/finish markers are written to the log.
set "_SCRIPT=%TOOLS%\%~1"
set "_NAME=%~n1"
if not exist "%_SCRIPT%" (
    echo.
    echo   Missing tool: %~1
    echo   Expected at:  %_SCRIPT%
    echo.
    pause
    goto :eof
)
if not defined MAINT_NO_PAUSE cls

>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ------------------------------------------------------------
>> "%MAINT_LOG%" echo  %_NAME%   started %DATE% %TIME%   (output not captured)
>> "%MAINT_LOG%" echo ------------------------------------------------------------

call "%_SCRIPT%"

>> "%MAINT_LOG%" echo  %_NAME%   finished %DATE% %TIME%
goto :eof

:OpenWingetLog
:: Opens WinGet's own diagnostic log folder in Explorer.
:: Falls back to the parent LocalState folder if the diag dir doesn't exist
:: yet (e.g. WinGet was installed but hasn't been used).
set "WG_DIAG=%LOCALAPPDATA%\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\DiagOutputDir"
set "WG_LOCAL=%LOCALAPPDATA%\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState"
echo.
if exist "%WG_DIAG%\" (
    echo   Opening WinGet diagnostic log folder...
    echo     %WG_DIAG%
    start "" "%WG_DIAG%"
) else if exist "%WG_LOCAL%\" (
    echo   WinGet diagnostic folder doesn't exist yet -- WinGet hasn't logged anything.
    echo   Opening WinGet's LocalState folder instead:
    echo     %WG_LOCAL%
    start "" "%WG_LOCAL%"
) else (
    echo   WinGet's local data folder was not found.
    echo   Make sure WinGet is installed (use option [1] in this menu^) and
    echo   has been run at least once.
    echo.
    pause
)
goto :eof

:: ============================================================
::  SEQUENCES
:: ============================================================

:SeqRepair
cls
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                       %GOLD%S E Q U E N C E   :   F U L L   R E P A I R%RESET%
echo                  CheckHealth  -^>  ScanHealth  -^>  RestoreHealth  -^>  SFC
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ############################################################
>> "%MAINT_LOG%" echo  SEQUENCE: Full Repair  -  %DATE% %TIME%
>> "%MAINT_LOG%" echo ############################################################
set "MAINT_NO_PAUSE=1"
call :RunOne "Repair\DISM-CheckHealth.bat"
call :RunOne "Repair\DISM-ScanHealth.bat"
call :RunOne "Repair\DISM-RestoreHealth.bat"
call :RunOne "Repair\SFC-Scannow.bat"
set "MAINT_NO_PAUSE="
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Repair sequence complete.%RESET%
echo     %DIM%Log: %MAINT_LOG%%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof

:SeqCleanup
cls
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                       %GOLD%S E Q U E N C E   :   F U L L   C L E A N U P%RESET%
echo                Temp  -^>  WU cache  -^>  Recycle Bin  -^>  Component store
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ############################################################
>> "%MAINT_LOG%" echo  SEQUENCE: Full Cleanup  -  %DATE% %TIME%
>> "%MAINT_LOG%" echo ############################################################
set "MAINT_NO_PAUSE=1"
call :RunOne "Cleanup\Cleanup-TempFiles.bat"
call :RunOne "Cleanup\Cleanup-WindowsUpdateCache.bat"
call :RunOne "Cleanup\Cleanup-RecycleBin.bat"
call :RunOne "Cleanup\Cleanup-ComponentStore.bat"
set "MAINT_NO_PAUSE="
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Cleanup sequence complete.%RESET%
echo     %DIM%Log: %MAINT_LOG%%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof

:SeqNetwork
cls
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                    %GOLD%S E Q U E N C E   :   N E T W O R K   R E F R E S H%RESET%
echo            Flush DNS  -^>  Renew IP  -^>  Register DNS  -^>  Clear ARP
echo            %DIM%(Winsock and TCP/IP resets are excluded -- they need a reboot.)%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ############################################################
>> "%MAINT_LOG%" echo  SEQUENCE: Network Refresh  -  %DATE% %TIME%
>> "%MAINT_LOG%" echo ############################################################
set "MAINT_NO_PAUSE=1"
call :RunOne "Network\Network-FlushDNS.bat"
call :RunOne "Network\Network-RenewIPAddress.bat"
call :RunOne "Network\Network-RegisterDNS.bat"
call :RunOne "Network\Network-ClearARPCache.bat"
set "MAINT_NO_PAUSE="
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Network sequence complete.%RESET%
echo     %DIM%Log: %MAINT_LOG%%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof




:SeqInstallBrowsers
cls
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                 %GOLD%S E Q U E N C E   :   I N S T A L L   BROWSERS%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ############################################################
>> "%MAINT_LOG%" echo  SEQUENCE: Install Browsers  -  %DATE% %TIME%
>> "%MAINT_LOG%" echo ############################################################
set "MAINT_NO_PAUSE=1"
call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-Brave.bat"
call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-Chrome.bat"
call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-LibreWolf.bat"
call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-Firefox.bat"
call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-OperaGX.bat"
set "MAINT_NO_PAUSE="
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Browsers install sequence complete.%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof



:SeqInstallCommunication
cls
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                 %GOLD%S E Q U E N C E   :   I N S T A L L   COMMUNICATION%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ############################################################
>> "%MAINT_LOG%" echo  SEQUENCE: Install Communication  -  %DATE% %TIME%
>> "%MAINT_LOG%" echo ############################################################
set "MAINT_NO_PAUSE=1"
call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Discord.bat"
call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Teams.bat"
call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Thunderbird.bat"
call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Signal.bat"
call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Slack.bat"
call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Telegram.bat"
call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Zoom.bat"
set "MAINT_NO_PAUSE="
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Communication install sequence complete.%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof



:SeqInstallDeveloper
cls
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                 %GOLD%S E Q U E N C E   :   I N S T A L L   DEV TOOLS%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ############################################################
>> "%MAINT_LOG%" echo  SEQUENCE: Install Developer  -  %DATE% %TIME%
>> "%MAINT_LOG%" echo ############################################################
set "MAINT_NO_PAUSE=1"
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-CMake.bat"
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-Cursor.bat"
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-Git.bat"
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-GitHubDesktop.bat"
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-IntelliJ.bat"
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-VSCode.bat"
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-VSCommunity2022.bat"
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-VSCommunity2026.bat"
set "MAINT_NO_PAUSE="
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Developer install sequence complete.%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof



:SeqInstallGames
cls
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                 %GOLD%S E Q U E N C E   :   I N S T A L L   GAMES%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ############################################################
>> "%MAINT_LOG%" echo  SEQUENCE: Install Games  -  %DATE% %TIME%
>> "%MAINT_LOG%" echo ############################################################
set "MAINT_NO_PAUSE=1"
call :RunOneNoTee "Winget\Apps\Games\Winget-Install-BattleNet.bat"
call :RunOneNoTee "Winget\Apps\Games\Winget-Install-EADesktop.bat"
call :RunOneNoTee "Winget\Apps\Games\Winget-Install-EpicGames.bat"
call :RunOneNoTee "Winget\Apps\Games\Winget-Install-GOGGalaxy.bat"
call :RunOneNoTee "Winget\Apps\Games\Winget-Install-Itch.bat"
call :RunOneNoTee "Winget\Apps\Games\Winget-Install-Moonlight.bat"
call :RunOneNoTee "Winget\Apps\Games\Winget-Install-GeForceNow.bat"
call :RunOneNoTee "Winget\Apps\Games\Winget-Install-Steam.bat"
call :RunOneNoTee "Winget\Apps\Games\Winget-Install-UbisoftConnect.bat"
set "MAINT_NO_PAUSE="
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Games install sequence complete.%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof



:SeqInstallHardware
cls
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                 %GOLD%S E Q U E N C E   :   I N S T A L L   HARDWARE & DIAGNOSTICS%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ############################################################
>> "%MAINT_LOG%" echo  SEQUENCE: Install Hardware  -  %DATE% %TIME%
>> "%MAINT_LOG%" echo ############################################################
set "MAINT_NO_PAUSE=1"
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-CPU-Z.bat"
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-CrystalDiskInfo.bat"
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-CrystalDiskMark.bat"
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-DisplayDriverUninstaller.bat"
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-FanControl.bat"
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-GPU-Z.bat"
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-HWiNFO.bat"
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-HWMonitor.bat"
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-MSIAfterburner.bat"
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-OpenRGB.bat"
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-SnappyDriverInstaller.bat"
set "MAINT_NO_PAUSE="
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Hardware install sequence complete.%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof



:SeqInstallLanguages
cls
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                 %GOLD%S E Q U E N C E   :   I N S T A L L   LANGUAGES%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ############################################################
>> "%MAINT_LOG%" echo  SEQUENCE: Install Languages  -  %DATE% %TIME%
>> "%MAINT_LOG%" echo ############################################################
set "MAINT_NO_PAUSE=1"
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-Go.bat"
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-OpenJDK-21.bat"
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-OpenJDK-25.bat"
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-NodeJS-Current.bat"
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-NodeJS-LTS.bat"
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-Python.bat"
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-Rust.bat"
set "MAINT_NO_PAUSE="
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Languages install sequence complete.%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof



:SeqInstallMedia
cls
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                 %GOLD%S E Q U E N C E   :   I N S T A L L   MEDIA%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ############################################################
>> "%MAINT_LOG%" echo  SEQUENCE: Install Media  -  %DATE% %TIME%
>> "%MAINT_LOG%" echo ############################################################
set "MAINT_NO_PAUSE=1"
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-AIMP.bat"
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-Blender.bat"
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-HandBrake.bat"
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-JellyfinMediaPlayer.bat"
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-JellyfinServer.bat"
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-OBS.bat"
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-PlexDesktop.bat"
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-PlexMediaServer.bat"
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-VLC.bat"
set "MAINT_NO_PAUSE="
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Media install sequence complete.%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof



:SeqInstallNetworkRemote
cls
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                 %GOLD%S E Q U E N C E   :   I N S T A L L   NETWORK & REMOTE%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ############################################################
>> "%MAINT_LOG%" echo  SEQUENCE: Install NetworkRemote  -  %DATE% %TIME%
>> "%MAINT_LOG%" echo ############################################################
set "MAINT_NO_PAUSE=1"
call :RunOneNoTee "Winget\Apps\NetworkRemote\Winget-Install-Nmap.bat"
call :RunOneNoTee "Winget\Apps\NetworkRemote\Winget-Install-PuTTY.bat"
call :RunOneNoTee "Winget\Apps\NetworkRemote\Winget-Install-Tailscale.bat"
call :RunOneNoTee "Winget\Apps\NetworkRemote\Winget-Install-WinSCP.bat"
call :RunOneNoTee "Winget\Apps\NetworkRemote\Winget-Install-WireGuard.bat"
call :RunOneNoTee "Winget\Apps\NetworkRemote\Winget-Install-Wireshark.bat"
set "MAINT_NO_PAUSE="
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%NetworkRemote install sequence complete.%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof



:SeqInstallOffice
cls
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                 %GOLD%S E Q U E N C E   :   I N S T A L L   OFFICE & DOCUMENTS%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ############################################################
>> "%MAINT_LOG%" echo  SEQUENCE: Install Office  -  %DATE% %TIME%
>> "%MAINT_LOG%" echo ############################################################
set "MAINT_NO_PAUSE=1"
call :RunOneNoTee "Winget\Apps\Office\Winget-Install-Audacity.bat"
call :RunOneNoTee "Winget\Apps\Office\Winget-Install-GIMP.bat"
call :RunOneNoTee "Winget\Apps\Office\Winget-Install-Inkscape.bat"
call :RunOneNoTee "Winget\Apps\Office\Winget-Install-Krita.bat"
call :RunOneNoTee "Winget\Apps\Office\Winget-Install-LibreOffice.bat"
call :RunOneNoTee "Winget\Apps\Office\Winget-Install-NotepadPlusPlus.bat"
call :RunOneNoTee "Winget\Apps\Office\Winget-Install-PaintDotNet.bat"
call :RunOneNoTee "Winget\Apps\Office\Winget-Install-SumatraPDF.bat"
set "MAINT_NO_PAUSE="
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Office install sequence complete.%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof



:SeqInstallRuntimes
cls
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                 %GOLD%S E Q U E N C E   :   I N S T A L L   RUNTIMES & FRAMEWORKS%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ############################################################
>> "%MAINT_LOG%" echo  SEQUENCE: Install Runtimes  -  %DATE% %TIME%
>> "%MAINT_LOG%" echo ############################################################
set "MAINT_NO_PAUSE=1"
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-10.bat"
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-6.bat"
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-8.bat"
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-9.bat"
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-PowerShell-7.bat"
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-VCRedist.bat"
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-WebView2.bat"
set "MAINT_NO_PAUSE="
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Runtimes install sequence complete.%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof



:SeqInstallSecurity
cls
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                 %GOLD%S E Q U E N C E   :   I N S T A L L   SECURITY & PRIVACY%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ############################################################
>> "%MAINT_LOG%" echo  SEQUENCE: Install Security  -  %DATE% %TIME%
>> "%MAINT_LOG%" echo ############################################################
set "MAINT_NO_PAUSE=1"
call :RunOneNoTee "Winget\Apps\Security\Winget-Install-Bitwarden.bat"
call :RunOneNoTee "Winget\Apps\Security\Winget-Install-KeePass.bat"
call :RunOneNoTee "Winget\Apps\Security\Winget-Install-Malwarebytes.bat"
set "MAINT_NO_PAUSE="
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Security install sequence complete.%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof



:SeqInstallSystemTools
cls
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                 %GOLD%S E Q U E N C E   :   I N S T A L L   SYSTEM TOOLS%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ############################################################
>> "%MAINT_LOG%" echo  SEQUENCE: Install SystemTools  -  %DATE% %TIME%
>> "%MAINT_LOG%" echo ############################################################
set "MAINT_NO_PAUSE=1"
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-7Zip.bat"
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-Autoruns.bat"
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-BalenaEtcher.bat"
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-BulkCrapUninstaller.bat"
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-PowerToys.bat"
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-ProcessExplorer.bat"
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-qBittorrent.bat"
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-Rainmeter.bat"
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-RevoUninstaller.bat"
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-Rufus.bat"
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-ShareX.bat"
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-Ventoy.bat"
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-WinRAR.bat"
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-WizTree.bat"
set "MAINT_NO_PAUSE="
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%SystemTools install sequence complete.%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof



:SeqInstallVirtualization
cls
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                 %GOLD%S E Q U E N C E   :   I N S T A L L   VIRTUALIZATION & CONTAINERS%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ############################################################
>> "%MAINT_LOG%" echo  SEQUENCE: Install Virtualization  -  %DATE% %TIME%
>> "%MAINT_LOG%" echo ############################################################
set "MAINT_NO_PAUSE=1"
call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-DockerDesktop.bat"
call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-Helm.bat"
call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-k9s.bat"
call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-kubectl.bat"
call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-Minikube.bat"
call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-Terraform.bat"
call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-Vagrant.bat"
call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-VirtualBox.bat"
set "MAINT_NO_PAUSE="
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Virtualization install sequence complete.%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof


:SeqInstallAllApps
cls
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                  %GOLD%S E Q U E N C E   :   I N S T A L L   E V E R Y T H I N G%RESET%
echo            Categories A-Z, each item A-Z within category
echo            %DIM%(102 packages total. Allow time and a stable internet connection.)%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ############################################################
>> "%MAINT_LOG%" echo  SEQUENCE: Install ALL Apps  -  %DATE% %TIME%
>> "%MAINT_LOG%" echo ############################################################
set "MAINT_NO_PAUSE=1"
:: Browsers
call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-Brave.bat"
call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-Chrome.bat"
call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-LibreWolf.bat"
call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-Firefox.bat"
call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-OperaGX.bat"
:: Communication
call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Discord.bat"
call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Teams.bat"
call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Thunderbird.bat"
call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Signal.bat"
call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Slack.bat"
call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Telegram.bat"
call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Zoom.bat"
:: Developer
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-CMake.bat"
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-Cursor.bat"
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-Git.bat"
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-GitHubDesktop.bat"
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-IntelliJ.bat"
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-VSCode.bat"
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-VSCommunity2022.bat"
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-VSCommunity2026.bat"
:: Games
call :RunOneNoTee "Winget\Apps\Games\Winget-Install-BattleNet.bat"
call :RunOneNoTee "Winget\Apps\Games\Winget-Install-EADesktop.bat"
call :RunOneNoTee "Winget\Apps\Games\Winget-Install-EpicGames.bat"
call :RunOneNoTee "Winget\Apps\Games\Winget-Install-GOGGalaxy.bat"
call :RunOneNoTee "Winget\Apps\Games\Winget-Install-Itch.bat"
call :RunOneNoTee "Winget\Apps\Games\Winget-Install-Moonlight.bat"
call :RunOneNoTee "Winget\Apps\Games\Winget-Install-GeForceNow.bat"
call :RunOneNoTee "Winget\Apps\Games\Winget-Install-Steam.bat"
call :RunOneNoTee "Winget\Apps\Games\Winget-Install-UbisoftConnect.bat"
:: Hardware
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-CPU-Z.bat"
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-CrystalDiskInfo.bat"
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-CrystalDiskMark.bat"
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-DisplayDriverUninstaller.bat"
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-FanControl.bat"
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-GPU-Z.bat"
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-HWiNFO.bat"
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-HWMonitor.bat"
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-MSIAfterburner.bat"
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-OpenRGB.bat"
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-SnappyDriverInstaller.bat"
:: Languages
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-Go.bat"
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-OpenJDK-21.bat"
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-OpenJDK-25.bat"
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-NodeJS-Current.bat"
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-NodeJS-LTS.bat"
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-Python.bat"
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-Rust.bat"
:: Media
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-AIMP.bat"
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-Blender.bat"
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-HandBrake.bat"
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-JellyfinMediaPlayer.bat"
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-JellyfinServer.bat"
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-OBS.bat"
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-PlexDesktop.bat"
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-PlexMediaServer.bat"
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-VLC.bat"
:: NetworkRemote
call :RunOneNoTee "Winget\Apps\NetworkRemote\Winget-Install-Nmap.bat"
call :RunOneNoTee "Winget\Apps\NetworkRemote\Winget-Install-PuTTY.bat"
call :RunOneNoTee "Winget\Apps\NetworkRemote\Winget-Install-Tailscale.bat"
call :RunOneNoTee "Winget\Apps\NetworkRemote\Winget-Install-WinSCP.bat"
call :RunOneNoTee "Winget\Apps\NetworkRemote\Winget-Install-WireGuard.bat"
call :RunOneNoTee "Winget\Apps\NetworkRemote\Winget-Install-Wireshark.bat"
:: Office
call :RunOneNoTee "Winget\Apps\Office\Winget-Install-Audacity.bat"
call :RunOneNoTee "Winget\Apps\Office\Winget-Install-GIMP.bat"
call :RunOneNoTee "Winget\Apps\Office\Winget-Install-Inkscape.bat"
call :RunOneNoTee "Winget\Apps\Office\Winget-Install-Krita.bat"
call :RunOneNoTee "Winget\Apps\Office\Winget-Install-LibreOffice.bat"
call :RunOneNoTee "Winget\Apps\Office\Winget-Install-NotepadPlusPlus.bat"
call :RunOneNoTee "Winget\Apps\Office\Winget-Install-PaintDotNet.bat"
call :RunOneNoTee "Winget\Apps\Office\Winget-Install-SumatraPDF.bat"
:: Runtimes
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-10.bat"
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-6.bat"
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-8.bat"
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-9.bat"
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-PowerShell-7.bat"
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-VCRedist.bat"
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-WebView2.bat"
:: Security
call :RunOneNoTee "Winget\Apps\Security\Winget-Install-Bitwarden.bat"
call :RunOneNoTee "Winget\Apps\Security\Winget-Install-KeePass.bat"
call :RunOneNoTee "Winget\Apps\Security\Winget-Install-Malwarebytes.bat"
:: SystemTools
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-7Zip.bat"
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-Autoruns.bat"
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-BalenaEtcher.bat"
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-BulkCrapUninstaller.bat"
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-PowerToys.bat"
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-ProcessExplorer.bat"
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-qBittorrent.bat"
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-Rainmeter.bat"
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-RevoUninstaller.bat"
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-Rufus.bat"
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-ShareX.bat"
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-Ventoy.bat"
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-WinRAR.bat"
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-WizTree.bat"
:: Virtualization
call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-DockerDesktop.bat"
call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-Helm.bat"
call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-k9s.bat"
call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-kubectl.bat"
call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-Minikube.bat"
call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-Terraform.bat"
call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-Vagrant.bat"
call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-VirtualBox.bat"
set "MAINT_NO_PAUSE="
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Full app install sequence complete.%RESET%
echo     %DIM%Log: %MAINT_LOG%%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof



:SeqFull
call :SeqRepair
call :SeqCleanup
call :SeqNetwork
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Full maintenance complete.%RESET%
echo     If SFC reported files it could not fix while Windows was running,
echo     reboot and re-run the %GOLD%[R]%RESET% repair sequence.
echo     %DIM%Log: %MAINT_LOG%%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof

:ViewLog
cls
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Current session log%RESET%
echo     %DIM%%MAINT_LOG%%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
if exist "%MAINT_LOG%" (
    more < "%MAINT_LOG%"
) else (
    echo   No log entries yet.
)
echo.
pause
goto :eof

:: ============================================================
::  EXIT
:: ============================================================

:END
>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ============================================================
>> "%MAINT_LOG%" echo  Session ended %DATE% %TIME%
>> "%MAINT_LOG%" echo ============================================================
cls
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Maintenance session complete.%RESET%
echo.
echo     Log saved to:
echo       %DIM%%MAINT_LOG%%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
:: Restore original codepage and default colors.
if defined _ORIGCP chcp %_ORIGCP% >nul
color
endlocal
exit 0
