# Maintainer scripts (`Tools\Winget\dev`)

PowerShell utilities for updating the **Install Apps** catalog and splicing generated menu fragments into `MaintenanceLauncher.bat`. These scripts are **not** called at runtime — technicians only run `MaintenanceLauncher.bat`.

**This folder is part of the GitHub repository** so contributors can rebuild menus and add apps. Only `_generated\` (build output) is gitignored. For contribution workflow and PR guidelines, see **[CONTRIBUTING.md](../../../CONTRIBUTING.md)** at the repo root.

## Quick reference

| Script | Purpose |
|--------|---------|
| `Rebuild-And-Merge.ps1` | **One-step workflow** — rebuild catalog + merge into launcher |
| `Rebuild-AppsCatalog.ps1` | Regenerate per-app `.bat` files, menu fragments, and `wishlist-rows.txt` |
| `Merge-LauncherFragments.ps1` | Splice `_generated\*.fragment.bat` into `MaintenanceLauncher.bat` |
| `Update-Wishlist.ps1` | Refresh local `Install-Wishlist.md` from `wishlist-rows.txt` (gitignored) |
| `Emit-WishlistTable.ps1` | Print markdown table rows for the wishlist (used by rebuild) |
| `Emit-PresetExample.ps1` | Regenerate `Presets\Preset-Example.txt` (used by rebuild) |
| `Get-ToolkitRoot.ps1` | Shared helper — resolves repo root from this folder |

Generated build output goes to `_generated\` (gitignored). Do not edit fragment files by hand; change the catalog and re-run rebuild.

## Prerequisites

- Windows 10/11 with PowerShell 5.1 or later
- Repository cloned locally; run commands from the **repo root** (or use full paths below)
- For new apps: confirm package ID first — `winget search <name> --accept-source-agreements`

## Standard workflow: add or change an app

1. **Edit the catalog** in `Rebuild-AppsCatalog.ps1` — add or update an entry in the `$Apps` array:

   ```powershell
   @{ F='Browsers'; B='brave'; N='Brave'; P='Brave.Brave' }
   ```

   - `F` — category folder name under `Tools\Winget\Apps\`
   - `B` — short key (used in script names and sequence labels)
   - `N` — display name on the Install Apps menu
   - `P` — WinGet package ID

2. **Rebuild and merge** (from repo root):

   ```powershell
   powershell -ExecutionPolicy Bypass -File Tools\Winget\dev\Rebuild-And-Merge.ps1
   ```

   Or run the two steps separately:

   ```powershell
   powershell -ExecutionPolicy Bypass -File Tools\Winget\dev\Rebuild-AppsCatalog.ps1
   powershell -ExecutionPolicy Bypass -File Tools\Winget\dev\Merge-LauncherFragments.ps1
   ```

3. **Test** — run `MaintenanceLauncher.bat` as administrator → `W` → `I`. Confirm numbering, category headers, and a sample install.

4. **Optional** — refresh your local wishlist tracker:

   ```powershell
   powershell -ExecutionPolicy Bypass -File Tools\Winget\dev\Update-Wishlist.ps1
   ```

5. **Commit** — include changes to `MaintenanceLauncher.bat`, any new/changed `Tools\Winget\Apps\**\*.bat`, and `Rebuild-AppsCatalog.ps1` if the catalog changed. Do not commit `_generated\` or `Install-Wishlist.md`.

## What `Rebuild-AppsCatalog.ps1` does

1. Ensures each app has `Tools\Winget\Apps\<Category>\Winget-Install-<Name>.bat` (creates from template if missing).
2. Writes fragment files to `_generated\`:
   - `AppsMenuHeader.fragment.bat` — `:AppsMenu` / `:AppsLoop` header and console sizing
   - `AppsBanner.fragment.bat` — Install Apps title banner
   - `AppsMenu.fragment.bat` — flat 4-column menu body (`[1]`–`[N]`, `[A]` Install EVERYTHING)
   - `SeqInstall.fragment.bat` — `:SeqInstallAllApps` bulk sequence
   - `wishlist-rows.txt` — markdown rows for `Update-Wishlist.ps1`
3. Leaves `AppsCategoryMenus.fragment.bat` empty (legacy; category submenus removed).
4. Regenerates `Tools\Winget\Presets\Preset-Example.txt` via `Emit-PresetExample.ps1`.

Menu layout: **140×65** console, categories A→Z, apps A→Z within each category, global keys `1`–`N` across the full list.

## What `Merge-LauncherFragments.ps1` does

Reads `MaintenanceLauncher.bat`, replaces the block from `:AppsMenu` through the Install Apps loop tail, and replaces `:SeqInstallAllApps` (or legacy `:SeqInstallBrowsers`) through the sequence footer. Writes the launcher back as **UTF-8 without BOM**.

**Critical:** Never save `MaintenanceLauncher.bat` with a UTF-8 BOM. A BOM breaks `@echo off` in `cmd.exe` and corrupts the main menu. Use the merge script or `[System.IO.File]::WriteAllLines` with `UTF8Encoding $false` — not `Set-Content -Encoding UTF8` or `Out-File -Encoding utf8`.

## Category folder names

| Folder | Menu label |
|--------|------------|
| `Browsers` | BROWSERS |
| `Communication` | COMMUNICATION |
| `DevTools` | DEVELOPER |
| `Games` | GAMES |
| `Hardware` | HARDWARE & DIAGNOSTICS |
| `Languages` | LANGUAGES |
| `Media` | MEDIA |
| `NetworkRemote` | NETWORK & REMOTE |
| `Office` | OFFICE & DOCUMENTS |
| `Runtimes` | RUNTIMES & FRAMEWORKS |
| `Security` | SECURITY & PRIVACY |
| `SystemTools` | SYSTEM TOOLS |
| `Virtualization` | VIRTUALIZATION & CONTAINERS |

## Manual edits (when rebuild is not enough)

- **Main menu, WinGet submenu, presets, repair/disk tools** — edit `MaintenanceLauncher.bat` directly; merge only touches Install Apps + `SeqInstallAllApps`.
- **Preset bundles** — edit `Tools\Winget\Presets\Preset-1.txt` … `Preset-4.txt` (paths relative to `Tools\`).
- **Per-app install behavior** — edit the individual `Winget-Install-*.bat` under `Apps\<Category>\`. Rebuild does not overwrite existing install scripts.

## Troubleshooting

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| Main menu shows garbled first line / `@echo` visible | UTF-8 BOM on launcher | Re-merge from fragments; ensure UTF-8 **no BOM** |
| Menu keys don’t match apps | Forgot merge after rebuild | Run `Merge-LauncherFragments.ps1` |
| `Update-Wishlist.ps1` fails | No `wishlist-rows.txt` | Run `Rebuild-AppsCatalog.ps1` first |
| New app missing from menu | Not in `$Apps` or wrong `F` folder | Fix catalog entry and rebuild |

## Files intentionally not in this folder

One-off repair, encoding debug, and banner experiments were removed from the repo. Runtime behavior lives in `MaintenanceLauncher.bat` and `Tools\Winget\Apps\`. Presets stay in `Tools\Winget\Presets\`.
