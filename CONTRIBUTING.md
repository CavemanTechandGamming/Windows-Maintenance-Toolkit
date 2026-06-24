# Contributing to Windows Maintenance Toolkit

Thank you for your interest in contributing. This project is a practical Windows maintenance and WinGet deployment toolkit used on real machines — clear menus, safe defaults, and reproducible builds matter.

## Table of contents

- [Code of conduct](#code-of-conduct)
- [Ways to contribute](#ways-to-contribute)
- [Development setup](#development-setup)
- [What belongs in the repository](#what-belongs-in-the-repository)
- [Pull request workflow](#pull-request-workflow)
- [Adding a WinGet application](#adding-a-winget-application)
- [Adding or changing maintenance tools](#adding-or-changing-maintenance-tools)
- [Coding conventions](#coding-conventions)
- [Testing your changes](#testing-your-changes)
- [Further reading](#further-reading)

## Code of conduct

Be respectful and constructive. This is a volunteer-maintained utility project. Assume good intent, keep feedback specific, and focus on what helps technicians use the toolkit safely.

## Ways to contribute

You can help without writing code:

- **Report bugs** — menu glitches, script failures, wrong package IDs, encoding issues.
- **Suggest apps** — open an issue with the app name, proposed WinGet package ID (`winget search` output), and category.
- **Improve documentation** — README clarity, CONTRIBUTING gaps, preset examples.
- **Submit pull requests** — bug fixes, new apps, new maintenance scripts, preset updates.

Use [GitHub Issues](https://github.com/CavemanTechandGamming/Windows-Maintenance-Toolkit/issues) for bugs and feature requests. For app suggestions, include the verified package ID when possible.

## Development setup

1. **Fork and clone** the repository.
2. **Requirements:** Windows 10 (1809+) or Windows 11, PowerShell 5.1+, administrator access for testing.
3. **No install step** — the toolkit runs in place from the repo root.
4. **WinGet** — install or update via the launcher (`W` → `1`–`3`) if you will test package installs.

Clone example:

```powershell
git clone https://github.com/<your-user>/Windows-Maintenance-Toolkit.git
cd Windows-Maintenance-Toolkit
```

## What belongs in the repository

| Path | Commit? | Notes |
|------|---------|-------|
| `MaintenanceLauncher.bat` | **Yes** | Main entry point; updated by merge after catalog changes |
| `Tools\Winget\dev\` | **Yes** | Maintainer PowerShell + `dev\README.md` (see script list below) |
| `Tools\Winget\Apps\**\Winget-Install-*.bat` | **Yes** | Per-app install scripts |
| `Tools\Winget\Presets\` | **Yes** | `Preset-1.txt` … `Preset-4.txt` and `Preset-Example.txt` |
| `Tools\Repair\`, `Disk\`, `Cleanup\`, `Network\` | **Yes** | Maintenance tool scripts |
| `README.md`, `CONTRIBUTING.md` | **Yes** | Project documentation |
| `Tools\Winget\dev\_generated\` | **No** | Build output; regenerate with `Rebuild-And-Merge.ps1` |
| `Tools\Winget\_generated\` | **No** | Deprecated build path (use `dev\_generated\`) |
| `Logs\`, `*.log` | **No** | Runtime session logs |
| `Install-Wishlist.md` | **No** | Local app queue / ideas tracker |
| `Install-Apps-Category-Proposal.md` | **No** | Completed planning doc (historical) |
| `WinGet-Candidate-Review.md` | **No** | Completed app review worksheet (historical) |
| `Legacy Cleanup\` | **No** | Superseded standalone `.bat` files (local archive) |
| `.cursor\` | **No** | Local IDE / AI rules |

**Maintainer scripts in `Tools\Winget\dev\` (all committed):**

| Script | Purpose |
|--------|---------|
| `Rebuild-And-Merge.ps1` | One-step catalog rebuild + launcher merge |
| `Rebuild-AppsCatalog.ps1` | App catalog source of truth; generates install scripts + fragments |
| `Merge-LauncherFragments.ps1` | Splices fragments into `MaintenanceLauncher.bat` |
| `Emit-PresetExample.ps1` | Regenerates `Preset-Example.txt` |
| `Emit-WishlistTable.ps1` | Wishlist table rows (used by rebuild) |
| `Update-Wishlist.ps1` | Refreshes local `Install-Wishlist.md` |
| `Get-ToolkitRoot.ps1` | Shared repo-root path helper |
| `README.md` | Technical reference for the scripts above |

**Yes — the `Tools\Winget\dev\` folder is meant to be on GitHub.** Contributors need those scripts to add apps and update the Install Apps menu. Only `_generated\` inside that folder is excluded (build artifacts, like `dist/`).

## Pull request workflow

1. Create a **topic branch** from `main` (e.g. `add-app-brave`, `fix-dns-flush-menu`).
2. Make focused changes — one logical change per PR when possible.
3. **Test on Windows** as administrator (see [Testing your changes](#testing-your-changes)).
4. **Commit** only tracked project files (see table above).
5. Open a pull request with:
   - **Summary** — what changed and why.
   - **Test plan** — what you ran and what you verified.
   - **Screenshots** — if the change affects menus or console layout.

We may ask for adjustments before merge. Small, well-tested PRs are reviewed faster.

## Adding a WinGet application

This is the most common contribution. Do **not** hand-edit hundreds of menu lines in `MaintenanceLauncher.bat` — use the maintainer scripts.

### 1. Verify the package

```powershell
winget search <app name> --accept-source-agreements
```

Confirm the exact **package ID** (e.g. `Brave.Brave`). Skip apps that are Store-only or not in WinGet unless the project explicitly adds manual-install support.

### 2. Add to the catalog

Edit `Tools\Winget\dev\Rebuild-AppsCatalog.ps1` — add an entry to the `$Apps` array:

```powershell
@{ F='Browsers'; B='brave'; N='Brave'; P='Brave.Brave' }
```

| Field | Meaning |
|-------|---------|
| `F` | Category folder under `Tools\Winget\Apps\` |
| `B` | Short key (script names, sequences) |
| `N` | Display name on Install Apps menu |
| `P` | WinGet package ID |

Valid category folders: `Browsers`, `Communication`, `DevTools`, `Games`, `Hardware`, `Languages`, `Media`, `NetworkRemote`, `Office`, `Runtimes`, `Security`, `SystemTools`, `Virtualization`.

### 3. Rebuild and merge

From the **repo root**:

```powershell
powershell -ExecutionPolicy Bypass -File Tools\Winget\dev\Rebuild-And-Merge.ps1
```

This regenerates install scripts (if missing), menu fragments, and merges them into `MaintenanceLauncher.bat`.

### 4. Customize install script (if needed)

Rebuild creates `Tools\Winget\Apps\<Category>\Winget-Install-<Name>.bat` from a template if the file does not exist. If the app needs special flags (scope, silent install, etc.), edit that `.bat` after rebuild. Rebuild does **not** overwrite existing install scripts.

### 5. Commit these files

- `Tools\Winget\dev\Rebuild-AppsCatalog.ps1` (catalog change)
- `MaintenanceLauncher.bat` (after merge)
- Any new or modified `Winget-Install-*.bat` files

Do **not** commit `Tools\Winget\dev\_generated\`.

## Adding or changing maintenance tools

For repair, disk, cleanup, or network scripts:

1. Add or edit `.bat` files under the matching `Tools\` subfolder (`Repair\`, `Disk\`, `Cleanup\`, `Network\`).
2. Wire the menu in `MaintenanceLauncher.bat` (`:MENU`, `:RunOne`, sequences as appropriate).
3. Use `:RunOne` for logged maintenance tools; use `:RunOneNoTee` for WinGet scripts (live progress bars).
4. Follow existing naming and pause/sequence patterns (`MAINT_NO_PAUSE=1` during chains).

## Editing preset bundles

Presets (`Tools\Winget\Presets\Preset-1.txt` … `Preset-4.txt`) are plain-text lists of install script paths, one per line, **relative to `Tools\`**.

| Syntax | Behavior |
|--------|----------|
| `Winget\Apps\...\Winget-Install-....bat` | Installed when preset runs |
| `# anything` | Ignored (comments and disabled apps) |
| Blank line | Ignored |

**To enable an app:** delete the `#` at the start of the line so it begins with `Winget\`.  
**To disable an app:** add `#` at the very beginning of the line.

**`Preset-Example.txt`** is a reference file (not installed from the menu). It lists all 102 toolkit apps, commented out, with instructions at the top. Copy lines into `Preset-1` … `Preset-4` as needed. It is regenerated automatically when you run `Rebuild-AppsCatalog.ps1` or `Rebuild-And-Merge.ps1` after catalog changes.

Test with `W` → `P` → install the preset you edited.

## Coding conventions

### Batch files (`MaintenanceLauncher.bat`, `Tools\**\*.bat`)

- **UTF-8 without BOM** for `MaintenanceLauncher.bat`. A UTF-8 BOM breaks `@echo off` in `cmd.exe` and corrupts the main menu. Use the merge script or save as UTF-8 no BOM in your editor.
- Admin elevation is handled once at launcher startup; child scripts inherit it.
- Console menus use **140×65** with `call :SetConsoleSize 65 LOCK`.
- Gold ANSI accents (`#DAA520`), black background (`color 0F`).

### PowerShell (maintainer scripts only)

- Scripts in `Tools\Winget\dev\` use `Get-ToolkitRoot.ps1` for repo-root resolution.
- Write launcher output with `[System.IO.File]::WriteAllLines` and `UTF8Encoding $false` — not `Set-Content -Encoding UTF8`.

### WinGet install scripts

- Naming: `Winget-Install-<Name>.bat` under `Tools\Winget\Apps\<Category>\`.
- Match patterns in existing scripts in the same category.

## Testing your changes

Minimum checks before opening a PR:

| Change type | What to test |
|-------------|----------------|
| **New/changed app** | `MaintenanceLauncher.bat` → `W` → `I` — correct number, name, category; sample install works |
| **Catalog rebuild** | Main menu and WinGet menu still render; no `@echo` or garbled first line |
| **Maintenance script** | Run from main menu; confirm log entry in `Logs\` |
| **Preset** | `W` → `P` → install preset; paths resolve under `Tools\` |
| **Sequence** | `R`, `L`, `N`, or `F` completes without spurious pauses |

Run the launcher **as administrator**. WinGet installs need network access and may require accepting agreements on first run.

## Further reading

- **[README.md](README.md)** — user-facing overview, menu reference, repository layout.
- **[Tools\Winget\dev\README.md](Tools/Winget/dev/README.md)** — maintainer script reference, merge behavior, troubleshooting.

Questions? Open an issue with the `question` label or describe your PR idea in a draft issue before large changes.
