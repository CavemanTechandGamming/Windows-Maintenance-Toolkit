# WinGet Candidate Review

**Purpose:** Review potential additions to the Windows Maintenance Toolkit before any scripts or menu entries are created.

**Current toolkit:** 55 apps across 10 categories (`W → I → Install Apps`).

**Status:** **49 apps approved** → moved to `Install-Wishlist.md` **Pending**. **1 declined** (Spotify). **7 still undecided** below.

**How to use this file**

1. Read the **Risk / concern** column for each undecided app.
2. In **Yes / No**, type **Yes** to add it, **No** to not add it, or **leave blank** if you are still deciding.
3. When ready, ask to **process the review file** again — Yes → wishlist Pending, No → removed, blank → stays here.

**Legend — risk level**

| Level      | Meaning                                                                            |
| ---------- | ---------------------------------------------------------------------------------- |
| **Low**    | Generally safe for broad bench use; few surprise side effects                      |
| **Medium** | Useful but adds background services, accounts, or needs user judgment              |
| **High**   | Powerful or easy to misuse; consider homelab/gamer-only or skip for public toolkit |

---

## Still undecided

| App                           | WinGet package ID                         | Category      | Preset fit | Risk   | Risk / concern                                                                                                                                                                                                                                                                                                                                                                   | Yes / No |
| ----------------------------- | ----------------------------------------- | ------------- | ---------- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| Everything                    | `voidtools.Everything`                    | Utility       | 2          | Low    | Indexes file names for near-instant search across all drives. **Why yes:** Finds configs, logs, and installers in seconds — huge bench time-saver. **Why no:** Optional background indexer uses some RAM; privacy users may dislike full-drive indexing (can run on-demand only). **Overlap:** Beats Windows Search for filename lookups.                                              |          |
| Adobe Acrobat Reader (64-bit) | `Adobe.Acrobat.Reader.64-bit`             | Productivity  | 2          | Medium | Industry-default PDF reader; opens protected and complex PDFs reliably. **Why yes:** Clients often ask for “Adobe PDF” by name — reduces support calls. **Why no:** Large install, occasional McAfee/Chrome-offer history (winget is cleaner); Sumatra already approved in Pending. **Overlap:** Sumatra PDF — consider picking one default or offer both.                         |          |
| ZoomIt                        | `Microsoft.Sysinternals.ZoomIt`           | Utility       | 2          | Low    | Screen zoom + draw-on-screen for presentations and phone support (“look at this corner”). **Why yes:** Tiny, no bloat, Microsoft-signed Sysinternals — great for remote walkthroughs. **Why no:** Niche; most home users never need it. **Overlap:** None; pairs with ShareX (already Pending) for capture vs live zoom.                                                           |          |
| Parsec                        | `Parsec.Parsec`                           | Utility       | 3          | Medium | Low-latency remote desktop built for gaming/co-op. **Why yes:** Play on a weak laptop streaming from your gaming PC; also used for remote bench access. **Why no:** Opens remote-control attack surface if account/password weak; requires Parsec host on the gaming machine. **Overlap:** Moonlight already Pending — similar use case, different stack.                            |          |
| Podman                        | `RedHat.Podman`                           | Utility       | 4          | Medium | Daemonless container engine — Docker-compatible CLI without Docker Desktop. **Why yes:** Lighter than Docker Desktop; no subscription concerns for some orgs. **Why no:** **Docker Desktop already in toolkit** — two container stacks confuses users; Podman on Windows is improving but still rougher than Linux. **Overlap:** Direct duplicate of Docker role.                 |          |
| Freelens                      | `Freelensapp.Freelens`                    | Dev Tools     | 4          | Medium | Open-source fork of Lens — GUI for Kubernetes clusters. **Why yes:** Visual pod/logs view beats raw kubectl for debugging. **Why no:** Stores cluster kubeconfigs locally; another Electron app; needs K8s cluster to be useful. **Overlap:** k9s already Pending — same audience, terminal vs GUI; pick one or both.                                                              |          |
| Mullvad VPN                   | `MullvadVPN.MullvadVPN`                   | Security      | 4          | Medium | Privacy-first VPN — account number, no email required. **Why yes:** Reputable no-log policy; simple client; good for homelab remote access privacy. **Why no:** **Paid (~€5/mo)** — not free; VPN legality/terms vary; Tailscale + WireGuard already Pending. **Overlap:** Three VPN tools is a lot on one menu.                                                                    |          |

---

## Deliberately excluded — known problems or not WinGet-ready

These appeared on common setup lists but are **not recommended** for this toolkit without manual process.

| App                           | Status                          | Why skip or handle manually                                                            |
| ----------------------------- | ------------------------------- | -------------------------------------------------------------------------------------- |
| **CCleaner**                  | In WinGet (`Piriform.CCleaner`) | Registry-cleaner reputation; marginal benefit; past security incidents                 |
| **NVIDIA App** (driver suite) | Microsoft Store only            | Not winget-script friendly; install from NVIDIA directly                               |
| **AMD Adrenalin** (consumer)  | Not in WinGet                   | Use AMD.com or Snappy Driver Installer already in toolkit                              |
| **Microsoft PC Manager**      | Microsoft Store only            | No winget package                                                                      |
| **FileZilla**                 | Not in WinGet                   | Use WinSCP (Pending) or manual install                                                 |
| **Proton VPN**                | Not in WinGet                   | Manual download                                                                        |
| **DaVinci Resolve**           | Not in WinGet                   | Manual download; very large                                                            |
| **Audiobookshelf**            | Not in WinGet                   | Docker or [community Windows build](https://github.com/mikiher/audiobookshelf-windows) |

---

## Overlap reference

| Already in toolkit                        | Related undecided / pending items                                              |
| ----------------------------------------- | ------------------------------------------------------------------------------ |
| Chrome, Firefox, Brave                    | LibreWolf, Opera GX (Pending)                                                  |
| Discord, Telegram                         | Teams, Slack, Signal, Zoom (Pending)                                           |
| GIMP, Blender, Audacity                   | Paint.NET, Krita, Inkscape (Pending)                                           |
| Docker Desktop                            | Podman (undecided), VirtualBox (Pending)                                       |
| MSI Afterburner                           | GPU-Z, HWiNFO, HWMonitor (Pending)                                             |
| Sumatra PDF                               | Adobe Reader (undecided) — both may be overkill                                 |

---

*Package IDs verified via `winget search`. Re-verify before implementation.*
