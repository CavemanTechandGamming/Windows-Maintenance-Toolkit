# Merge _generated fragments into MaintenanceLauncher.bat
$ErrorActionPreference = 'Stop'
$Root = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$launcher = Join-Path $Root 'MaintenanceLauncher.bat'
$gen = Join-Path $Root 'Tools\Winget\_generated'
$utf8 = New-Object System.Text.UTF8Encoding $false
$lines = [System.IO.File]::ReadAllLines($launcher, $utf8)

$header = [System.IO.File]::ReadAllLines((Join-Path $gen 'AppsMenuHeader.fragment.bat'), $utf8)
$banner = [System.IO.File]::ReadAllLines((Join-Path $gen 'AppsBanner.fragment.bat'), $utf8)
$menuRaw = [System.IO.File]::ReadAllLines((Join-Path $gen 'AppsMenu.fragment.bat'), $utf8)
$menuBody = $menuRaw | Where-Object { $_ -ne '::MENU_BODY_START' }
$seq = [System.IO.File]::ReadAllText((Join-Path $gen 'SeqInstall.fragment.bat'), $utf8)

$startApps = 0
for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -eq ':AppsMenu') { $startApps = $i - 1; break }
}
$endApps = 0
for ($i = $startApps + 1; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match '^goto AppsLoop$' -and $lines[$i + 1] -match '^::  CONSOLE SIZE$') {
        $endApps = $i
        break
    }
}
$startSeq = 0
for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -eq ':SeqInstallBrowsers' -or $lines[$i] -eq ':SeqInstallAllApps') { $startSeq = $i - 1; break }
}
$endSeq = 0
for ($i = $startSeq + 1; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -eq ':SeqFull') { $endSeq = $i - 2; break }
}

$newApps = [System.Collections.Generic.List[string]]::new()
if ($startApps -gt 0) { foreach ($line in $lines[0..($startApps - 1)]) { [void]$newApps.Add($line) } }
foreach ($line in $header) { [void]$newApps.Add($line) }
foreach ($line in $banner) { [void]$newApps.Add($line) }
foreach ($line in $menuBody) { [void]$newApps.Add($line) }
if ($endApps + 1 -lt $startSeq) { foreach ($line in $lines[($endApps + 1)..($startSeq - 1)]) { [void]$newApps.Add($line) } }
foreach ($line in ($seq -split "`r?`n")) { if ($line -ne '') { [void]$newApps.Add($line) } }
if ($endSeq + 1 -lt $lines.Length) { foreach ($line in $lines[($endSeq + 1)..($lines.Length - 1)]) { [void]$newApps.Add($line) } }

[System.IO.File]::WriteAllLines($launcher, $newApps, $utf8)
Write-Host 'Merged launcher (flat Install Apps menu + SeqInstallAllApps).'
