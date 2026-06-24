$ErrorActionPreference = 'Stop'
$launcher = Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'MaintenanceLauncher.bat'
$utf8 = New-Object System.Text.UTF8Encoding $false
$lines = [System.IO.File]::ReadAllLines($launcher, $utf8)

$appsIdx = ($lines | Select-String -Pattern '^:AppsLoop$').LineNumber - 1
$menuIdx = ($lines | Select-String -Pattern '^:MENU$').LineNumber - 1
$wingetIdx = ($lines | Select-String -Pattern '^:WingetMenu$').LineNumber - 1

# Copy banner block from Apps menu (AppsLoop+2 .. +9): cls through session log line
$srcStart = $appsIdx + 2
$dstStart = $menuIdx + 2
for ($k = 0; $k -le 7; $k++) {
    $lines[$dstStart + $k] = $lines[$srcStart + $k]
}
# Title line
$lines[$dstStart + 4] = $lines[$dstStart + 4] -replace 'I N S T A L L   A P P S   V I A   W I N G E T', 'W I N D O W S   M A I N T E N A N C E'
# Drop extra WinGet note on main menu - keep only session log line after banner
$lines[$dstStart + 7] = "echo     %GOLD%Session log:%RESET%  %DIM%%MAINT_LOG%%RESET%"

# UTILITY header + footer rule from Winget
$utilHeader = ($lines | Select-String -Pattern '── UTILITY' | Select-Object -First 1).Line
$footerRule = ($lines | Select-String -Pattern '^echo   %GOLD%─{20,}' | Select-Object -Last 1).Line

for ($i = $menuIdx; $i -lt $wingetIdx; $i++) {
    if ($lines[$i] -match 'SEQUENCES') {
        $lines[$i] = 'echo   %GOLD%── SEQUENCES%RESET%  %DIM%(no pauses between steps)%RESET% %GOLD%─────────────────────────────────────────────%RESET%'
    }
    if ($lines[$i] -match '^\s*echo\.$' -and $lines[$i-1] -match 'Full maintenance') {
        # insert utility header after sequences blank line
        $lines[$i] = $utilHeader
    }
    if ($lines[$i] -match '\[V\]' -and $lines[$i-1] -notmatch 'UTILITY') {
        # ensure utility header precedes V
    }
}

# Fix: line before [V] should be utility header
for ($i = $menuIdx; $i -lt $wingetIdx; $i++) {
    if ($lines[$i] -match '\[V\].*View current session') {
        $lines[$i - 1] = 'echo.'
        $lines[$i - 2] = $utilHeader
        break
    }
}

for ($i = $menuIdx; $i -lt $wingetIdx; $i++) {
    if ($lines[$i] -match 'set /p "choice=') {
        $lines[$i - 2] = $footerRule
        break
    }
}

[System.IO.File]::WriteAllLines($launcher, $lines, $utf8)
Write-Host 'Main menu structure fixed from Apps/Winget templates.'
