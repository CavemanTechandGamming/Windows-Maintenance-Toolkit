param([Parameter(Mandatory)][string]$Path)
$utf8Bom = New-Object System.Text.UTF8Encoding $true
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$text = [IO.File]::ReadAllText($Path, $utf8Bom)
[IO.File]::WriteAllText($Path, $text, $utf8NoBom)
$bytes = [IO.File]::ReadAllBytes($Path)[0..2]
$hasBom = ($bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF)
if ($hasBom) { throw "BOM still present after strip: $Path" }
Write-Host "OK: $Path (starts with @echo off, no BOM)"
