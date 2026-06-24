$utf8 = New-Object System.Text.UTF8Encoding $false
$lines = [IO.File]::ReadAllLines('c:\Users\doom1\Documents\Clean Up\MaintenanceLauncher.bat', $utf8)
$box = [char]0x2551
foreach ($n in 73, 74, 75, 76, 169, 334) {
    $l = $lines[$n - 1] -replace '%GOLD%', '' -replace '%RESET%', ''
    $parts = $l.Split($box)
    if ($parts.Length -ge 3) {
        $inner = $parts[1]
        Write-Host ("Line {0}: inner={1}" -f $n, $inner.Length)
    }
}
