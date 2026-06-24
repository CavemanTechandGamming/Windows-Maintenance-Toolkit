# Regenerate Install-Wishlist.md from catalog (local file; gitignored)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'Get-ToolkitRoot.ps1')
$Root = Get-ToolkitRoot
$rowsPath = Join-Path $PSScriptRoot '_generated\wishlist-rows.txt'
if (-not (Test-Path -LiteralPath $rowsPath)) {
    Write-Error "Missing $rowsPath - run Rebuild-AppsCatalog.ps1 first."
}
$rows = (Get-Content -LiteralPath $rowsPath -Raw).TrimEnd()

$template = @'
# WinGet Install Wishlist

Apps tracked for the maintenance launcher (`W -> I -> Install Apps`).

**How to use this file**
- Add new apps to **Ideas** or **Pending** as you think of them.
- Verify the package ID with `winget search <name>` or launcher **`W -> [6] Search`**.
- When an app is added to the toolkit, move it to **Already in toolkit**.

---

## Pending

_None - queue apps here before adding them to Rebuild-AppsCatalog.ps1._

---

## Already in toolkit

| App | Package ID | Category |
|-----|------------|----------|
{{ROWS}}

**[A] Install EVERYTHING** covers all catalog packages. Menu keys change when apps are added - use the launcher (`W -> I`) for current numbers.

---

## Ideas (candidates for a future catalog update)

Track apps here before adding them to `Rebuild-AppsCatalog.ps1`. Verify package IDs with `winget search` or **`W -> [6] Search`**.

| App | WinGet package ID | Category | Notes |
|-----|-------------------|----------|-------|
| Adobe Acrobat Reader (64-bit) | `Adobe.Acrobat.Reader.64-bit` | Office & Documents | vs Sumatra PDF (in toolkit) |
| Everything | `voidtools.Everything` | System Tools | Instant filename search |
| Freelens | `Freelensapp.Freelens` | Virtualization & Containers | Kubernetes GUI |
| Mullvad VPN | `MullvadVPN.MullvadVPN` | Security & Privacy | Paid privacy VPN |
| Parsec | `Parsec.Parsec` | Network & Remote | Low-latency remote desktop |
| Podman | `RedHat.Podman` | Virtualization & Containers | Docker alternative |
| ZoomIt | `Microsoft.Sysinternals.ZoomIt` | System Tools | Screen zoom for support calls |

### Not in WinGet (or Store-only - skip for launcher scripts)

| App | Status | Notes |
|-----|--------|-------|
| Audiobookshelf | Not in WinGet | Docker or community Windows installer |
| NVIDIA App (driver suite) | Microsoft Store only | Install manually from NVIDIA |
| Microsoft PC Manager | Microsoft Store only | No winget package |
| FileZilla | Not in WinGet | Use WinSCP (in toolkit) or manual install |
| Proton VPN | Not in WinGet | Manual download |
| DaVinci Resolve | Not in WinGet | Manual download; very large |
| AMD Adrenalin (consumer) | Not in WinGet | Use AMD.com or Snappy |

### Declined

| App | WinGet package ID | Reason |
|-----|-------------------|--------|
| Spotify | `Spotify.Spotify` | Declined - not adding to toolkit |
'@

$content = $template.Replace('{{ROWS}}', $rows)

$utf8 = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText((Join-Path $Root 'Install-Wishlist.md'), $content, $utf8)
Write-Host 'Wishlist updated: Install-Wishlist.md'
