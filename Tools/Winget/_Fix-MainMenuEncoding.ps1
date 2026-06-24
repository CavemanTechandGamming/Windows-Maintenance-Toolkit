# Fix main menu encoding by splicing :MENU block from git HEAD (UTF-8)
$ErrorActionPreference = 'Stop'
$Root = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$launcher = Join-Path $Root 'MaintenanceLauncher.bat'
$temp = Join-Path $env:TEMP "MaintLauncher_git_$([guid]::NewGuid().ToString('n')).bat"

$gitOut = & git -C "$Root" show 'HEAD:MaintenanceLauncher.bat'
if (-not $gitOut) { throw 'git show failed' }
$utf8 = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($temp, ($gitOut -join "`r`n") + "`r`n", $utf8)
$gitText = [System.IO.File]::ReadAllText($temp, $utf8)
$gitLines = $gitText -split "`r?`n"
$curLines = [System.IO.File]::ReadAllLines($launcher, $utf8)

$startCur = 0
for ($i = 0; $i -lt $curLines.Length; $i++) { if ($curLines[$i] -eq ':MENU') { $startCur = $i; break } }
$endCur = 0
for ($i = $startCur + 1; $i -lt $curLines.Length; $i++) {
    if ($curLines[$i] -match '^:: =+$' -and $curLines[$i+1] -match 'WINGET SUBMENU') { $endCur = $i - 1; break }
}
$startGit = 0
for ($i = 0; $i -lt $gitLines.Length; $i++) { if ($gitLines[$i] -eq ':MENU') { $startGit = $i; break } }
$endGit = 0
for ($i = $startGit + 1; $i -lt $gitLines.Length; $i++) {
    if ($gitLines[$i] -match '^:: =+$' -and $gitLines[$i+1] -match 'WINGET SUBMENU') { $endGit = $i - 1; break }
}

$new = [System.Collections.Generic.List[string]]::new()
if ($startCur -gt 0) { foreach ($line in $curLines[0..($startCur - 1)]) { [void]$new.Add($line) } }
foreach ($line in $gitLines[$startGit..$endGit]) { [void]$new.Add($line) }
if ($endCur + 1 -lt $curLines.Length) { foreach ($line in $curLines[($endCur + 1)..($curLines.Length - 1)]) { [void]$new.Add($line) } }

[System.IO.File]::WriteAllLines($launcher, $new, $utf8)
Remove-Item -LiteralPath $temp -Force -ErrorAction SilentlyContinue
Write-Host 'Fixed main menu encoding from git HEAD.'
