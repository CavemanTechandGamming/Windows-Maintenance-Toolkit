# Merge _generated fragments into MaintenanceLauncher.bat
$ErrorActionPreference = 'Stop'
$Root = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$launcher = Join-Path $Root 'MaintenanceLauncher.bat'
$gen = Join-Path $Root 'Tools\Winget\_generated'
$lines = Get-Content -LiteralPath $launcher -Encoding UTF8
$header = Get-Content -LiteralPath (Join-Path $gen 'AppsMenuHeader.fragment.bat') -Encoding UTF8
$menuRaw = Get-Content -LiteralPath (Join-Path $gen 'AppsMenu.fragment.bat') -Encoding UTF8
$menuBody = $menuRaw | Where-Object { $_ -ne '::MENU_BODY_START' }
$catMenus = Get-Content -LiteralPath (Join-Path $gen 'AppsCategoryMenus.fragment.bat') -Encoding UTF8 -Raw
$seq = Get-Content -LiteralPath (Join-Path $gen 'SeqInstall.fragment.bat') -Encoding UTF8 -Raw

$bannerStart = ($lines | Select-String -Pattern 'I N S T A L L   A P P S' | Select-Object -First 1).LineNumber - 3
$banner = $lines[($bannerStart - 1)..($bannerStart + 4)]

$startApps = ($lines | Select-String -Pattern '^:AppsMenu$' | Select-Object -First 1).LineNumber - 2
$endApps = ($lines | Select-String -Pattern '^::  CONSOLE SIZE$' | Select-Object -First 1).LineNumber - 2
$startSeq = ($lines | Select-String -Pattern '^:SeqInstallBrowsers$' | Select-Object -First 1).LineNumber - 1
$endSeq = ($lines | Select-String -Pattern '^:SeqFull$' | Select-Object -First 1).LineNumber - 2

$newApps = @()
$newApps += $lines[0..($startApps - 1)]
$newApps += $header
$newApps += $banner
$newApps += $menuBody
$newApps += ($catMenus -split "`r?`n")
$newApps += $lines[($endApps + 1)..($startSeq - 1)]
$newApps += ($seq -split "`r?`n")
$newApps += $lines[$endSeq..($lines.Length - 1)]

$utf8 = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllLines($launcher, $newApps, $utf8)
Write-Host 'Merged launcher (hub + category menus + SeqInstall).'
