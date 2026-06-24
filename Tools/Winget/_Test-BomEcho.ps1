$path = 'c:\Users\doom1\Documents\Clean Up\MaintenanceLauncher.bat'
$gitPath = 'c:\Users\doom1\Documents\Clean Up\Tools\Winget\_git_head_launcher.bat'
foreach ($p in @($path, $gitPath)) {
    $b = [IO.File]::ReadAllBytes($p)[0..2]
    $bom = ($b[0] -eq 0xEF -and $b[1] -eq 0xBB -and $b[2] -eq 0xBF)
    Write-Host "$(Split-Path $p -Leaf): BOM=$bom"
}

# Minimal repro: BOM breaks @echo off in cmd
$repro = Join-Path $PSScriptRoot '_bom_echo_test.bat'
$text = "@echo off`r`necho RESULT:%ECHO%`r`n"
$utf8Bom = New-Object System.Text.UTF8Encoding $true
[IO.File]::WriteAllText($repro, $text, $utf8Bom)
$out = cmd /c $repro 2>&1
Write-Host "BOM test output lines:"
$out | ForEach-Object { Write-Host "  $_" }

$repro2 = Join-Path $PSScriptRoot '_nobom_echo_test.bat'
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[IO.File]::WriteAllText($repro2, $text, $utf8NoBom)
$out2 = cmd /c $repro2 2>&1
Write-Host "No-BOM test output lines:"
$out2 | ForEach-Object { Write-Host "  $_" }
