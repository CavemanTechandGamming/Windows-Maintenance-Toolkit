$ErrorActionPreference = 'Stop'
$Root = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$rows = (Get-Content -LiteralPath (Join-Path $Root 'Tools\Winget\_generated\wishlist-rows.txt') -Raw).TrimEnd()

$content = @"
# WinGet Install Wishlist

Apps tracked for the maintenance launcher (``W -> I -> Install Apps``).

**How to use this file**
- Add new apps to **Ideas** or **Pending** as you think of them.
- Verify the package ID with ``winget search <name>`` or launcher **``W -> [6] Search``**.
- When an app is added to the toolkit, move it to **Already in toolkit**.

---

## Pending

_None — all approved apps from candidate review are implemented (102 total, 13 categories)._

---

## Already in toolkit

| App | Package ID | Category |
|-----|------------|----------|
$rows

**Install ALL** rows per category and **[A] Install EVERYTHING** cover all 102 packages. Menu keys change when apps are added — use the launcher (``W -> I``) for current numbers.

---

## Ideas (still undecided in review)

Still open in ``WinGet-Candidate-Review.md`` — mark Yes/No there, then re-process.

| App | WinGet package ID | Category | Notes |
|-----|-------------------|----------|-------|
| Adobe Acrobat Reader (64-bit) | ``Adobe.Acrobat.Reader.64-bit`` | Office & Documents | vs Sumatra PDF (in toolkit) |
| Everything | ``voidtools.Everything`` | System Tools | Instant filename search |
| Freelens | ``Freelensapp.Freelens`` | Virtualization & Containers | Kubernetes GUI |
| Mullvad VPN | ``MullvadVPN.MullvadVPN`` | Security & Privacy | Paid privacy VPN |
| Parsec | ``Parsec.Parsec`` | Network & Remote | Low-latency remote desktop |
| Podman | ``RedHat.Podman`` | Virtualization & Containers | Docker alternative |
| ZoomIt | ``Microsoft.Sysinternals.ZoomIt`` | System Tools | Screen zoom for support calls |

### Not in WinGet (or Store-only — skip for launcher scripts)

| App | Status | Notes |
|-----|--------|-------|
| Audiobookshelf | Not in WinGet | Docker or [community Windows installer](https://github.com/mikiher/audiobookshelf-windows) |
| NVIDIA App (driver suite) | Microsoft Store only | Install manually from NVIDIA |
| Microsoft PC Manager | Microsoft Store only | No winget package |
| FileZilla | Not in WinGet | Use WinSCP (in toolkit) or manual install |
| Proton VPN | Not in WinGet | Manual download |
| DaVinci Resolve | Not in WinGet | Manual download; very large |
| AMD Adrenalin (consumer) | Not in WinGet | Use AMD.com or Snappy |

### Declined in review

| App | WinGet package ID | Reason |
|-----|-------------------|--------|
| Spotify | ``Spotify.Spotify`` | No — declined in candidate review |
"@

Set-Content -LiteralPath (Join-Path $Root 'Install-Wishlist.md') -Value $content -Encoding UTF8
Write-Host 'Wishlist updated.'
