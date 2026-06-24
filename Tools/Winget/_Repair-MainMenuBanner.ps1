# Copy box-drawing lines from :WingetMenu banner to :MENU banner (fix mojibake)
$ErrorActionPreference = 'Stop'
$launcher = Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'MaintenanceLauncher.bat'
$utf8 = New-Object System.Text.UTF8Encoding $false
$lines = [System.IO.File]::ReadAllLines($launcher, $utf8)

$wingetBanner = @()
for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -eq ':WingetMenu') {
        for ($j = $i + 4; $j -lt $i + 10; $j++) {
            if ($lines[$j] -match 'echo\.' -and $wingetBanner.Count -ge 4) { break }
            if ($lines[$j] -match 'W I N G E T') {
                $wingetBanner += $lines[$j] -replace 'W I N G E T   M A N A G E R', 'W I N D O W S   M A I N T E N A N C E'
            } elseif ($lines[$j] -match 'echo\.' -or $lines[$j] -match '╔|╚|║') {
                $wingetBanner += $lines[$j]
            }
        }
        break
    }
}

$menuStart = -1
for ($i = 0; $i -lt $lines.Length; $i++) { if ($lines[$i] -eq ':MENU') { $menuStart = $i; break } }
if ($menuStart -lt 0) { throw ':MENU not found' }

# Replace lines after "echo." following :MENU cls (index menuStart+3)
$echoIdx = $menuStart + 3
while ($echoIdx -lt $lines.Length -and $lines[$echoIdx] -ne 'echo.') { $echoIdx++ }
$bannerStart = $echoIdx
$bannerEnd = $bannerStart
while ($bannerEnd -lt $lines.Length -and $lines[$bannerEnd] -notmatch 'Session log') { $bannerEnd++ }

$new = [System.Collections.Generic.List[string]]::new()
for ($i = 0; $i -lt $bannerStart; $i++) { [void]$new.Add($lines[$i]) }
foreach ($b in $wingetBanner) { [void]$new.Add($b) }
for ($i = $bannerEnd; $i -lt $lines.Length; $i++) { [void]$new.Add($lines[$i]) }

# Fix section rule lines in main menu only (between :MENU and WINGET SUBMENU)
$inMenu = $false
for ($i = 0; $i -lt $new.Count; $i++) {
    if ($new[$i] -eq ':MENU') { $inMenu = $true; continue }
    if ($inMenu -and $new[$i] -match 'WINGET SUBMENU') { break }
    if ($inMenu -and $new[$i] -match '^echo   %GOLD%' -and $new[$i] -match 'SYSTEM REPAIR|CLEANUP|NETWORK|PACKAGE|SEQUENCES|UTILITY' -and $new[$i] -notmatch '──') {
        # leave long rule lines - copy from Apps if corrupted
    }
}

# Copy section header style from Apps menu (line with ── BROWSERS ──)
$sectTemplate = $null
foreach ($l in $lines) { if ($l -match '── CATEGORIES ──') { $sectTemplate = $l; break } }
if ($sectTemplate) {
    $replacements = @{
        'SYSTEM REPAIR' = 'SYSTEM REPAIR ─────────────────────────────────────────────────────────────────────'
        'CLEANUP' = 'CLEANUP ───────────────────────────────────────────────────────────────────────────'
        'NETWORK' = 'NETWORK ───────────────────────────────────────────────────────────────────────────'
        'PACKAGE MANAGEMENT' = 'PACKAGE MANAGEMENT ────────────────────────────────────────────────────────────────'
        'SEQUENCES' = 'SEQUENCES'
        'UTILITY' = 'UTILITY ───────────────────────────────────────────────────────────────────────────'
    }
    $inMenu = $false
    for ($i = 0; $i -lt $new.Count; $i++) {
        if ($new[$i] -eq ':MENU') { $inMenu = $true; continue }
        if ($inMenu -and $new[$i] -match ':: =+' -and $new[$i+1] -match 'WINGET') { break }
        if ($inMenu -and $new[$i] -match 'ΓöÇΓöÇ SYSTEM REPAIR') {
            $new[$i] = 'echo   %GOLD%── SYSTEM REPAIR ─────────────────────────────────────────────────────────────────────%RESET%'
        }
        if ($inMenu -and $new[$i] -match 'ΓöÇΓöÇ CLEANUP') {
            $new[$i] = 'echo   %GOLD%── CLEANUP ───────────────────────────────────────────────────────────────────────────%RESET%'
        }
        if ($inMenu -and $new[$i] -match 'ΓöÇΓöÇ NETWORK') {
            $new[$i] = 'echo   %GOLD%── NETWORK ───────────────────────────────────────────────────────────────────────────%RESET%'
        }
        if ($inMenu -and $new[$i] -match 'PACKAGE MANAGEMENT') {
            $new[$i] = 'echo   %GOLD%── PACKAGE MANAGEMENT ────────────────────────────────────────────────────────────────%RESET%'
        }
        if ($inMenu -and $new[$i] -match 'ΓöÇΓöÇ SEQUENCES') {
            $new[$i] = 'echo   %GOLD%── SEQUENCES%RESET%  %DIM%(no pauses between steps)%RESET% %GOLD%─────────────────────────────────────────────%RESET%'
        }
        if ($inMenu -and $new[$i] -match 'ΓöÇΓöÇ UTILITY') {
            $new[$i] = 'echo   %GOLD%── UTILITY ───────────────────────────────────────────────────────────────────────────%RESET%'
        }
        if ($inMenu -and $new[$i] -match 'ΓöÇΓöÇΓöÇ') {
            $new[$i] = 'echo   %GOLD%──────────────────────────────────────────────────────────────────────────────────────%RESET%'
        }
    }
}

[System.IO.File]::WriteAllLines($launcher, $new, $utf8)
Write-Host 'Repaired main menu banner and section lines.'
