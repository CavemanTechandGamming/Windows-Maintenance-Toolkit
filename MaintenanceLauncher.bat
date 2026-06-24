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
::  All menus use 140x65 (LOCK). Default width is set in :SetConsoleSize.
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
echo   %GOLD%╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗%RESET%
echo   %GOLD%║                                                                                                                                       ║%RESET%
echo   %GOLD%║                                                 W I N D O W S   M A I N T E N A N C E                                                 ║%RESET%
echo   %GOLD%║                                                                                                                                       ║%RESET%
echo   %GOLD%╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝%RESET%
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
echo   %GOLD%───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────%RESET%
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
powershell -NoProfile -Command "try { [Console]::SetCursorPosition(0,0) } catch {}" >nul 2>&1
echo.
echo   %GOLD%╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗%RESET%
echo   %GOLD%║                                                                                                                                       ║%RESET%
echo   %GOLD%║                                                      W I N G E T   M A N A G E R                                                      ║%RESET%
echo   %GOLD%║                                                                                                                                       ║%RESET%
echo   %GOLD%╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝%RESET%
echo     %GOLD%Session log:%RESET%  %DIM%%MAINT_LOG%%RESET%
echo     %DIM%WinGet output streams live and is NOT added to the session log.%RESET%
echo     %DIM%Use [L] below to open WinGet's own diagnostic log folder.%RESET%
echo.
echo   %GOLD%── WINGET ITSELF ──%RESET%
echo      %GOLD%[ 1]%RESET%  Install WinGet            Get the latest App Installer
echo      %GOLD%[ 2]%RESET%  Verify / update WinGet    Ensure latest version
echo      %GOLD%[ 3]%RESET%  Reinstall WinGet          Force fresh install (fix breakage)
echo.
echo   %GOLD%── WINGET QUERIES ──%RESET%
echo      %GOLD%[ 4]%RESET%  List upgradable apps      Show available updates (no install)
echo      %GOLD%[ 5]%RESET%  List installed apps       winget list
echo      %GOLD%[ 6]%RESET%  Search for a package      Interactive search
echo.
echo   %GOLD%── WINGET ACTIONS ──%RESET%
echo      %GOLD%[ 7]%RESET%  Upgrade ALL installed     winget upgrade --all
echo      %GOLD%[ P]%RESET%  Install preset bundle...  Preset 1-4 (edit in Notepad)
echo      %GOLD%[ I]%RESET%  Install Apps...           Browse all install scripts
echo.
echo   %GOLD%── UTILITY ──%RESET%
echo      %GOLD%[L]%RESET%   Open WinGet log folder    Native WinGet diagnostic logs
echo      %GOLD%[B]%RESET%   Back to main menu
echo      %GOLD%[Q]%RESET%   Quit launcher
echo   %GOLD%───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────%RESET%
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
powershell -NoProfile -Command "try { [Console]::SetCursorPosition(0,0) } catch {}" >nul 2>&1
echo.
echo   %GOLD%╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗%RESET%
echo   %GOLD%║                                                                                                                                       ║%RESET%
echo   %GOLD%║                                                      P R E S E T   B U N D L E S                                                      ║%RESET%
echo   %GOLD%║                                                                                                                                       ║%RESET%
echo   %GOLD%╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝%RESET%
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
echo   %GOLD%───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────%RESET%
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
echo   %GOLD%═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                  %GOLD%S E Q U E N C E   :   I N S T A L L   P R E S E T   %~1%RESET%
echo     %DIM%%_PF%%RESET%
echo   %GOLD%═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%RESET%
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
echo   %GOLD%═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Preset %~1 install sequence complete.%RESET%
echo   %GOLD%═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
:AppsMenu
:AppsLoop
call :SetConsoleSize 65 LOCK
cls
powershell -NoProfile -Command "try { [Console]::SetCursorPosition(0,0) } catch {}" >nul 2>&1
echo.
echo   %GOLD%╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗%RESET%
echo   %GOLD%║                                                                                                                                       ║%RESET%
echo   %GOLD%║                                             I N S T A L L   A P P S   V I A   W I N G E T                                             ║%RESET%
echo   %GOLD%║                                                                                                                                       ║%RESET%
echo   %GOLD%╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝%RESET%
echo     %GOLD%Session log:%RESET%  %DIM%%MAINT_LOG%%RESET%
echo     %DIM%WinGet output streams live and is NOT added to the session log.%RESET%
echo.
echo   %GOLD%── BROWSERS ──%RESET%
echo        %GOLD%[  1]%RESET%  Brave Browser             %GOLD%[  2]%RESET%  Google Chrome             %GOLD%[  3]%RESET%  LibreWolf                 %GOLD%[  4]%RESET%  Mozilla Firefox          
echo        %GOLD%[  5]%RESET%  Opera GX                                                                                                                    
echo   %GOLD%── COMMUNICATION ──%RESET%
echo        %GOLD%[  6]%RESET%  Discord                   %GOLD%[  7]%RESET%  Microsoft Teams           %GOLD%[  8]%RESET%  Mozilla Thunderbird       %GOLD%[  9]%RESET%  Signal                   
echo        %GOLD%[ 10]%RESET%  Slack                     %GOLD%[ 11]%RESET%  Telegram Desktop          %GOLD%[ 12]%RESET%  Zoom Workplace                                            
echo   %GOLD%── DEV TOOLS ──%RESET%
echo        %GOLD%[ 13]%RESET%  CMake                     %GOLD%[ 14]%RESET%  Cursor                    %GOLD%[ 15]%RESET%  Git                       %GOLD%[ 16]%RESET%  GitHub Desktop           
echo        %GOLD%[ 17]%RESET%  IntelliJ IDEA (Community) %GOLD%[ 18]%RESET%  Visual Studio Code        %GOLD%[ 19]%RESET%  VS Community 2022         %GOLD%[ 20]%RESET%  VS Community 2026        
echo   %GOLD%── GAMES ──%RESET%
echo        %GOLD%[ 21]%RESET%  Battle.net                %GOLD%[ 22]%RESET%  EA app                    %GOLD%[ 23]%RESET%  Epic Games Launcher       %GOLD%[ 24]%RESET%  GOG Galaxy               
echo        %GOLD%[ 25]%RESET%  itch.io                   %GOLD%[ 26]%RESET%  Moonlight                 %GOLD%[ 27]%RESET%  NVIDIA GeForce NOW        %GOLD%[ 28]%RESET%  Steam                    
echo        %GOLD%[ 29]%RESET%  Ubisoft Connect                                                                                                             
echo   %GOLD%── HARDWARE ^& DIAGNOSTICS ──%RESET%
echo        %GOLD%[ 30]%RESET%  CPU-Z                     %GOLD%[ 31]%RESET%  CrystalDiskInfo           %GOLD%[ 32]%RESET%  CrystalDiskMark           %GOLD%[ 33]%RESET%  Display Driver Uninstall.
echo        %GOLD%[ 34]%RESET%  FanControl                %GOLD%[ 35]%RESET%  GPU-Z                     %GOLD%[ 36]%RESET%  HWiNFO                    %GOLD%[ 37]%RESET%  HWMonitor                
echo        %GOLD%[ 38]%RESET%  MSI Afterburner           %GOLD%[ 39]%RESET%  OpenRGB                   %GOLD%[ 40]%RESET%  Snappy Driver Installer .                                 
echo   %GOLD%── LANGUAGES ──%RESET%
echo        %GOLD%[ 41]%RESET%  Go (Golang)               %GOLD%[ 42]%RESET%  Microsoft OpenJDK 21      %GOLD%[ 43]%RESET%  Microsoft OpenJDK 25      %GOLD%[ 44]%RESET%  Node.js (Current)        
echo        %GOLD%[ 45]%RESET%  Node.js (LTS)             %GOLD%[ 46]%RESET%  Python                    %GOLD%[ 47]%RESET%  Rust (MSVC)                                               
echo   %GOLD%── MEDIA ──%RESET%
echo        %GOLD%[ 48]%RESET%  AIMP                      %GOLD%[ 49]%RESET%  Blender                   %GOLD%[ 50]%RESET%  HandBrake                 %GOLD%[ 51]%RESET%  Jellyfin Media Player    
echo        %GOLD%[ 52]%RESET%  Jellyfin Server           %GOLD%[ 53]%RESET%  OBS Studio                %GOLD%[ 54]%RESET%  Plex Desktop              %GOLD%[ 55]%RESET%  Plex Media Server        
echo        %GOLD%[ 56]%RESET%  VLC media player                                                                                                            
echo   %GOLD%── NETWORK ^& REMOTE ──%RESET%
echo        %GOLD%[ 57]%RESET%  Nmap                      %GOLD%[ 58]%RESET%  PuTTY                     %GOLD%[ 59]%RESET%  Tailscale                 %GOLD%[ 60]%RESET%  WinSCP                   
echo        %GOLD%[ 61]%RESET%  WireGuard                 %GOLD%[ 62]%RESET%  Wireshark                                                                                  
echo   %GOLD%── OFFICE ^& DOCUMENTS ──%RESET%
echo        %GOLD%[ 63]%RESET%  Audacity                  %GOLD%[ 64]%RESET%  GIMP                      %GOLD%[ 65]%RESET%  Inkscape                  %GOLD%[ 66]%RESET%  Krita                    
echo        %GOLD%[ 67]%RESET%  LibreOffice               %GOLD%[ 68]%RESET%  Notepad++                 %GOLD%[ 69]%RESET%  Paint.NET                 %GOLD%[ 70]%RESET%  Sumatra PDF              
echo   %GOLD%── RUNTIMES ^& FRAMEWORKS ──%RESET%
echo        %GOLD%[ 71]%RESET%  .NET Desktop Runtime 10   %GOLD%[ 72]%RESET%  .NET Desktop Runtime 6    %GOLD%[ 73]%RESET%  .NET Desktop Runtime 8    %GOLD%[ 74]%RESET%  .NET Desktop Runtime 9   
echo        %GOLD%[ 75]%RESET%  PowerShell 7              %GOLD%[ 76]%RESET%  VC++ 2015-2022 Redist     %GOLD%[ 77]%RESET%  WebView2 Runtime                                          
echo   %GOLD%── SECURITY ^& PRIVACY ──%RESET%
echo        %GOLD%[ 78]%RESET%  Bitwarden                 %GOLD%[ 79]%RESET%  KeePass                   %GOLD%[ 80]%RESET%  Malwarebytes                                              
echo   %GOLD%── SYSTEM TOOLS ──%RESET%
echo        %GOLD%[ 81]%RESET%  7-Zip                     %GOLD%[ 82]%RESET%  Autoruns                  %GOLD%[ 83]%RESET%  Balena Etcher             %GOLD%[ 84]%RESET%  BCUninstaller            
echo        %GOLD%[ 85]%RESET%  PowerToys                 %GOLD%[ 86]%RESET%  Process Explorer          %GOLD%[ 87]%RESET%  qBittorrent               %GOLD%[ 88]%RESET%  Rainmeter                
echo        %GOLD%[ 89]%RESET%  Revo Uninstaller          %GOLD%[ 90]%RESET%  Rufus                     %GOLD%[ 91]%RESET%  ShareX                    %GOLD%[ 92]%RESET%  Ventoy                   
echo        %GOLD%[ 93]%RESET%  WinRAR                    %GOLD%[ 94]%RESET%  WizTree                                                                                    
echo   %GOLD%── VIRTUALIZATION ^& CONTAINERS ──%RESET%
echo        %GOLD%[ 95]%RESET%  Docker Desktop            %GOLD%[ 96]%RESET%  Helm                      %GOLD%[ 97]%RESET%  k9s                       %GOLD%[ 98]%RESET%  kubectl                  
echo        %GOLD%[ 99]%RESET%  Minikube                  %GOLD%[100]%RESET%  Terraform                 %GOLD%[101]%RESET%  Vagrant                   %GOLD%[102]%RESET%  VirtualBox               
echo   %GOLD%── NAVIGATION ──%RESET%  %GOLD%[A]%RESET% Install EVERYTHING   %GOLD%[B]%RESET% WinGet menu   %GOLD%[M]%RESET% Main menu   %GOLD%[Q]%RESET% Quit
echo   %GOLD%───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────%RESET%
echo.
set "choice="
set /p "choice=   %GOLD%Select option:%RESET%  "
if not defined choice goto AppsLoop

:: Navigation first.
if /i "%choice%"=="B" goto :eof
if /i "%choice%"=="M" set "_BACK_TO_MAIN=1" & goto :eof
if /i "%choice%"=="Q" set "_QUIT=1" & goto :eof
if /i "%choice%"=="A" call :SeqInstallAllApps & goto AppsLoop

if /i "%choice%"=="1" call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-Brave.bat" & goto AppsLoop
if /i "%choice%"=="2" call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-Chrome.bat" & goto AppsLoop
if /i "%choice%"=="3" call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-LibreWolf.bat" & goto AppsLoop
if /i "%choice%"=="4" call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-Firefox.bat" & goto AppsLoop
if /i "%choice%"=="5" call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-OperaGX.bat" & goto AppsLoop
if /i "%choice%"=="6" call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Discord.bat" & goto AppsLoop
if /i "%choice%"=="7" call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Teams.bat" & goto AppsLoop
if /i "%choice%"=="8" call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Thunderbird.bat" & goto AppsLoop
if /i "%choice%"=="9" call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Signal.bat" & goto AppsLoop
if /i "%choice%"=="10" call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Slack.bat" & goto AppsLoop
if /i "%choice%"=="11" call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Telegram.bat" & goto AppsLoop
if /i "%choice%"=="12" call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Zoom.bat" & goto AppsLoop
if /i "%choice%"=="13" call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-CMake.bat" & goto AppsLoop
if /i "%choice%"=="14" call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-Cursor.bat" & goto AppsLoop
if /i "%choice%"=="15" call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-Git.bat" & goto AppsLoop
if /i "%choice%"=="16" call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-GitHubDesktop.bat" & goto AppsLoop
if /i "%choice%"=="17" call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-IntelliJ.bat" & goto AppsLoop
if /i "%choice%"=="18" call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-VSCode.bat" & goto AppsLoop
if /i "%choice%"=="19" call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-VSCommunity2022.bat" & goto AppsLoop
if /i "%choice%"=="20" call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-VSCommunity2026.bat" & goto AppsLoop
if /i "%choice%"=="21" call :RunOneNoTee "Winget\Apps\Games\Winget-Install-BattleNet.bat" & goto AppsLoop
if /i "%choice%"=="22" call :RunOneNoTee "Winget\Apps\Games\Winget-Install-EADesktop.bat" & goto AppsLoop
if /i "%choice%"=="23" call :RunOneNoTee "Winget\Apps\Games\Winget-Install-EpicGames.bat" & goto AppsLoop
if /i "%choice%"=="24" call :RunOneNoTee "Winget\Apps\Games\Winget-Install-GOGGalaxy.bat" & goto AppsLoop
if /i "%choice%"=="25" call :RunOneNoTee "Winget\Apps\Games\Winget-Install-Itch.bat" & goto AppsLoop
if /i "%choice%"=="26" call :RunOneNoTee "Winget\Apps\Games\Winget-Install-Moonlight.bat" & goto AppsLoop
if /i "%choice%"=="27" call :RunOneNoTee "Winget\Apps\Games\Winget-Install-GeForceNow.bat" & goto AppsLoop
if /i "%choice%"=="28" call :RunOneNoTee "Winget\Apps\Games\Winget-Install-Steam.bat" & goto AppsLoop
if /i "%choice%"=="29" call :RunOneNoTee "Winget\Apps\Games\Winget-Install-UbisoftConnect.bat" & goto AppsLoop
if /i "%choice%"=="30" call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-CPU-Z.bat" & goto AppsLoop
if /i "%choice%"=="31" call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-CrystalDiskInfo.bat" & goto AppsLoop
if /i "%choice%"=="32" call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-CrystalDiskMark.bat" & goto AppsLoop
if /i "%choice%"=="33" call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-DisplayDriverUninstaller.bat" & goto AppsLoop
if /i "%choice%"=="34" call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-FanControl.bat" & goto AppsLoop
if /i "%choice%"=="35" call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-GPU-Z.bat" & goto AppsLoop
if /i "%choice%"=="36" call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-HWiNFO.bat" & goto AppsLoop
if /i "%choice%"=="37" call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-HWMonitor.bat" & goto AppsLoop
if /i "%choice%"=="38" call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-MSIAfterburner.bat" & goto AppsLoop
if /i "%choice%"=="39" call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-OpenRGB.bat" & goto AppsLoop
if /i "%choice%"=="40" call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-SnappyDriverInstaller.bat" & goto AppsLoop
if /i "%choice%"=="41" call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-Go.bat" & goto AppsLoop
if /i "%choice%"=="42" call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-OpenJDK-21.bat" & goto AppsLoop
if /i "%choice%"=="43" call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-OpenJDK-25.bat" & goto AppsLoop
if /i "%choice%"=="44" call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-NodeJS-Current.bat" & goto AppsLoop
if /i "%choice%"=="45" call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-NodeJS-LTS.bat" & goto AppsLoop
if /i "%choice%"=="46" call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-Python.bat" & goto AppsLoop
if /i "%choice%"=="47" call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-Rust.bat" & goto AppsLoop
if /i "%choice%"=="48" call :RunOneNoTee "Winget\Apps\Media\Winget-Install-AIMP.bat" & goto AppsLoop
if /i "%choice%"=="49" call :RunOneNoTee "Winget\Apps\Media\Winget-Install-Blender.bat" & goto AppsLoop
if /i "%choice%"=="50" call :RunOneNoTee "Winget\Apps\Media\Winget-Install-HandBrake.bat" & goto AppsLoop
if /i "%choice%"=="51" call :RunOneNoTee "Winget\Apps\Media\Winget-Install-JellyfinMediaPlayer.bat" & goto AppsLoop
if /i "%choice%"=="52" call :RunOneNoTee "Winget\Apps\Media\Winget-Install-JellyfinServer.bat" & goto AppsLoop
if /i "%choice%"=="53" call :RunOneNoTee "Winget\Apps\Media\Winget-Install-OBS.bat" & goto AppsLoop
if /i "%choice%"=="54" call :RunOneNoTee "Winget\Apps\Media\Winget-Install-PlexDesktop.bat" & goto AppsLoop
if /i "%choice%"=="55" call :RunOneNoTee "Winget\Apps\Media\Winget-Install-PlexMediaServer.bat" & goto AppsLoop
if /i "%choice%"=="56" call :RunOneNoTee "Winget\Apps\Media\Winget-Install-VLC.bat" & goto AppsLoop
if /i "%choice%"=="57" call :RunOneNoTee "Winget\Apps\NetworkRemote\Winget-Install-Nmap.bat" & goto AppsLoop
if /i "%choice%"=="58" call :RunOneNoTee "Winget\Apps\NetworkRemote\Winget-Install-PuTTY.bat" & goto AppsLoop
if /i "%choice%"=="59" call :RunOneNoTee "Winget\Apps\NetworkRemote\Winget-Install-Tailscale.bat" & goto AppsLoop
if /i "%choice%"=="60" call :RunOneNoTee "Winget\Apps\NetworkRemote\Winget-Install-WinSCP.bat" & goto AppsLoop
if /i "%choice%"=="61" call :RunOneNoTee "Winget\Apps\NetworkRemote\Winget-Install-WireGuard.bat" & goto AppsLoop
if /i "%choice%"=="62" call :RunOneNoTee "Winget\Apps\NetworkRemote\Winget-Install-Wireshark.bat" & goto AppsLoop
if /i "%choice%"=="63" call :RunOneNoTee "Winget\Apps\Office\Winget-Install-Audacity.bat" & goto AppsLoop
if /i "%choice%"=="64" call :RunOneNoTee "Winget\Apps\Office\Winget-Install-GIMP.bat" & goto AppsLoop
if /i "%choice%"=="65" call :RunOneNoTee "Winget\Apps\Office\Winget-Install-Inkscape.bat" & goto AppsLoop
if /i "%choice%"=="66" call :RunOneNoTee "Winget\Apps\Office\Winget-Install-Krita.bat" & goto AppsLoop
if /i "%choice%"=="67" call :RunOneNoTee "Winget\Apps\Office\Winget-Install-LibreOffice.bat" & goto AppsLoop
if /i "%choice%"=="68" call :RunOneNoTee "Winget\Apps\Office\Winget-Install-NotepadPlusPlus.bat" & goto AppsLoop
if /i "%choice%"=="69" call :RunOneNoTee "Winget\Apps\Office\Winget-Install-PaintDotNet.bat" & goto AppsLoop
if /i "%choice%"=="70" call :RunOneNoTee "Winget\Apps\Office\Winget-Install-SumatraPDF.bat" & goto AppsLoop
if /i "%choice%"=="71" call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-10.bat" & goto AppsLoop
if /i "%choice%"=="72" call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-6.bat" & goto AppsLoop
if /i "%choice%"=="73" call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-8.bat" & goto AppsLoop
if /i "%choice%"=="74" call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-9.bat" & goto AppsLoop
if /i "%choice%"=="75" call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-PowerShell-7.bat" & goto AppsLoop
if /i "%choice%"=="76" call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-VCRedist.bat" & goto AppsLoop
if /i "%choice%"=="77" call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-WebView2.bat" & goto AppsLoop
if /i "%choice%"=="78" call :RunOneNoTee "Winget\Apps\Security\Winget-Install-Bitwarden.bat" & goto AppsLoop
if /i "%choice%"=="79" call :RunOneNoTee "Winget\Apps\Security\Winget-Install-KeePass.bat" & goto AppsLoop
if /i "%choice%"=="80" call :RunOneNoTee "Winget\Apps\Security\Winget-Install-Malwarebytes.bat" & goto AppsLoop
if /i "%choice%"=="81" call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-7Zip.bat" & goto AppsLoop
if /i "%choice%"=="82" call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-Autoruns.bat" & goto AppsLoop
if /i "%choice%"=="83" call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-BalenaEtcher.bat" & goto AppsLoop
if /i "%choice%"=="84" call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-BulkCrapUninstaller.bat" & goto AppsLoop
if /i "%choice%"=="85" call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-PowerToys.bat" & goto AppsLoop
if /i "%choice%"=="86" call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-ProcessExplorer.bat" & goto AppsLoop
if /i "%choice%"=="87" call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-qBittorrent.bat" & goto AppsLoop
if /i "%choice%"=="88" call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-Rainmeter.bat" & goto AppsLoop
if /i "%choice%"=="89" call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-RevoUninstaller.bat" & goto AppsLoop
if /i "%choice%"=="90" call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-Rufus.bat" & goto AppsLoop
if /i "%choice%"=="91" call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-ShareX.bat" & goto AppsLoop
if /i "%choice%"=="92" call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-Ventoy.bat" & goto AppsLoop
if /i "%choice%"=="93" call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-WinRAR.bat" & goto AppsLoop
if /i "%choice%"=="94" call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-WizTree.bat" & goto AppsLoop
if /i "%choice%"=="95" call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-DockerDesktop.bat" & goto AppsLoop
if /i "%choice%"=="96" call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-Helm.bat" & goto AppsLoop
if /i "%choice%"=="97" call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-k9s.bat" & goto AppsLoop
if /i "%choice%"=="98" call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-kubectl.bat" & goto AppsLoop
if /i "%choice%"=="99" call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-Minikube.bat" & goto AppsLoop
if /i "%choice%"=="100" call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-Terraform.bat" & goto AppsLoop
if /i "%choice%"=="101" call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-Vagrant.bat" & goto AppsLoop
if /i "%choice%"=="102" call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-VirtualBox.bat" & goto AppsLoop

echo.
echo   Invalid choice: "%choice%"
echo.
pause
goto AppsLoop
::  CONSOLE SIZE
:: ============================================================

:SetConsoleSize
:: %1 = visible window height in lines
:: %2 = LOCK to match buffer height to window, or a column width (e.g. 140)
:: %3 = column width when %2 is LOCK (default 140)
set "_CS_H=%~1"
set "_CS_W=140"
if /i "%~2"=="LOCK" (
    if not "%~3"=="" set "_CS_W=%~3"
) else if not "%~2"=="" set "_CS_W=%~2"
mode con cols=%_CS_W% lines=%_CS_H% >nul 2>&1
if /i "%~2"=="LOCK" (
    powershell -NoProfile -Command "try { $h=%_CS_H%; $w=%_CS_W%; [Console]::SetBufferSize($w,$h); [Console]::WindowHeight=$h; [Console]::WindowWidth=$w } catch {}" >nul 2>&1
) else (
    powershell -NoProfile -Command "try { $w=%_CS_W%; [Console]::SetBufferSize($w, 3000) } catch {}" >nul 2>&1
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
echo   %GOLD%═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                       %GOLD%S E Q U E N C E   :   F U L L   R E P A I R%RESET%
echo                  CheckHealth  -^>  ScanHealth  -^>  RestoreHealth  -^>  SFC
echo   %GOLD%═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%RESET%
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
echo   %GOLD%═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Repair sequence complete.%RESET%
echo     %DIM%Log: %MAINT_LOG%%RESET%
echo   %GOLD%═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof

:SeqCleanup
cls
echo.
echo   %GOLD%═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                       %GOLD%S E Q U E N C E   :   F U L L   C L E A N U P%RESET%
echo                Temp  -^>  WU cache  -^>  Recycle Bin  -^>  Component store
echo   %GOLD%═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%RESET%
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
echo   %GOLD%═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Cleanup sequence complete.%RESET%
echo     %DIM%Log: %MAINT_LOG%%RESET%
echo   %GOLD%═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof

:SeqNetwork
cls
echo.
echo   %GOLD%═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                    %GOLD%S E Q U E N C E   :   N E T W O R K   R E F R E S H%RESET%
echo            Flush DNS  -^>  Renew IP  -^>  Register DNS  -^>  Clear ARP
echo            %DIM%(Winsock and TCP/IP resets are excluded -- they need a reboot.)%RESET%
echo   %GOLD%═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%RESET%
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
echo   %GOLD%═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Network sequence complete.%RESET%
echo     %DIM%Log: %MAINT_LOG%%RESET%
echo   %GOLD%═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof
:SeqInstallAllApps
call :SetConsoleSize 65 LOCK
cls
echo.
echo   %GOLD%═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%RESET%
echo                  %GOLD%S E Q U E N C E   :   I N S T A L L   E V E R Y T H I N G%RESET%
echo            Categories A-Z, each item A-Z within category
echo            %DIM%(102 packages total. Allow time and a stable internet connection.)%RESET%
echo   %GOLD%═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
>> "%MAINT_LOG%" echo.
>> "%MAINT_LOG%" echo ############################################################
>> "%MAINT_LOG%" echo  SEQUENCE: Install ALL Apps  -  %DATE% %TIME%
>> "%MAINT_LOG%" echo ############################################################
set "MAINT_NO_PAUSE=1"
:: Browsers
call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-Brave.bat"
:: Browsers
call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-Chrome.bat"
:: Browsers
call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-LibreWolf.bat"
:: Browsers
call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-Firefox.bat"
:: Browsers
call :RunOneNoTee "Winget\Apps\Browsers\Winget-Install-OperaGX.bat"
:: Communication
call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Discord.bat"
:: Communication
call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Teams.bat"
:: Communication
call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Thunderbird.bat"
:: Communication
call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Signal.bat"
:: Communication
call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Slack.bat"
:: Communication
call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Telegram.bat"
:: Communication
call :RunOneNoTee "Winget\Apps\Communication\Winget-Install-Zoom.bat"
:: Developer
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-CMake.bat"
:: Developer
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-Cursor.bat"
:: Developer
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-Git.bat"
:: Developer
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-GitHubDesktop.bat"
:: Developer
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-IntelliJ.bat"
:: Developer
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-VSCode.bat"
:: Developer
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-VSCommunity2022.bat"
:: Developer
call :RunOneNoTee "Winget\Apps\DevTools\Winget-Install-VSCommunity2026.bat"
:: Games
call :RunOneNoTee "Winget\Apps\Games\Winget-Install-BattleNet.bat"
:: Games
call :RunOneNoTee "Winget\Apps\Games\Winget-Install-EADesktop.bat"
:: Games
call :RunOneNoTee "Winget\Apps\Games\Winget-Install-EpicGames.bat"
:: Games
call :RunOneNoTee "Winget\Apps\Games\Winget-Install-GOGGalaxy.bat"
:: Games
call :RunOneNoTee "Winget\Apps\Games\Winget-Install-Itch.bat"
:: Games
call :RunOneNoTee "Winget\Apps\Games\Winget-Install-Moonlight.bat"
:: Games
call :RunOneNoTee "Winget\Apps\Games\Winget-Install-GeForceNow.bat"
:: Games
call :RunOneNoTee "Winget\Apps\Games\Winget-Install-Steam.bat"
:: Games
call :RunOneNoTee "Winget\Apps\Games\Winget-Install-UbisoftConnect.bat"
:: Hardware
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-CPU-Z.bat"
:: Hardware
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-CrystalDiskInfo.bat"
:: Hardware
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-CrystalDiskMark.bat"
:: Hardware
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-DisplayDriverUninstaller.bat"
:: Hardware
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-FanControl.bat"
:: Hardware
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-GPU-Z.bat"
:: Hardware
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-HWiNFO.bat"
:: Hardware
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-HWMonitor.bat"
:: Hardware
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-MSIAfterburner.bat"
:: Hardware
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-OpenRGB.bat"
:: Hardware
call :RunOneNoTee "Winget\Apps\Hardware\Winget-Install-SnappyDriverInstaller.bat"
:: Languages
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-Go.bat"
:: Languages
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-OpenJDK-21.bat"
:: Languages
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-OpenJDK-25.bat"
:: Languages
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-NodeJS-Current.bat"
:: Languages
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-NodeJS-LTS.bat"
:: Languages
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-Python.bat"
:: Languages
call :RunOneNoTee "Winget\Apps\Languages\Winget-Install-Rust.bat"
:: Media
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-AIMP.bat"
:: Media
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-Blender.bat"
:: Media
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-HandBrake.bat"
:: Media
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-JellyfinMediaPlayer.bat"
:: Media
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-JellyfinServer.bat"
:: Media
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-OBS.bat"
:: Media
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-PlexDesktop.bat"
:: Media
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-PlexMediaServer.bat"
:: Media
call :RunOneNoTee "Winget\Apps\Media\Winget-Install-VLC.bat"
:: NetworkRemote
call :RunOneNoTee "Winget\Apps\NetworkRemote\Winget-Install-Nmap.bat"
:: NetworkRemote
call :RunOneNoTee "Winget\Apps\NetworkRemote\Winget-Install-PuTTY.bat"
:: NetworkRemote
call :RunOneNoTee "Winget\Apps\NetworkRemote\Winget-Install-Tailscale.bat"
:: NetworkRemote
call :RunOneNoTee "Winget\Apps\NetworkRemote\Winget-Install-WinSCP.bat"
:: NetworkRemote
call :RunOneNoTee "Winget\Apps\NetworkRemote\Winget-Install-WireGuard.bat"
:: NetworkRemote
call :RunOneNoTee "Winget\Apps\NetworkRemote\Winget-Install-Wireshark.bat"
:: Office
call :RunOneNoTee "Winget\Apps\Office\Winget-Install-Audacity.bat"
:: Office
call :RunOneNoTee "Winget\Apps\Office\Winget-Install-GIMP.bat"
:: Office
call :RunOneNoTee "Winget\Apps\Office\Winget-Install-Inkscape.bat"
:: Office
call :RunOneNoTee "Winget\Apps\Office\Winget-Install-Krita.bat"
:: Office
call :RunOneNoTee "Winget\Apps\Office\Winget-Install-LibreOffice.bat"
:: Office
call :RunOneNoTee "Winget\Apps\Office\Winget-Install-NotepadPlusPlus.bat"
:: Office
call :RunOneNoTee "Winget\Apps\Office\Winget-Install-PaintDotNet.bat"
:: Office
call :RunOneNoTee "Winget\Apps\Office\Winget-Install-SumatraPDF.bat"
:: Runtimes
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-10.bat"
:: Runtimes
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-6.bat"
:: Runtimes
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-8.bat"
:: Runtimes
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-DotNet-Runtime-9.bat"
:: Runtimes
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-PowerShell-7.bat"
:: Runtimes
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-VCRedist.bat"
:: Runtimes
call :RunOneNoTee "Winget\Apps\Runtimes\Winget-Install-WebView2.bat"
:: Security
call :RunOneNoTee "Winget\Apps\Security\Winget-Install-Bitwarden.bat"
:: Security
call :RunOneNoTee "Winget\Apps\Security\Winget-Install-KeePass.bat"
:: Security
call :RunOneNoTee "Winget\Apps\Security\Winget-Install-Malwarebytes.bat"
:: SystemTools
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-7Zip.bat"
:: SystemTools
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-Autoruns.bat"
:: SystemTools
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-BalenaEtcher.bat"
:: SystemTools
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-BulkCrapUninstaller.bat"
:: SystemTools
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-PowerToys.bat"
:: SystemTools
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-ProcessExplorer.bat"
:: SystemTools
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-qBittorrent.bat"
:: SystemTools
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-Rainmeter.bat"
:: SystemTools
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-RevoUninstaller.bat"
:: SystemTools
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-Rufus.bat"
:: SystemTools
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-ShareX.bat"
:: SystemTools
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-Ventoy.bat"
:: SystemTools
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-WinRAR.bat"
:: SystemTools
call :RunOneNoTee "Winget\Apps\SystemTools\Winget-Install-WizTree.bat"
:: Virtualization
call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-DockerDesktop.bat"
:: Virtualization
call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-Helm.bat"
:: Virtualization
call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-k9s.bat"
:: Virtualization
call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-kubectl.bat"
:: Virtualization
call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-Minikube.bat"
:: Virtualization
call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-Terraform.bat"
:: Virtualization
call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-Vagrant.bat"
:: Virtualization
call :RunOneNoTee "Winget\Apps\Virtualization\Winget-Install-VirtualBox.bat"
set "MAINT_NO_PAUSE="
echo.
echo   %GOLD%═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Full app install sequence complete.%RESET%
echo     %DIM%Log: %MAINT_LOG%%RESET%
echo   %GOLD%═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof

:SeqFull
call :SeqRepair
call :SeqCleanup
call :SeqNetwork
echo.
echo   %GOLD%═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Full maintenance complete.%RESET%
echo     If SFC reported files it could not fix while Windows was running,
echo     reboot and re-run the %GOLD%[R]%RESET% repair sequence.
echo     %DIM%Log: %MAINT_LOG%%RESET%
echo   %GOLD%═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
goto :eof

:ViewLog
cls
echo.
echo   %GOLD%═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Current session log%RESET%
echo     %DIM%%MAINT_LOG%%RESET%
echo   %GOLD%═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%RESET%
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
echo   %GOLD%═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%RESET%
echo     %GOLD%Maintenance session complete.%RESET%
echo.
echo     Log saved to:
echo       %DIM%%MAINT_LOG%%RESET%
echo   %GOLD%═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%RESET%
echo.
pause
:: Restore original codepage and default colors.
if defined _ORIGCP chcp %_ORIGCP% >nul
color
endlocal
exit 0
