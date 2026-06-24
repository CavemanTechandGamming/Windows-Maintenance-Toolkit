$ErrorActionPreference = 'Stop'
$p = Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'MaintenanceLauncher.bat'
$git = Join-Path $PSScriptRoot '_git_head_launcher.bat'
$utf8 = New-Object System.Text.UTF8Encoding $false
$l = [IO.File]::ReadAllLines($p, $utf8)
$g = [IO.File]::ReadAllLines($git, $utf8)

$m = -1; $w = -1
for ($i = 0; $i -lt $l.Length; $i++) {
    if ($l[$i] -eq ':MENU') { $m = $i }
    if ($l[$i] -eq ':WingetMenu') { $w = $i; break }
}

# SEQUENCES, UTILITY, footer from git MENU block
$gm = -1
for ($i = 0; $i -lt $g.Length; $i++) { if ($g[$i] -eq ':MENU') { $gm = $i; break } }
for ($i = $m; $i -lt $w; $i++) {
    if ($l[$i] -match 'Full repair') {
        for ($j = $gm; $j -lt $g.Length; $j++) {
            if ($g[$j] -match 'SEQUENCES') { $l[$i - 1] = $g[$j]; break }
        }
    }
    if ($l[$i] -match 'View current session log' -and $l[$i-1] -notmatch 'UTILITY') {
        for ($j = $gm; $j -lt $g.Length; $j++) {
            if ($g[$j] -match 'UTILITY' -and $g[$j] -match 'echo') { $l[$i - 1] = 'echo.'; $l[$i] = $g[$j]; break }
        }
    }
    if ($l[$i] -match 'set /p "choice=') {
        for ($j = $gm; $j -lt $g.Length; $j++) {
            if ($g[$j] -match 'set /p "choice=') { $l[$i - 2] = $g[$j - 2]; $l[$i - 1] = $g[$j - 1]; break }
        }
    }
}

# Remove stray apps NAVIGATION lines inside main menu
$clean = [System.Collections.Generic.List[string]]::new()
for ($i = 0; $i -lt $l.Length; $i++) {
    if ($i -gt $m -and $i -lt $w -and $l[$i] -match 'NAVIGATION.*Install EVERYTHING') { continue }
    [void]$clean.Add($l[$i])
}

[IO.File]::WriteAllLines($p, $clean, $utf8)
Write-Host 'Sequences/utility/footer restored; removed stray NAVIGATION.'
