# Rebuild WinGet Apps folder layout + generate MaintenanceLauncher fragments
# Run from repo root: powershell -ExecutionPolicy Bypass -File Tools\Winget\_Rebuild-AppsCatalog.ps1

$ErrorActionPreference = 'Stop'
$Root = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$AppsRoot = Join-Path $Root 'Tools\Winget\Apps'
$OutDir = Join-Path $Root 'Tools\Winget\_generated'
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

# CategoryKey, MenuLabel, Subtitle, FolderName
$Categories = @(
    @{ Key='Browsers';      Label='BROWSERS';                    Sub='Web browsers';                          Folder='Browsers';      AllLabel='browsers' }
    @{ Key='Communication'; Label='COMMUNICATION';                 Sub='Chat, email, and video calls';          Folder='Communication'; AllLabel='communication' }
    @{ Key='Developer';     Label='DEVELOPER';                     Sub='Code editors, IDEs, and build tools';   Folder='DevTools';      AllLabel='developer tools' }
    @{ Key='Games';         Label='GAMES';                         Sub='Game stores and platforms';             Folder='Games';         AllLabel='games' }
    @{ Key='Hardware';      Label='HARDWARE ^& DIAGNOSTICS';       Sub='Drivers, temps, disk health, GPU tools'; Folder='Hardware';      AllLabel='hardware' }
    @{ Key='Languages';     Label='LANGUAGES';                     Sub='Python, Node, Java, Go, Rust';          Folder='Languages';     AllLabel='languages' }
    @{ Key='Media';         Label='MEDIA';                         Sub='Watch, listen, record, and stream';     Folder='Media';         AllLabel='media' }
    @{ Key='NetworkRemote'; Label='NETWORK ^& REMOTE';             Sub='VPN, SSH, and network troubleshooting'; Folder='NetworkRemote'; AllLabel='network & remote' }
    @{ Key='Office';        Label='OFFICE ^& DOCUMENTS';           Sub='Office suite, PDFs, notes, design';     Folder='Office';        AllLabel='office' }
    @{ Key='Runtimes';      Label='RUNTIMES ^& FRAMEWORKS';        Sub='Required by many apps - install first'; Folder='Runtimes';      AllLabel='runtimes' }
    @{ Key='Security';      Label='SECURITY ^& PRIVACY';           Sub='Antimalware and passwords';             Folder='Security';      AllLabel='security' }
    @{ Key='SystemTools';   Label='SYSTEM TOOLS';                  Sub='Zip, uninstall, search, USB boot media'; Folder='SystemTools';   AllLabel='system tools' }
    @{ Key='Virtualization';Label='VIRTUALIZATION ^& CONTAINERS';   Sub='VMs, Docker, and Kubernetes';           Folder='Virtualization'; AllLabel='virtualization' }
)

# Apps: Folder, FileBase (no path), DisplayName, PackageId — order = menu A-Z within category
$Apps = @(
    # Browsers
    @{ F='Browsers'; B='Brave';       N='Brave Browser';        P='Brave.Brave' }
    @{ F='Browsers'; B='Chrome';       N='Google Chrome';        P='Google.Chrome' }
    @{ F='Browsers'; B='Firefox';      N='Mozilla Firefox';      P='Mozilla.Firefox' }
    @{ F='Browsers'; B='LibreWolf';    N='LibreWolf';            P='LibreWolf.LibreWolf' }
    @{ F='Browsers'; B='OperaGX';      N='Opera GX';             P='Opera.OperaGX' }
    # Communication
    @{ F='Communication'; B='Discord';     N='Discord';              P='Discord.Discord' }
    @{ F='Communication'; B='Signal';      N='Signal';               P='OpenWhisperSystems.Signal' }
    @{ F='Communication'; B='Slack';       N='Slack';                P='SlackTechnologies.Slack' }
    @{ F='Communication'; B='Teams';       N='Microsoft Teams';      P='Microsoft.Teams' }
    @{ F='Communication'; B='Telegram';    N='Telegram Desktop';     P='Telegram.TelegramDesktop' }
    @{ F='Communication'; B='Thunderbird'; N='Mozilla Thunderbird';  P='Mozilla.Thunderbird' }
    @{ F='Communication'; B='Zoom';        N='Zoom Workplace';       P='Zoom.Zoom' }
    # Developer
    @{ F='DevTools'; B='CMake';              N='CMake';                    P='Kitware.CMake' }
    @{ F='DevTools'; B='Cursor';              N='Cursor';                   P='Anysphere.Cursor' }
    @{ F='DevTools'; B='Git';                 N='Git';                      P='Git.Git' }
    @{ F='DevTools'; B='GitHubDesktop';       N='GitHub Desktop';           P='GitHub.GitHubDesktop' }
    @{ F='DevTools'; B='IntelliJ';            N='IntelliJ IDEA (Community)'; P='JetBrains.IntelliJIDEA.Community' }
    @{ F='DevTools'; B='VSCode';               N='Visual Studio Code';       P='Microsoft.VisualStudioCode' }
    @{ F='DevTools'; B='VSCommunity2022';      N='VS Community 2022';        P='Microsoft.VisualStudio.2022.Community' }
    @{ F='DevTools'; B='VSCommunity2026';      N='VS Community 2026';        P='Microsoft.VisualStudio.Community' }
    # Games
    @{ F='Games'; B='BattleNet';    N='Battle.net';           P='Blizzard.BattleNet' }
    @{ F='Games'; B='EADesktop';     N='EA app';               P='ElectronicArts.EADesktop' }
    @{ F='Games'; B='EpicGames';     N='Epic Games Launcher';  P='EpicGames.EpicGamesLauncher' }
    @{ F='Games'; B='GeForceNow';    N='NVIDIA GeForce NOW';   P='Nvidia.GeForceNow' }
    @{ F='Games'; B='GOGGalaxy';      N='GOG Galaxy';           P='GOG.Galaxy' }
    @{ F='Games'; B='Itch';          N='itch.io';              P='ItchIo.Itch' }
    @{ F='Games'; B='Moonlight';      N='Moonlight';            P='MoonlightGameStreamingProject.Moonlight' }
    @{ F='Games'; B='Steam';         N='Steam';                P='Valve.Steam' }
    @{ F='Games'; B='UbisoftConnect'; N='Ubisoft Connect';     P='Ubisoft.Connect' }
    # Hardware
    @{ F='Hardware'; B='CPU-Z';              N='CPU-Z';                         P='CPUID.CPU-Z' }
    @{ F='Hardware'; B='CrystalDiskInfo';    N='CrystalDiskInfo';               P='CrystalDewWorld.CrystalDiskInfo' }
    @{ F='Hardware'; B='CrystalDiskMark';    N='CrystalDiskMark';               P='CrystalDewWorld.CrystalDiskMark' }
    @{ F='Hardware'; B='DisplayDriverUninstaller'; N='Display Driver Uninstaller'; P='Wagnardsoft.DisplayDriverUninstaller' }
    @{ F='Hardware'; B='FanControl';          N='FanControl';                    P='Rem0o.FanControl' }
    @{ F='Hardware'; B='GPU-Z';               N='GPU-Z';                         P='TechPowerUp.GPU-Z' }
    @{ F='Hardware'; B='HWiNFO';               N='HWiNFO';                        P='REALiX.HWiNFO' }
    @{ F='Hardware'; B='HWMonitor';            N='HWMonitor';                     P='CPUID.HWMonitor' }
    @{ F='Hardware'; B='MSIAfterburner';       N='MSI Afterburner';               P='Guru3D.Afterburner' }
    @{ F='Hardware'; B='OpenRGB';              N='OpenRGB';                       P='OpenRGB.OpenRGB' }
    @{ F='Hardware'; B='SnappyDriverInstaller'; N='Snappy Driver Installer Origin'; P='GlennDelahoy.SnappyDriverInstallerOrigin' }
    # Languages
    @{ F='Languages'; B='Go';            N='Go (Golang)';       P='GoLang.Go' }
    @{ F='Languages'; B='NodeJS-Current'; N='Node.js (Current)'; P='OpenJS.NodeJS' }
    @{ F='Languages'; B='NodeJS-LTS';     N='Node.js (LTS)';     P='OpenJS.NodeJS.LTS' }
    @{ F='Languages'; B='OpenJDK-21';     N='Microsoft OpenJDK 21'; P='Microsoft.OpenJDK.21' }
    @{ F='Languages'; B='OpenJDK-25';     N='Microsoft OpenJDK 25'; P='Microsoft.OpenJDK.25' }
    @{ F='Languages'; B='Python';         N='Python';            P='Python.Python.3.14' }
    @{ F='Languages'; B='Rust';           N='Rust (MSVC)';       P='Rustlang.Rust.MSVC' }
    # Media
    @{ F='Media'; B='AIMP';                  N='AIMP';                  P='AIMP.AIMP' }
    @{ F='Media'; B='Blender';               N='Blender';               P='BlenderFoundation.Blender' }
    @{ F='Media'; B='HandBrake';             N='HandBrake';             P='HandBrake.HandBrake' }
    @{ F='Media'; B='JellyfinMediaPlayer';   N='Jellyfin Media Player'; P='Jellyfin.JellyfinMediaPlayer' }
    @{ F='Media'; B='JellyfinServer';        N='Jellyfin Server';       P='Jellyfin.Server' }
    @{ F='Media'; B='OBS';                   N='OBS Studio';            P='OBSProject.OBSStudio' }
    @{ F='Media'; B='PlexDesktop';            N='Plex Desktop';          P='Plex.Plex' }
    @{ F='Media'; B='PlexMediaServer';        N='Plex Media Server';     P='Plex.PlexMediaServer' }
    @{ F='Media'; B='VLC';                    N='VLC media player';      P='VideoLAN.VLC' }
    # NetworkRemote
    @{ F='NetworkRemote'; B='Nmap';       N='Nmap';       P='Insecure.Nmap' }
    @{ F='NetworkRemote'; B='PuTTY';      N='PuTTY';      P='PuTTY.PuTTY' }
    @{ F='NetworkRemote'; B='Tailscale';  N='Tailscale';  P='Tailscale.Tailscale' }
    @{ F='NetworkRemote'; B='WireGuard';  N='WireGuard';  P='WireGuard.WireGuard' }
    @{ F='NetworkRemote'; B='WinSCP';     N='WinSCP';     P='WinSCP.WinSCP' }
    @{ F='NetworkRemote'; B='Wireshark';  N='Wireshark';  P='WiresharkFoundation.Wireshark' }
    # Office
    @{ F='Office'; B='Audacity';         N='Audacity';    P='Audacity.Audacity' }
    @{ F='Office'; B='GIMP';             N='GIMP';        P='GIMP.GIMP' }
    @{ F='Office'; B='Inkscape';         N='Inkscape';    P='Inkscape.Inkscape' }
    @{ F='Office'; B='Krita';            N='Krita';       P='KDE.Krita' }
    @{ F='Office'; B='LibreOffice';      N='LibreOffice'; P='TheDocumentFoundation.LibreOffice' }
    @{ F='Office'; B='NotepadPlusPlus';  N='Notepad++';   P='Notepad++.Notepad++' }
    @{ F='Office'; B='PaintDotNet';       N='Paint.NET';   P='dotPDN.PaintDotNet' }
    @{ F='Office'; B='SumatraPDF';        N='Sumatra PDF'; P='SumatraPDF.SumatraPDF' }
    # Runtimes
    @{ F='Runtimes'; B='DotNet-Runtime-6';  N='.NET Desktop Runtime 6';  P='Microsoft.DotNet.DesktopRuntime.6' }
    @{ F='Runtimes'; B='DotNet-Runtime-8';  N='.NET Desktop Runtime 8';  P='Microsoft.DotNet.DesktopRuntime.8' }
    @{ F='Runtimes'; B='DotNet-Runtime-9';  N='.NET Desktop Runtime 9';  P='Microsoft.DotNet.DesktopRuntime.9' }
    @{ F='Runtimes'; B='DotNet-Runtime-10'; N='.NET Desktop Runtime 10'; P='Microsoft.DotNet.DesktopRuntime.10' }
    @{ F='Runtimes'; B='PowerShell-7';      N='PowerShell 7';            P='Microsoft.PowerShell' }
    @{ F='Runtimes'; B='VCRedist';          N='VC++ 2015-2022 Redist';   P='Microsoft.VCRedist.2015+.x64' }
    @{ F='Runtimes'; B='WebView2';          N='WebView2 Runtime';        P='Microsoft.EdgeWebView2Runtime' }
    # Security
    @{ F='Security'; B='Bitwarden';     N='Bitwarden';   P='Bitwarden.Bitwarden' }
    @{ F='Security'; B='KeePass';       N='KeePass';     P='DominikReichl.KeePass' }
    @{ F='Security'; B='Malwarebytes';  N='Malwarebytes'; P='Malwarebytes.Malwarebytes' }
    # SystemTools
    @{ F='SystemTools'; B='7Zip';                  N='7-Zip';                  P='7zip.7zip' }
    @{ F='SystemTools'; B='Autoruns';              N='Autoruns';               P='Microsoft.Sysinternals.Autoruns' }
    @{ F='SystemTools'; B='BalenaEtcher';          N='Balena Etcher';          P='Balena.Etcher' }
    @{ F='SystemTools'; B='BulkCrapUninstaller';   N='BCUninstaller';          P='Klocman.BulkCrapUninstaller' }
    @{ F='SystemTools'; B='PowerToys';             N='PowerToys';              P='Microsoft.PowerToys' }
    @{ F='SystemTools'; B='ProcessExplorer';       N='Process Explorer';       P='Microsoft.Sysinternals.ProcessExplorer' }
    @{ F='SystemTools'; B='qBittorrent';           N='qBittorrent';            P='qBittorrent.qBittorrent' }
    @{ F='SystemTools'; B='Rainmeter';             N='Rainmeter';              P='Rainmeter.Rainmeter' }
    @{ F='SystemTools'; B='RevoUninstaller';       N='Revo Uninstaller';       P='RevoUninstaller.RevoUninstaller' }
    @{ F='SystemTools'; B='Rufus';                 N='Rufus';                  P='Rufus.Rufus' }
    @{ F='SystemTools'; B='ShareX';                N='ShareX';                 P='ShareX.ShareX' }
    @{ F='SystemTools'; B='Ventoy';                N='Ventoy';                 P='Ventoy.Ventoy' }
    @{ F='SystemTools'; B='WinRAR';                N='WinRAR';                 P='RARLab.WinRAR' }
    @{ F='SystemTools'; B='WizTree';               N='WizTree';                P='AntibodySoftware.WizTree' }
    # Virtualization
    @{ F='Virtualization'; B='DockerDesktop'; N='Docker Desktop'; P='Docker.DockerDesktop' }
    @{ F='Virtualization'; B='Helm';          N='Helm';           P='Helm.Helm' }
    @{ F='Virtualization'; B='k9s';            N='k9s';            P='Derailed.k9s' }
    @{ F='Virtualization'; B='kubectl';        N='kubectl';        P='Kubernetes.kubectl' }
    @{ F='Virtualization'; B='Minikube';       N='Minikube';       P='Kubernetes.minikube' }
    @{ F='Virtualization'; B='Terraform';     N='Terraform';      P='Hashicorp.Terraform' }
    @{ F='Virtualization'; B='Vagrant';        N='Vagrant';        P='Hashicorp.Vagrant' }
    @{ F='Virtualization'; B='VirtualBox';    N='VirtualBox';     P='Oracle.VirtualBox' }
)

function Get-InstallBatContent {
    param($DisplayName, $PackageId)
    @"
@echo off
:: WinGet Install: $DisplayName
:: Package ID: $PackageId

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

echo ============================================================
echo  WinGet Install: $DisplayName
echo  Package ID: $PackageId
echo ============================================================
echo.

where winget >nul 2>&1
if %errorLevel% NEQ 0 (
    echo WinGet is NOT installed. Use the WinGet menu's [1] Install WinGet first.
    echo.
    if not defined MAINT_NO_PAUSE pause
    exit /b 1
)

winget install --id $PackageId -e --accept-source-agreements --accept-package-agreements
echo.
if not defined MAINT_NO_PAUSE pause
"@
}

# Map old file locations to recover existing scripts
$OldSearch = Get-ChildItem -Path $AppsRoot -Recurse -Filter 'Winget-Install-*.bat' -ErrorAction SilentlyContinue
$OldByBase = @{}
foreach ($f in $OldSearch) {
    $OldByBase[$f.BaseName] = $f.FullName
}

# Staging: write all bats to temp then swap
$Stage = Join-Path $env:TEMP "WingetAppsRebuild_$(Get-Random)"
New-Item -ItemType Directory -Force -Path $Stage | Out-Null

foreach ($a in $Apps) {
    $dir = Join-Path $Stage $a.F
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    $base = "Winget-Install-$($a.B)"
    $dest = Join-Path $dir "$base.bat"
    if ($OldByBase.ContainsKey($base)) {
        Copy-Item -LiteralPath $OldByBase[$base] -Destination $dest -Force
    } else {
        Set-Content -Path $dest -Value (Get-InstallBatContent $a.N $a.P) -Encoding ASCII
    }
}

# Replace Apps folder
if (Test-Path $AppsRoot) {
    Remove-Item -LiteralPath $AppsRoot -Recurse -Force
}
New-Item -ItemType Directory -Force -Path $AppsRoot | Out-Null
Get-ChildItem -LiteralPath $Stage -Directory | ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $AppsRoot $_.Name) -Recurse -Force
}
Remove-Item -LiteralPath $Stage -Recurse -Force

Write-Host "Created $($Apps.Count) install scripts in new folder layout."

# --- Install Apps menu layout (single screen, wide console) ---
$AppsMenuCols = 140
$MenuColumns = 4
$ColWidth = 32
$InnerWidth = $AppsMenuCols - 5

$_SectDash = -join (1..2 | ForEach-Object { [char]0x2500 })
$_BoxH = [char]0x2550
$_BoxVL = [char]0x2551
$_BoxTL = [char]0x2554
$_BoxTR = [char]0x2557
$_BoxBL = [char]0x255A
$_BoxBR = [char]0x255D
$_RuleDash = -join (1..$InnerWidth | ForEach-Object { [char]0x2500 })

function Sect-Line { param($Text) "echo   %GOLD%$_SectDash $Text $_SectDash%RESET%" }
function Rule-Line { "echo   %GOLD%$_RuleDash%RESET%" }

function Format-MenuCell {
    param($Num, $Name)
    if (-not $Num) { return (' ' * $ColWidth) }
    $nameWidth = $ColWidth - 7
    $label = $Name
    if ($label.Length -gt $nameWidth) { $label = $label.Substring(0, $nameWidth - 1) + '.' }
    else { $label = $label.PadRight($nameWidth) }
    "%GOLD%[$('{0,3}' -f $Num)]%RESET%  $label"
}

function Format-MenuRow4 {
    param($Cells)
    $parts = @()
    for ($i = 0; $i -lt $MenuColumns; $i++) {
        $c = if ($i -lt $Cells.Count) { $Cells[$i] } else { $null }
        if ($c) { $parts += (Format-MenuCell $c.Num $c.Name) } else { $parts += (' ' * $ColWidth) }
    }
    "echo        $($parts -join ' ')"
}

function Get-CenteredTitleLine {
    param([string]$Title)
    $t = $Title
    $pad = $InnerWidth - $t.Length
    $left = [Math]::Floor($pad / 2)
    $right = $pad - $left
    "echo   %GOLD%$_BoxVL$(' ' * $left)$t$(' ' * $right)$_BoxVL%RESET%"
}

function Get-BoxBorderLine {
    param([char]$Left, [char]$Right)
    $fill = -join (1..$InnerWidth | ForEach-Object { $_BoxH })
    "echo   %GOLD%$Left$fill$Right%RESET%"
}

function Get-CategoryMenuHeader {
    param($cat)
    switch ($cat.Key) {
        'Browsers'      { 'BROWSERS' }
        'Communication' { 'COMMUNICATION' }
        'Developer'     { 'DEV TOOLS' }
        'Games'         { 'GAMES' }
        'Hardware'      { 'HARDWARE ^& DIAGNOSTICS' }
        'Languages'     { 'LANGUAGES' }
        'Media'         { 'MEDIA' }
        'NetworkRemote' { 'NETWORK ^& REMOTE' }
        'Office'        { 'OFFICE ^& DOCUMENTS' }
        'Runtimes'      { 'RUNTIMES ^& FRAMEWORKS' }
        'Security'      { 'SECURITY ^& PRIVACY' }
        'SystemTools'   { 'SYSTEM TOOLS' }
        'Virtualization'{ 'VIRTUALIZATION ^& CONTAINERS' }
        default         { $cat.Label }
    }
}

$catApps = @{}
foreach ($cat in $Categories) {
    $folder = $cat.Folder
    $list = @($Apps | Where-Object { $_.F -eq $folder } | Sort-Object { $_.N })
    if ($cat.Key -eq 'Developer') { $list = @($Apps | Where-Object { $_.F -eq 'DevTools' } | Sort-Object { $_.N }) }
    $catApps[$cat.Key] = $list
}

$globalItems = New-Object System.Collections.Generic.List[object]
$seqAllCalls = New-Object System.Collections.Generic.List[string]
$menuLines = New-Object System.Collections.Generic.List[string]
$choiceLines = New-Object System.Collections.Generic.List[string]

$globalNum = 1
foreach ($cat in $Categories) {
    $list = $catApps[$cat.Key]
    if (-not $list -or $list.Count -eq 0) { continue }
    $label = Get-CategoryMenuHeader $cat
    [void]$menuLines.Add((Sect-Line $label))

    $rowCells = New-Object System.Collections.Generic.List[object]
    foreach ($a in $list) {
        $rel = "Winget\Apps\$($a.F)\Winget-Install-$($a.B).bat"
        $item = [PSCustomObject]@{ Num = $globalNum; Name = $a.N; RelPath = $rel }
        [void]$globalItems.Add($item)
        [void]$rowCells.Add($item)
        [void]$choiceLines.Add("if /i `"%choice%`"==`"$globalNum`" call :RunOneNoTee `"$rel`" & goto AppsLoop")
        $seqAllCalls.Add(":: $($cat.Key)")
        $seqAllCalls.Add("call :RunOneNoTee `"$rel`"")
        $globalNum++
        if ($rowCells.Count -eq $MenuColumns) {
            [void]$menuLines.Add((Format-MenuRow4 $rowCells))
            $rowCells.Clear()
        }
    }
    if ($rowCells.Count -gt 0) {
        [void]$menuLines.Add((Format-MenuRow4 $rowCells))
    }
}

# --- :AppsMenu fragment ---
$hub = New-Object System.Collections.Generic.List[string]
[void]$hub.Add('::MENU_BODY_START')
[void]$hub.Add('echo     %GOLD%Session log:%RESET%  %DIM%%MAINT_LOG%%RESET%')
[void]$hub.Add('echo     %DIM%WinGet output streams live and is NOT added to the session log.%RESET%')
[void]$hub.Add('echo.')
foreach ($ml in $menuLines) { [void]$hub.Add($ml) }
[void]$hub.Add((Sect-Line 'NAVIGATION') + '  %GOLD%[A]%RESET% Install EVERYTHING   %GOLD%[B]%RESET% WinGet menu   %GOLD%[M]%RESET% Main menu   %GOLD%[Q]%RESET% Quit')
[void]$hub.Add((Rule-Line))
[void]$hub.Add('echo.')
[void]$hub.Add('set "choice="')
[void]$hub.Add('set /p "choice=   %GOLD%Select option:%RESET%  "')
[void]$hub.Add('if not defined choice goto AppsLoop')
[void]$hub.Add('')
[void]$hub.Add(':: Navigation first.')
[void]$hub.Add('if /i "%choice%"=="B" goto :eof')
[void]$hub.Add('if /i "%choice%"=="M" set "_BACK_TO_MAIN=1" & goto :eof')
[void]$hub.Add('if /i "%choice%"=="Q" set "_QUIT=1" & goto :eof')
[void]$hub.Add('if /i "%choice%"=="A" call :SeqInstallAllApps & goto AppsLoop')
[void]$hub.Add('')
foreach ($cl in $choiceLines) { [void]$hub.Add($cl) }
[void]$hub.Add('')
[void]$hub.Add('echo.')
[void]$hub.Add('echo   Invalid choice: "%choice%"')
[void]$hub.Add('echo.')
[void]$hub.Add('pause')
[void]$hub.Add('goto AppsLoop')

# SeqInstallAllApps only (per-category Install ALL removed)
$total = $globalItems.Count
$DblDash = -join (1..$InnerWidth | ForEach-Object { [char]0x2550 })
function Dbl-Line { "echo   %GOLD%$DblDash%RESET%" }

$allSb = New-Object System.Text.StringBuilder
[void]$allSb.AppendLine("")
[void]$allSb.AppendLine(":SeqInstallAllApps")
[void]$allSb.AppendLine("call :SetConsoleSize 65 LOCK")
[void]$allSb.AppendLine("cls")
[void]$allSb.AppendLine("echo.")
[void]$allSb.AppendLine((Dbl-Line))
[void]$allSb.AppendLine("echo                  %GOLD%S E Q U E N C E   :   I N S T A L L   E V E R Y T H I N G%RESET%")
[void]$allSb.AppendLine("echo            Categories A-Z, each item A-Z within category")
[void]$allSb.AppendLine("echo            %DIM%($total packages total. Allow time and a stable internet connection.)%RESET%")
[void]$allSb.AppendLine((Dbl-Line))
[void]$allSb.AppendLine("echo.")
[void]$allSb.AppendLine(">> `"%MAINT_LOG%`" echo.")
[void]$allSb.AppendLine(">> `"%MAINT_LOG%`" echo ############################################################")
[void]$allSb.AppendLine(">> `"%MAINT_LOG%`" echo  SEQUENCE: Install ALL Apps  -  %DATE% %TIME%")
[void]$allSb.AppendLine(">> `"%MAINT_LOG%`" echo ############################################################")
[void]$allSb.AppendLine('set "MAINT_NO_PAUSE=1"')
foreach ($line in $seqAllCalls) { [void]$allSb.AppendLine($line) }
[void]$allSb.AppendLine('set "MAINT_NO_PAUSE="')
[void]$allSb.AppendLine("echo.")
[void]$allSb.AppendLine((Dbl-Line))
[void]$allSb.AppendLine("echo     %GOLD%Full app install sequence complete.%RESET%")
[void]$allSb.AppendLine("echo     %DIM%Log: %MAINT_LOG%%RESET%")
[void]$allSb.AppendLine((Dbl-Line))
[void]$allSb.AppendLine("echo.")
[void]$allSb.AppendLine("pause")
[void]$allSb.AppendLine("goto :eof")
[void]$allSb.AppendLine("")

$banner = @(
    'echo.'
    (Get-BoxBorderLine $_BoxTL $_BoxTR)
    "echo   %GOLD%$_BoxVL$(' ' * $InnerWidth)$_BoxVL%RESET%"
    (Get-CenteredTitleLine 'I N S T A L L   A P P S   V I A   W I N G E T')
    "echo   %GOLD%$_BoxVL$(' ' * $InnerWidth)$_BoxVL%RESET%"
    (Get-BoxBorderLine $_BoxBL $_BoxBR)
)

$header = @"
:AppsMenu
:AppsLoop
call :SetConsoleSize 65 LOCK
cls
powershell -NoProfile -Command "try { [Console]::SetCursorPosition(0,0) } catch {}" >nul 2>&1
"@

$utf8 = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText((Join-Path $OutDir 'AppsMenu.fragment.bat'), ($hub -join "`r`n"), $utf8)
[System.IO.File]::WriteAllText((Join-Path $OutDir 'AppsCategoryMenus.fragment.bat'), '', $utf8)
[System.IO.File]::WriteAllText((Join-Path $OutDir 'SeqInstall.fragment.bat'), $allSb.ToString(), $utf8)
[System.IO.File]::WriteAllText((Join-Path $OutDir 'AppsMenuHeader.fragment.bat'), $header, $utf8)
[System.IO.File]::WriteAllLines((Join-Path $OutDir 'AppsBanner.fragment.bat'), $banner, $utf8)

Write-Host "Generated fragments in Tools\Winget\_generated\"
Write-Host "Total apps: $total (flat menu, ${AppsMenuCols}x65, $MenuColumns columns)"
