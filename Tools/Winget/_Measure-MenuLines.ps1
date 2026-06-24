$utf8 = New-Object System.Text.UTF8Encoding $false
$lines = [IO.File]::ReadAllLines('c:\Users\doom1\Documents\Clean Up\MaintenanceLauncher.bat', $utf8)
$m = 0
for ($i = 0; $i -lt $lines.Length; $i++) { if ($lines[$i] -eq ':MENU') { $m = $i; break } }
for ($j = $m; $j -lt $m + 55; $j++) {
    $vis = $lines[$j] -replace '%GOLD%','' -replace '%RESET%','' -replace '%DIM%','' -replace '%WHITE%',''
    if ($vis -match '^echo') {
        Write-Host ('{0,4}: len={1,3}' -f ($j+1), $vis.Length)
    }
}
