
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

