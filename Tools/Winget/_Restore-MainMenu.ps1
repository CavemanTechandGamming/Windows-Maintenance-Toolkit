# Restore :MENU block from last committed version (original UI)
$ErrorActionPreference = 'Stop'
$Root = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$launcher = Join-Path $Root 'MaintenanceLauncher.bat'
$gitMenu = git -C $Root show 'HEAD:MaintenanceLauncher.bat'
if (-not $gitMenu) { throw 'Could not read MaintenanceLauncher.bat from git HEAD' }
$gitLines = $gitMenu -split "`r?`n"
$curLines = Get-Content -LiteralPath $launcher -Encoding UTF8

$startCur = ($curLines | Select-String -Pattern '^:MENU$' | Select-Object -First 1).LineNumber - 1
$endCur = ($curLines | Select-String -Pattern '^:: =+$' | Where-Object { $_.LineNumber -gt $startCur } | Select-Object -First 1).LineNumber - 2
$startGit = ($gitLines | Select-String -Pattern '^:MENU$' | Select-Object -First 1).LineNumber - 1
$endGit = ($gitLines | Select-String -Pattern '^:: =+$' | Where-Object { $_.LineNumber -gt $startGit } | Select-Object -First 1).LineNumber - 2

$new = @()
$new += $curLines[0..($startCur - 1)]
$new += $gitLines[$startGit..$endGit]
$new += $curLines[($endCur + 1)..($curLines.Length - 1)]
$utf8 = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllLines($launcher, $new, $utf8)
Write-Host 'Restored main menu from git HEAD.'
