# Rebuild app catalog fragments and merge them into MaintenanceLauncher.bat
$ErrorActionPreference = 'Stop'
& (Join-Path $PSScriptRoot 'Rebuild-AppsCatalog.ps1')
& (Join-Path $PSScriptRoot 'Merge-LauncherFragments.ps1')
