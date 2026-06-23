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
::  Default height fits main/WinGet menus. Install Apps submenu
::  Install Apps uses the same console size as every other menu (see :AppsLoop).
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
echo.
echo   %GOLD%╔══════════════════════════════════════════════════════════════════════════════════════╗%RESET%
echo   %GOLD%║                                                                                      ║%RESET%
echo   %GOLD%║                       W I N D O W S   M A I N T E N A N C E                          ║%RESET%
echo   %GOLD%║                                                                                      ║%RESET%
echo   %GOLD%╚══════════════════════════════════════════════════════════════════════════════════════╝%RESET%
echo     %GOLD%Session log:%RESET%  %DIM%%MAINT_LOG%%RESET%
echo.
echo   %GOLD%── SYSTEM REPAIR ─────────────────────────────────────────────────────────────────────%RESET%
echo      %GOLD%[ 1]%RESET%  DISM CheckHealth          Quick flag check (seconds)
echo      %GOLD%[ 2]%RESET%  DISM ScanHealth           Deep scan, no repair
echo      %GOLD%[ 3]%RESET%  DISM RestoreHealth        Repair component store
echo      %GOLD%[ 4]%RESET%  SFC /scannow              Repair protected system files
echo      %GOLD%[ 5]%RESET%  CHKDSK read-only scan     Online check, no repair
echo      %GOLD%[ 6]%RESET%  CHKDSK full repair        Schedules on next reboot
echo.
echo   %GOLD%── CLEANUP ───────────────────────────────────────────────────────────────────────────%RESET%
echo      %GOLD%[ 7]%RESET%  Temp files                Wipes %%TEMP%% and Windows\Temp
echo      %GOLD%[ 8]%RESET%  Windows Update cache      Reset SoftwareDistribution\Download
echo      %GOLD%[ 9]%RESET%  Recycle Bin               Empty all drives
echo      %GOLD%[10]%RESET%  Component store (WinSxS)  Reclaim disk from old updates
echo      %GOLD%[11]%RESET%  Disk Cleanup (GUI)        Launches cleanmgr.exe
echo      %GOLD%[12]%RESET%  DiskPart                  Guide in Notepad + list disks
echo.
echo   %GOLD%── NETWORK ───────────────────────────────────────────────────────────────────────────%RESET%
echo      %GOLD%[13]%RESET%  Flush DNS cache           ipconfig /flushdns
echo      %GOLD%[14]%RESET%  Renew IP address          ipconfig /release + /renew
echo      %GOLD%[15]%RESET%  Register DNS              ipconfig /registerdns
echo      %GOLD%[16]%RESET%  Clear ARP cache           arp -d *
echo      %GOLD%[17]%RESET%  Reset Winsock             REBOOT REQUIRED
echo      %GOLD%[18]%RESET%  Reset TCP/IP stack        REBOOT REQUIRED
echo      %GOLD%[19]%RESET%  Show IP configuration     Read-only diagnostic
echo.
echo   %GOLD%── PACKAGE MANAGEMENT ────────────────────────────────────────────────────────────────%RESET%
echo      %GOLD%[W]%RESET%   WinGet Manager...         Install / update apps via WinGet
echo.
echo   %GOLD%── SEQUENCES%RESET%  %DIM%(no pauses between steps)%RESET% %GOLD%─────────────────────────────────────────────%RESET%
echo      %GOLD%[R]%RESET%   Full repair          =  1, 2, 3, 4
echo      %GOLD%[L]%RESET%   Full cleanup         =  7, 8, 9, 10
echo      %GOLD%[N]%RESET%   Network refresh      =  13, 14, 15, 16
echo      %GOLD%[F]%RESET%   Full maintenance     =  R  then  L  then  N
echo.
echo   %GOLD%── UTILITY ───────────────────────────────────────────────────────────────────────────%RESET%
echo      %GOLD%[V]%RESET%   View current session log
echo      %GOLD%[O]%RESET%   Open Logs folder in Explorer
echo      %GOLD%[Q]%RESET%   Quit
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
:: ============================================================

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
echo   %GOLD%── BROWSERS ──%RESET%
echo      %GOLD%[ 1]%RESET%  Brave Browser              %GOLD%[ 4]%RESET%  Install ALL browsers
echo      %GOLD%[ 2]%RESET%  Google Chrome
echo      %GOLD%[ 3]%RESET%  Mozilla Firefox
echo   %GOLD%── COMMUNICATION ──%RESET%
echo      %GOLD%[ 5]%RESET%  Discord                    %GOLD%[ 7]%RESET%  Install ALL communication
echo      %GOLD%[ 6]%RESET%  Telegram Desktop
echo   %GOLD%── DEV TOOLS ──%RESET%
echo      %GOLD%[ 8]%RESET%  CMake                      %GOLD%[11]%RESET%  GitHub Desktop
echo      %GOLD%[ 9]%RESET%  Cursor                     %GOLD%[12]%RESET%  IntelliJ IDEA
echo      %GOLD%[10]%RESET%  Git                        %GOLD%[13]%RESET%  VS Code
echo      %GOLD%[14]%RESET%  VS Community 2022          %GOLD%[15]%RESET%  VS Community 2026
echo      %GOLD%[16]%RESET%  Install ALL dev tools
echo   %GOLD%── DRIVERS ──%RESET%
echo      %GOLD%[17]%RESET%  Snappy Driver Installer
echo   %GOLD%── GAME LAUNCHERS ──%RESET%
echo      %GOLD%[18]%RESET%  Epic Games Launcher        %GOLD%[21]%RESET%  Install ALL game launchers
echo      %GOLD%[19]%RESET%  itch.io
echo      %GOLD%[20]%RESET%  Steam
echo   %GOLD%── LANGUAGES ──%RESET%
echo      %GOLD%[22]%RESET%  Go (Golang)                %GOLD%[25]%RESET%  OpenJDK 21
echo      %GOLD%[23]%RESET%  Node.js (Current)          %GOLD%[26]%RESET%  OpenJDK 25
echo      %GOLD%[24]%RESET%  Node.js (LTS)              %GOLD%[27]%RESET%  Python
echo      %GOLD%[28]%RESET%  Rust                       %GOLD%[29]%RESET%  Install ALL languages
echo   %GOLD%── MEDIA ──%RESET%
echo      %GOLD%[30]%RESET%  AIMP                       %GOLD%[33]%RESET%  Jellyfin Server
echo      %GOLD%[31]%RESET%  HandBrake                  %GOLD%[34]%RESET%  OBS Studio
echo      %GOLD%[32]%RESET%  Jellyfin Media Player      %GOLD%[35]%RESET%  Plex Desktop
echo      %GOLD%[36]%RESET%  Plex Media Server          %GOLD%[38]%RESET%  Install ALL media
echo      %GOLD%[37]%RESET%  VLC media player
echo   %GOLD%── PRODUCTIVITY ──%RESET%
echo      %GOLD%[39]%RESET%  Audacity                   %GOLD%[42]%RESET%  LibreOffice
echo      %GOLD%[40]%RESET%  Blender                    %GOLD%[43]%RESET%  Notepad++
echo      %GOLD%[41]%RESET%  GIMP                       %GOLD%[44]%RESET%  Install ALL productivity
echo   %GOLD%── RUNTIMES ^& FRAMEWORKS ──%RESET%
echo      %GOLD%[45]%RESET%  .NET Desktop Runtime 6       %GOLD%[48]%RESET%  .NET Desktop Runtime 10
echo      %GOLD%[46]%RESET%  .NET Desktop Runtime 8       %GOLD%[49]%RESET%  PowerShell 7
echo      %GOLD%[47]%RESET%  .NET Desktop Runtime 9       %GOLD%[50]%RESET%  VC++ 2015-2022 Redist
echo      %GOLD%[51]%RESET%  WebView2 Runtime           %GOLD%[52]%RESET%  Install ALL runtimes
echo   %GOLD%── UTILITY ──%RESET%
echo      %GOLD%[53]%RESET%  7-Zip                      %GOLD%[56]%RESET%  Docker Desktop
echo      %GOLD%[54]%RESET%  Balena Etcher              %GOLD%[57]%RESET%  PowerToys
echo      %GOLD%[55]%RESET%  BCUninstaller              %GOLD%[58]%RESET%  MSI Afterburner
echo      %GOLD%[59]%RESET%  qBittorrent                %GOLD%[62]%RESET%  Ventoy
echo      %GOLD%[60]%RESET%  Revo Uninstaller           %GOLD%[63]%RESET%  WinRAR
echo      %GOLD%[61]%RESET%  Rufus                      %GOLD%[64]%RESET%  Install ALL utility
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

if /i "%choice%"=="1"  call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-Brave.bat"              & goto AppsLoop
if /i "%choice%"=="2"  call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-Chrome.bat"             & goto AppsLoop
if /i "%choice%"=="3"  call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-Firefox.bat"            & goto AppsLoop
if /i "%choice%"=="4"  call :SeqInstallBrowsers       & goto AppsLoop
if /i "%choice%"=="5"  call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Discord.bat"       & goto AppsLoop
if /i "%choice%"=="6"  call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Telegram.bat"      & goto AppsLoop
if /i "%choice%"=="7"  call :SeqInstallCommunication  & goto AppsLoop
if /i "%choice%"=="8"  call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-CMake.bat"               & goto AppsLoop
if /i "%choice%"=="9"  call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-Cursor.bat"             & goto AppsLoop
if /i "%choice%"=="10" call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-Git.bat"               & goto AppsLoop
if /i "%choice%"=="11" call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-GitHubDesktop.bat"      & goto AppsLoop
if /i "%choice%"=="12" call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-IntelliJ.bat"           & goto AppsLoop
if /i "%choice%"=="13" call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-VSCode.bat"            & goto AppsLoop
if /i "%choice%"=="14" call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-VSCommunity2022.bat"   & goto AppsLoop
if /i "%choice%"=="15" call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-VSCommunity2026.bat"   & goto AppsLoop
if /i "%choice%"=="16" call :SeqInstallDevTools       & goto AppsLoop
if /i "%choice%"=="17" call :RunOneNoTee "Winget\Apps\Drivers\Winget-Install-SnappyDriverInstaller.bat" & goto AppsLoop
if /i "%choice%"=="18" call :RunOneNoTee "Winget\Apps\GameLaunchers\Winget-Install-EpicGames.bat"     & goto AppsLoop
if /i "%choice%"=="19" call :RunOneNoTee "Winget\Apps\GameLaunchers\Winget-Install-Itch.bat"          & goto AppsLoop
if /i "%choice%"=="20" call :RunOneNoTee "Winget\Apps\GameLaunchers\Winget-Install-Steam.bat"         & goto AppsLoop
if /i "%choice%"=="21" call :SeqInstallGameLaunchers  & goto AppsLoop
if /i "%choice%"=="22" call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-Go.bat"               & goto AppsLoop
if /i "%choice%"=="23" call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-NodeJS-Current.bat"    & goto AppsLoop
if /i "%choice%"=="24" call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-NodeJS-LTS.bat"        & goto AppsLoop
if /i "%choice%"=="25" call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-OpenJDK-21.bat"        & goto AppsLoop
if /i "%choice%"=="26" call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-OpenJDK-25.bat"        & goto AppsLoop
if /i "%choice%"=="27" call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-Python.bat"          & goto AppsLoop
if /i "%choice%"=="28" call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-Rust.bat"              & goto AppsLoop
if /i "%choice%"=="29" call :SeqInstallLanguages      & goto AppsLoop
if /i "%choice%"=="30" call :RunOneNoTee "Winget\Apps\Media\Winget-Install-AIMP.bat"                 & goto AppsLoop
if /i "%choice%"=="31" call :RunOneNoTee "Winget\Apps\Media\Winget-Install-HandBrake.bat"             & goto AppsLoop
if /i "%choice%"=="32" call :RunOneNoTee "Winget\Apps\Media\Winget-Install-JellyfinMediaPlayer.bat"  & goto AppsLoop
if /i "%choice%"=="33" call :RunOneNoTee "Winget\Apps\Media\Winget-Install-JellyfinServer.bat"       & goto AppsLoop
if /i "%choice%"=="34" call :RunOneNoTee "Winget\Apps\Media\Winget-Install-OBS.bat"                   & goto AppsLoop
if /i "%choice%"=="35" call :RunOneNoTee "Winget\Apps\Media\Winget-Install-PlexDesktop.bat"          & goto AppsLoop
if /i "%choice%"=="36" call :RunOneNoTee "Winget\Apps\Media\Winget-Install-PlexMediaServer.bat"      & goto AppsLoop
if /i "%choice%"=="37" call :RunOneNoTee "Winget\Apps\Media\Winget-Install-VLC.bat"                  & goto AppsLoop
if /i "%choice%"=="38" call :SeqInstallMedia          & goto AppsLoop
if /i "%choice%"=="39" call :RunOneNoTee "Winget\Apps\Productivity\Winget-Install-Audacity.bat"       & goto AppsLoop
if /i "%choice%"=="40" call :RunOneNoTee "Winget\Apps\Productivity\Winget-Install-Blender.bat"        & goto AppsLoop
if /i "%choice%"=="41" call :RunOneNoTee "Winget\Apps\Productivity\Winget-Install-GIMP.bat"            & goto AppsLoop
if /i "%choice%"=="42" call :RunOneNoTee "Winget\Apps\Productivity\Winget-Install-LibreOffice.bat"     & goto AppsLoop
if /i "%choice%"=="43" call :RunOneNoTee "Winget\Apps\Productivity\Winget-Install-NotepadPlusPlus.bat" & goto AppsLoop
if /i "%choice%"=="44" call :SeqInstallProductivity   & goto AppsLoop
if /i "%choice%"=="45" call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-6.bat"   & goto AppsLoop
if /i "%choice%"=="46" call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-8.bat"   & goto AppsLoop
if /i "%choice%"=="47" call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-9.bat"   & goto AppsLoop
if /i "%choice%"=="48" call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-10.bat"  & goto AppsLoop
if /i "%choice%"=="49" call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-PowerShell-7.bat"       & goto AppsLoop
if /i "%choice%"=="50" call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-VCRedist.bat"           & goto AppsLoop
if /i "%choice%"=="51" call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-WebView2.bat"           & goto AppsLoop
if /i "%choice%"=="52" call :SeqInstallRuntimes       & goto AppsLoop
if /i "%choice%"=="53" call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-7Zip.bat"                & goto AppsLoop
if /i "%choice%"=="54" call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-BalenaEtcher.bat"        & goto AppsLoop
if /i "%choice%"=="55" call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-BulkCrapUninstaller.bat"  & goto AppsLoop
if /i "%choice%"=="56" call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-DockerDesktop.bat"       & goto AppsLoop
if /i "%choice%"=="57" call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-PowerToys.bat"           & goto AppsLoop
if /i "%choice%"=="58" call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-MSIAfterburner.bat"      & goto AppsLoop
if /i "%choice%"=="59" call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-qBittorrent.bat"         & goto AppsLoop
if /i "%choice%"=="60" call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-RevoUninstaller.bat"     & goto AppsLoop
if /i "%choice%"=="61" call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-Rufus.bat"               & goto AppsLoop
if /i "%choice%"=="62" call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-Ventoy.bat"              & goto AppsLoop
if /i "%choice%"=="63" call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-WinRAR.bat"              & goto AppsLoop
if /i "%choice%"=="64" call :SeqInstallUtility        & goto AppsLoop
if /i "%choice%"=="A"  call :SeqInstallAllApps        & goto AppsLoop

echo.
echo   Invalid choice: "%choice%"
echo.
pause
goto AppsLoop

:: ============================================================
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
echo                      %GOLD%S E Q U E N C E   :   I N S T A L L   B R O W S E R S%RESET%
echo                              Brave  -^>  Chrome  -^>  Firefox
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ############################################################
>> "%MAINT_LOG%" echo  SEQUENCE: Install Browsers  -  %DATE% %TIME%
>> "%MAINT_LOG%" echo ############################################################
set "MAINT_NO_PAUSE=1"
call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-Brave.bat"
call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-Chrome.bat"
call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-Firefox.bat"
set "MAINT_NO_PAUSE="
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Browser install sequence complete.%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof

:SeqInstallCommunication
cls
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                 %GOLD%S E Q U E N C E   :   I N S T A L L   C O M M U N I C A T I O N%RESET%
echo                              Discord  -^>  Telegram Desktop
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ############################################################
>> "%MAINT_LOG%" echo  SEQUENCE: Install Communication  -  %DATE% %TIME%
>> "%MAINT_LOG%" echo ############################################################
set "MAINT_NO_PAUSE=1"
call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Discord.bat"
call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Telegram.bat"
set "MAINT_NO_PAUSE="
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Communication install sequence complete.%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof

:SeqInstallGameLaunchers
cls
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                 %GOLD%S E Q U E N C E   :   I N S T A L L   G A M E   L A U N C H E R S%RESET%
echo                         Epic Games  -^>  itch.io  -^>  Steam
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ############################################################
>> "%MAINT_LOG%" echo  SEQUENCE: Install Game Launchers  -  %DATE% %TIME%
>> "%MAINT_LOG%" echo ############################################################
set "MAINT_NO_PAUSE=1"
call :RunOneNoTee "Winget\Apps\GameLaunchers\Winget-Install-EpicGames.bat"
call :RunOneNoTee "Winget\Apps\GameLaunchers\Winget-Install-Itch.bat"
call :RunOneNoTee "Winget\Apps\GameLaunchers\Winget-Install-Steam.bat"
set "MAINT_NO_PAUSE="
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Game launcher install sequence complete.%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof

:SeqInstallRuntimes
cls
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                      %GOLD%S E Q U E N C E   :   I N S T A L L   R U N T I M E S%RESET%
echo          .NET 6  -^>  .NET 8  -^>  .NET 9  -^>  .NET 10  -^>  PowerShell 7  -^>  VC++  -^>  WebView2
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ############################################################
>> "%MAINT_LOG%" echo  SEQUENCE: Install Runtimes  -  %DATE% %TIME%
>> "%MAINT_LOG%" echo ############################################################
set "MAINT_NO_PAUSE=1"
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-6.bat"
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-8.bat"
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-9.bat"
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-10.bat"
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-PowerShell-7.bat"
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-VCRedist.bat"
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-WebView2.bat"
set "MAINT_NO_PAUSE="
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Runtime install sequence complete.%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof

:SeqInstallLanguages
cls
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                    %GOLD%S E Q U E N C E   :   I N S T A L L   L A N G U A G E S%RESET%
echo              Go  -^>  Node.js Current  -^>  Node.js LTS  -^>  OpenJDK 21  -^>  OpenJDK 25  -^>  Python  -^>  Rust
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ############################################################
>> "%MAINT_LOG%" echo  SEQUENCE: Install Languages  -  %DATE% %TIME%
>> "%MAINT_LOG%" echo ############################################################
set "MAINT_NO_PAUSE=1"
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-Go.bat"
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-NodeJS-Current.bat"
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-NodeJS-LTS.bat"
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-OpenJDK-21.bat"
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-OpenJDK-25.bat"
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-Python.bat"
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-Rust.bat"
set "MAINT_NO_PAUSE="
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Language install sequence complete.%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof

:SeqInstallProductivity
cls
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                 %GOLD%S E Q U E N C E   :   I N S T A L L   P R O D U C T I V I T Y%RESET%
echo                            Audacity  -^>  Blender  -^>  GIMP  -^>  LibreOffice  -^>  Notepad++
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ############################################################
>> "%MAINT_LOG%" echo  SEQUENCE: Install Productivity  -  %DATE% %TIME%
>> "%MAINT_LOG%" echo ############################################################
set "MAINT_NO_PAUSE=1"
call :RunOneNoTee "Winget\Apps\Productivity\Winget-Install-Audacity.bat"
call :RunOneNoTee "Winget\Apps\Productivity\Winget-Install-Blender.bat"
call :RunOneNoTee "Winget\Apps\Productivity\Winget-Install-GIMP.bat"
call :RunOneNoTee "Winget\Apps\Productivity\Winget-Install-LibreOffice.bat"
call :RunOneNoTee "Winget\Apps\Productivity\Winget-Install-NotepadPlusPlus.bat"
set "MAINT_NO_PAUSE="
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Productivity install sequence complete.%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof

:SeqInstallMedia
cls
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                       %GOLD%S E Q U E N C E   :   I N S T A L L   M E D I A%RESET%
echo     AIMP  -^>  HandBrake  -^>  Jellyfin Player  -^>  Jellyfin Server  -^>  OBS  -^>  Plex  -^>  Plex Server  -^>  VLC
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ############################################################
>> "%MAINT_LOG%" echo  SEQUENCE: Install Media  -  %DATE% %TIME%
>> "%MAINT_LOG%" echo ############################################################
set "MAINT_NO_PAUSE=1"
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-AIMP.bat"
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

:SeqInstallDevTools
cls
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                     %GOLD%S E Q U E N C E   :   I N S T A L L   D E V   T O O L S%RESET%
echo         CMake  -^>  Cursor  -^>  Git  -^>  GitHub Desktop  -^>  IntelliJ  -^>  VS Code  -^>  VS 2022  -^>  VS 2026
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ############################################################
>> "%MAINT_LOG%" echo  SEQUENCE: Install Dev Tools  -  %DATE% %TIME%
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
echo     %GOLD%Dev tools install sequence complete.%RESET%
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof

:SeqInstallUtility
cls
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                     %GOLD%S E Q U E N C E   :   I N S T A L L   U T I L I T Y%RESET%
echo     7-Zip  -^>  Etcher  -^>  BCUninstaller  -^>  Docker  -^>  PowerToys  -^>  Afterburner  -^>  qBittorrent  -^>  Revo  -^>  Rufus  -^>  Ventoy  -^>  WinRAR
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ############################################################
>> "%MAINT_LOG%" echo  SEQUENCE: Install Utility  -  %DATE% %TIME%
>> "%MAINT_LOG%" echo ############################################################
set "MAINT_NO_PAUSE=1"
call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-7Zip.bat"
call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-BalenaEtcher.bat"
call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-BulkCrapUninstaller.bat"
call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-DockerDesktop.bat"
call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-PowerToys.bat"
call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-MSIAfterburner.bat"
call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-qBittorrent.bat"
call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-RevoUninstaller.bat"
call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-Rufus.bat"
call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-Ventoy.bat"
call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-WinRAR.bat"
set "MAINT_NO_PAUSE="
echo.
echo   %GOLD%══════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Utility install sequence complete.%RESET%
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
echo            %DIM%(55 packages total. Allow time and a stable internet connection.)%RESET%
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
call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-Firefox.bat"
:: Communication
call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Discord.bat"
call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Telegram.bat"
:: Dev tools
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-CMake.bat"
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-Cursor.bat"
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-Git.bat"
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-GitHubDesktop.bat"
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-IntelliJ.bat"
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-VSCode.bat"
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-VSCommunity2022.bat"
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-VSCommunity2026.bat"
:: Drivers
call :RunOneNoTee "Winget\Apps\Drivers\Winget-Install-SnappyDriverInstaller.bat"
:: Game launchers
call :RunOneNoTee "Winget\Apps\GameLaunchers\Winget-Install-EpicGames.bat"
call :RunOneNoTee "Winget\Apps\GameLaunchers\Winget-Install-Itch.bat"
call :RunOneNoTee "Winget\Apps\GameLaunchers\Winget-Install-Steam.bat"
:: Languages
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-Go.bat"
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-NodeJS-Current.bat"
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-NodeJS-LTS.bat"
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-OpenJDK-21.bat"
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-OpenJDK-25.bat"
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-Python.bat"
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-Rust.bat"
:: Media
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-AIMP.bat"
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-HandBrake.bat"
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-JellyfinMediaPlayer.bat"
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-JellyfinServer.bat"
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-OBS.bat"
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-PlexDesktop.bat"
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-PlexMediaServer.bat"
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-VLC.bat"
:: Productivity
call :RunOneNoTee "Winget\Apps\Productivity\Winget-Install-Audacity.bat"
call :RunOneNoTee "Winget\Apps\Productivity\Winget-Install-Blender.bat"
call :RunOneNoTee "Winget\Apps\Productivity\Winget-Install-GIMP.bat"
call :RunOneNoTee "Winget\Apps\Productivity\Winget-Install-LibreOffice.bat"
call :RunOneNoTee "Winget\Apps\Productivity\Winget-Install-NotepadPlusPlus.bat"
:: Runtimes
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-6.bat"
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-8.bat"
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-9.bat"
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-10.bat"
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-PowerShell-7.bat"
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-VCRedist.bat"
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-WebView2.bat"
:: Utility
call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-7Zip.bat"
call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-BalenaEtcher.bat"
call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-BulkCrapUninstaller.bat"
call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-DockerDesktop.bat"
call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-PowerToys.bat"
call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-MSIAfterburner.bat"
call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-qBittorrent.bat"
call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-RevoUninstaller.bat"
call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-Rufus.bat"
call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-Ventoy.bat"
call :RunOneNoTee "Winget\Apps\Utility\Winget-Install-WinRAR.bat"
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
