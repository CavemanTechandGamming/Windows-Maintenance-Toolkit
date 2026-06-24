$ErrorActionPreference = 'Stop'
$p = Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'MaintenanceLauncher.bat'
$utf8 = New-Object System.Text.UTF8Encoding $false
$l = [System.IO.File]::ReadAllLines($p, $utf8)

$w = -1; $m = -1
for ($i = 0; $i -lt $l.Length; $i++) {
    if ($l[$i] -eq ':WingetMenu') { $w = $i }
    if ($l[$i] -eq ':MENU') { $m = $i }
}

# Winget: :WingetMenu +3 = cls, +4 = echo., +5..+9 = banner, +10 = session log
$l[$m + 2] = 'cls'
for ($k = 0; $k -le 7; $k++) { $l[$m + 2 + $k] = $l[$w + 3 + $k] }
$l[$m + 6] = $l[$m + 6].Replace('W I N G E T   M A N A G E R', 'W I N D O W S   M A I N T E N A N C E')

$util = ($l | Where-Object { $_ -match 'UTILITY' -and $_ -match 'echo   %GOLD%' } | Select-Object -First 1)
$rule = ($l | Where-Object { $_ -match 'echo   %GOLD%' -and $_.Length -gt 120 } | Select-Object -Last 1)
$seqSrc = ($l | Where-Object { $_ -match 'WINGET ITSELF' } | Select-Object -First 1)

for ($i = $m; $i -lt $w; $i++) {
    if ($l[$i] -match 'SEQUENCES') {
        $l[$i] = $seqSrc.Replace('WINGET ITSELF', 'SEQUENCES').Replace(
            '─────────────────────────────────────────────────────────────────────',
            '─────────────────────────────────────────────'
        )
        $l[$i] = $l[$i] -replace '── WINGET ITSELF', '── SEQUENCES%RESET%  %DIM%(no pauses between steps)%RESET% %GOLD%──'
        if ($l[$i] -notmatch 'no pauses') {
            $l[$i] = $seqSrc.Replace('WINGET ITSELF ──', 'SEQUENCES%RESET%  %DIM%(no pauses between steps)%RESET% %GOLD%──')
        }
    }
    if ($l[$i] -match 'Full maintenance') {
        $l[$i + 1] = 'echo.'
        $l[$i + 2] = $util
    }
    if ($l[$i] -match 'set /p "choice=') {
        $l[$i - 2] = $rule
        $l[$i - 1] = 'echo.'
    }
}

[IO.File]::WriteAllLines($p, $l, $utf8)
Write-Host OK
