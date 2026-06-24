$path = 'c:\Users\doom1\Documents\Clean Up\MaintenanceLauncher.bat'
$bytes = [IO.File]::ReadAllBytes($path)[0..31]
Write-Host ('First bytes: ' + (($bytes | ForEach-Object { '{0:X2}' -f $_ }) -join ' '))
$utf8 = New-Object System.Text.UTF8Encoding $false
$line1 = [IO.File]::ReadAllLines($path, $utf8)[0]
Write-Host "Line1 length: $($line1.Length)"
Write-Host "Line1 chars: $([int[]][char[]]$line1 -join ',')"
