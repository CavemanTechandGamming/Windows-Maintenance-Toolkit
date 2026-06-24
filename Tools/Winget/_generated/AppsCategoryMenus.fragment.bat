
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