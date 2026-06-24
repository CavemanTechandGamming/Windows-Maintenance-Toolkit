$ErrorActionPreference = 'Stop'
$launcher = Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'MaintenanceLauncher.bat'
$utf8 = New-Object System.Text.UTF8Encoding $false
$lines = [System.IO.File]::ReadAllLines($launcher, $utf8)

$wingetIdx = ($lines | Select-String -Pattern '^:WingetMenu$').LineNumber - 1
$menuIdx = ($lines | Select-String -Pattern '^:MENU$').LineNumber - 1

# Winget banner is at wingetIdx+4 .. +8 (echo. through closing box)
for ($k = 0; $k -le 4; $k++) {
    $lines[$menuIdx + 3 + $k] = $lines[$wingetIdx + 3 + $k]
}
$lines[$menuIdx + 5] = $lines[$menuIdx + 5] -replace 'W I N G E T   M A N A G E R', 'W I N D O W S   M A I N T E N A N C E'

# Section + footer rules: copy from winget (first long rule before set /p)
for ($j = $wingetIdx; $j -lt $wingetIdx + 50; $j++) {
    if ($lines[$j] -match 'set /p "choice=') {
        $wgRule = $lines[$j - 2]
        break
    }
}
for ($i = $menuIdx; $i -lt $wingetIdx; $i++) {
    if ($lines[$i] -match 'set /p "choice=') {
        $lines[$i - 2] = $wgRule
        break
    }
}

# Copy each winget section header line pattern onto main menu headers by keyword
$wgHeaders = @{}
for ($j = $wingetIdx; $j -lt $wingetIdx + 35; $j++) {
    if ($lines[$j] -match 'WINGET ITSELF') { $wgHeaders['REPAIR'] = $lines[$j] -replace 'WINGET ITSELF', 'SYSTEM REPAIR' }
    if ($lines[$j] -match 'WINGET QUERIES') { $wgHeaders['CLEANUP'] = $lines[$j] -replace 'WINGET QUERIES', 'CLEANUP' }
    if ($lines[$j] -match 'WINGET ACTIONS') { $wgHeaders['NETWORK'] = $lines[$j] -replace 'WINGET ACTIONS', 'NETWORK' }
    if ($lines[$j] -match '── UTILITY') { $wgHeaders['UTILITY'] = $lines[$j] }
}
for ($i = $menuIdx; $i -lt $wingetIdx; $i++) {
    if ($lines[$i] -match 'SYSTEM REPAIR') { $lines[$i] = $wgHeaders['REPAIR'] }
    if ($lines[$i] -match 'CLEANUP' -and $lines[$i] -match 'echo   %GOLD%') { $lines[$i] = $wgHeaders['CLEANUP'] }
    if ($lines[$i] -match 'NETWORK' -and $lines[$i] -match 'echo   %GOLD%' -and $lines[$i] -notmatch '\[1') { $lines[$i] = $wgHeaders['NETWORK'] }
    if ($lines[$i] -match 'PACKAGE MANAGEMENT') {
        $lines[$i] = $wgHeaders['REPAIR'] -replace 'SYSTEM REPAIR', 'PACKAGE MANAGEMENT' -replace '─────────────────────────────────────────────────────────────────────', '───────────────────────────────────────────────────────────────'
    }
    if ($lines[$i] -match 'SEQUENCES') {
        $lines[$i] = 'echo   %GOLD%── SEQUENCES%RESET%  %DIM%(no pauses between steps)%RESET% %GOLD%─────────────────────────────────────────────%RESET%'
    }
    if ($lines[$i] -match 'UTILITY' -and $lines[$i] -match 'echo   %GOLD%' -and $lines[$i] -notmatch '\[V\]') { $lines[$i] = $wgHeaders['UTILITY'] }
}

[System.IO.File]::WriteAllLines($launcher, $lines, $utf8)
Write-Host 'Main menu banner and headers repaired.'
