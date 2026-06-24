# Emit wishlist "Already in toolkit" table rows from catalog (read-only)
$ErrorActionPreference = 'Stop'
$scriptPath = Join-Path $PSScriptRoot '_Rebuild-AppsCatalog.ps1'
$text = Get-Content -LiteralPath $scriptPath -Raw
$matches = [regex]::Matches($text, "@\{ F='([^']+)'; B='([^']+)';\s+N='([^']+)';?\s+P='([^']+)' \}")

$catDisplay = @{
    'Browsers' = 'Browsers'
    'Communication' = 'Communication'
    'DevTools' = 'Developer'
    'Games' = 'Games'
    'Hardware' = 'Hardware & Diagnostics'
    'Languages' = 'Languages'
    'Media' = 'Media'
    'NetworkRemote' = 'Network & Remote'
    'Office' = 'Office & Documents'
    'Runtimes' = 'Runtimes & Frameworks'
    'Security' = 'Security & Privacy'
    'SystemTools' = 'System Tools'
    'Virtualization' = 'Virtualization & Containers'
}
$catOrder = @(
    'Browsers','Communication','DevTools','Games','Hardware','Languages',
    'Media','NetworkRemote','Office','Runtimes','Security','SystemTools','Virtualization'
)

$apps = foreach ($m in $matches) {
    [PSCustomObject]@{
        F = $m.Groups[1].Value
        N = $m.Groups[3].Value
        P = $m.Groups[4].Value
    }
}

foreach ($folder in $catOrder) {
    foreach ($a in ($apps | Where-Object { $_.F -eq $folder } | Sort-Object N)) {
        "| $($a.N) | ``$($a.P)`` | $($catDisplay[$a.F]) |"
    }
}
