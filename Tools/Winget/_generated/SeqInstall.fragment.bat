
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

