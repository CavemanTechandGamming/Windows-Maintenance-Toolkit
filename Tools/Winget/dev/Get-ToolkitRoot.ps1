# Shared path helper for maintainer scripts in Tools\Winget\dev\
function Get-ToolkitRoot {
    return (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
}
