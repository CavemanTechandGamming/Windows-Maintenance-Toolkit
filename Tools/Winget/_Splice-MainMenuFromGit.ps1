$ErrorActionPreference = 'Stop'
$Root = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$launcher = Join-Path $Root 'MaintenanceLauncher.bat'
$gitFile = Join-Path $PSScriptRoot '_git_head_launcher.bat'
$utf8 = New-Object System.Text.UTF8Encoding $false
$gitLines = [IO.File]::ReadAllLines($gitFile, $utf8)
$curLines = [IO.File]::ReadAllLines($launcher, $utf8)

$startGit = -1; $endGit = -1; $startCur = -1; $endCur = -1
for ($i = 0; $i -lt $gitLines.Length; $i++) {
    if ($gitLines[$i] -eq ':MENU' -and $startGit -lt 0) { $startGit = $i }
    if ($startGit -ge 0 -and $endGit -lt 0 -and $gitLines[$i] -match '^:: =+$' -and $gitLines[$i+1] -match 'WINGET SUBMENU') { $endGit = $i }
}
for ($i = 0; $i -lt $curLines.Length; $i++) {
    if ($curLines[$i] -eq ':MENU' -and $startCur -lt 0) { $startCur = $i }
    if ($startCur -ge 0 -and $endCur -lt 0 -and $curLines[$i] -match '^:: =+$' -and $curLines[$i+1] -match 'WINGET SUBMENU') { $endCur = $i }
}

if ($startGit -lt 0 -or $endGit -lt 0) { throw 'Could not find MENU block in git file' }

$out = [System.Collections.Generic.List[string]]::new()
for ($i = 0; $i -lt $startCur; $i++) { [void]$out.Add($curLines[$i]) }
for ($i = $startGit; $i -le $endGit; $i++) { [void]$out.Add($gitLines[$i]) }
for ($i = $endCur + 1; $i -lt $curLines.Length; $i++) { [void]$out.Add($curLines[$i]) }

[IO.File]::WriteAllLines($launcher, $out, $utf8)
Write-Host "Spliced MENU lines $($startGit+1)-$($endGit+1) from git export."
