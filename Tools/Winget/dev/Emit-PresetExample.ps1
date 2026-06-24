# Generate Tools\Winget\Presets\Preset-Example.txt (full catalog, all lines commented)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'Get-ToolkitRoot.ps1')
$Root = Get-ToolkitRoot
$catalogPath = Join-Path $PSScriptRoot 'Rebuild-AppsCatalog.ps1'
$outPath = Join-Path $Root 'Tools\Winget\Presets\Preset-Example.txt'

$text = Get-Content -LiteralPath $catalogPath -Raw

$catMatches = [regex]::Matches($text, "@\{ Key='([^']+)';?\s+Label='([^']+)';[^}]*Folder='([^']+)'")
$categories = foreach ($m in $catMatches) {
    [PSCustomObject]@{
        Key    = $m.Groups[1].Value
        Label  = $m.Groups[2].Value -replace '\^&', '&'
        Folder = $m.Groups[3].Value
    }
}

$appMatches = [regex]::Matches($text, "@\{ F='([^']+)'; B='([^']+)';?\s+N='([^']+)';?\s+P='([^']+)' \}")
$apps = foreach ($m in $appMatches) {
    [PSCustomObject]@{
        F = $m.Groups[1].Value
        B = $m.Groups[2].Value
        N = $m.Groups[3].Value
        Path = "Winget\Apps\$($m.Groups[1].Value)\Winget-Install-$($m.Groups[2].Value).bat"
    }
}

$total = $apps.Count
$sb = [System.Text.StringBuilder]::new()
[void]$sb.AppendLine('# Preset Example - how preset bundles work (reference only; not installed from the menu)')
[void]$sb.AppendLine('#')
[void]$sb.AppendLine('# Presets are plain-text lists of WinGet install script paths. The launcher runs them in')
[void]$sb.AppendLine('# order when you choose  W -> P -> [1] through [4].  Edit presets with  W -> P -> E1-E4.')
[void]$sb.AppendLine('#')
[void]$sb.AppendLine('# RULES')
[void]$sb.AppendLine('# -----')
[void]$sb.AppendLine('#   * One script path per line, relative to the Tools\ folder (see paths below).')
[void]$sb.AppendLine('#   * Lines starting with # are skipped - use for notes AND for apps you do not want yet.')
[void]$sb.AppendLine('#   * Blank lines are ignored.')
[void]$sb.AppendLine('#   * To ENABLE an app: remove the leading # so the line begins with Winget\')
[void]$sb.AppendLine('#   * To DISABLE an app: add # at the very beginning of the line.')
[void]$sb.AppendLine('#   * Section headers like "# --- Browsers ---" are comments only.')
[void]$sb.AppendLine('#   * Optional: add your own comment lines anywhere (must start with #).')
[void]$sb.AppendLine('#   * Do not put comments on the same line as a path - uncommented paths must be path-only.')
[void]$sb.AppendLine('#')
[void]$sb.AppendLine('# GETTING STARTED')
[void]$sb.AppendLine('# ---------------')
[void]$sb.AppendLine('#   1. Open Preset-1.txt through Preset-4.txt (or copy from this file into one of them).')
[void]$sb.AppendLine('#   2. Uncomment only the apps you want in that bundle (delete # at line start).')
[void]$sb.AppendLine('#   3. Save, then run  MaintenanceLauncher.bat  ->  W  ->  P  ->  [1-4].')
[void]$sb.AppendLine('#')
[void]$sb.AppendLine('# WORKED EXAMPLE - if these three lines were in Preset-1.txt WITHOUT a leading #,')
[void]$sb.AppendLine('# the launcher would install Chrome, then VLC, then 7-Zip, in that order:')
[void]$sb.AppendLine('#')
[void]$sb.AppendLine('#   Winget\Apps\Browsers\Winget-Install-Chrome.bat')
[void]$sb.AppendLine('#   Winget\Apps\Media\Winget-Install-VLC.bat')
[void]$sb.AppendLine('#   Winget\Apps\SystemTools\Winget-Install-7Zip.bat')
[void]$sb.AppendLine('#')
[void]$sb.AppendLine("# FULL CATALOG ($total apps) - everything commented out; uncomment what you need")
[void]$sb.AppendLine('#')

foreach ($cat in $categories) {
    $catApps = $apps | Where-Object { $_.F -eq $cat.Folder } | Sort-Object N
    if (-not $catApps) { continue }
    [void]$sb.AppendLine("# --- $($cat.Label) ---")
    foreach ($a in $catApps) {
        [void]$sb.AppendLine("# $($a.Path)")
    }
    [void]$sb.AppendLine('')
}

$utf8 = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($outPath, $sb.ToString().TrimEnd() + "`r`n", $utf8)
Write-Host "Wrote Preset-Example.txt ($total apps, all commented)"
