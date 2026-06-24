# Install Apps — Proposed Category Layout

**Purpose:** Preview how the WinGet **Install Apps** menu could be reorganized so someone unfamiliar with the project can find software quickly.

**Scope:** Maps all **55 apps already in the toolkit**, **49 Pending** from the wishlist, and **7 still undecided** in the candidate review. Nothing here changes the launcher yet — this is for your review only.

---

## At a glance


|                   | Current                                  | Proposed                                                                                                       |
| ----------------- | ---------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| **Categories**    | 10                                       | 13                                                                                                             |
| **Apps today**    | 55                                       | 55 (same apps, new homes)                                                                                      |
| **After Pending** | would cram ~104 into old buckets         | ~104 sorted into clearer buckets                                                                               |
| **Biggest fix**   | `Utility` is a catch-all (24 apps today) | Split into **System Tools**, **Hardware & Diagnostics**, **Network & Remote**, **Virtualization & Containers** |


### Category renames (plain English)


| Current name   | Proposed menu label                     | Folder name (`Tools\Winget\Apps\`)                                                                    |
| -------------- | --------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| Game Launchers | **Games**                               | `Games\` *(rename from `GameLaunchers\`)*                                                             |
| Productivity   | **Office & Documents**                  | `Office\` *(rename from `Productivity\`)*                                                             |
| Dev Tools      | **Developer**                           | `DevTools\` *(unchanged)*                                                                             |
| Drivers        | *(merged)*                              | → **Hardware & Diagnostics**                                                                          |
| Utility        | *(split)*                               | → **System Tools**, **Hardware & Diagnostics**, **Network & Remote**, **Virtualization & Containers** |
| —              | **Security & Privacy** *(new)*          | `Security\`                                                                                           |
| —              | **Hardware & Diagnostics** *(new)*      | `Hardware\`                                                                                           |
| —              | **System Tools** *(new)*                | `SystemTools\`                                                                                        |
| —              | **Network & Remote** *(new)*            | `NetworkRemote\`                                                                                      |
| —              | **Virtualization & Containers** *(new)* | `Virtualization\`                                                                                     |


**Unchanged:** Browsers, Communication, Languages, Media, Runtimes

---

## How it would look on the menu

Each category gets a **one-line subtitle** under the heading (example mockup):

```
── BROWSERS ──  Get online
   [1] Brave    [2] Chrome    [3] Firefox    ...

── SECURITY & PRIVACY ──  Passwords and protection
   [n] Bitwarden    [n] Malwarebytes    ...

── SYSTEM TOOLS ──  Zip, clean, uninstall, USB boot media
   [n] 7-Zip    [n] Revo Uninstaller    ...
```

Categories appear in **A→Z order** by label (same convention as today).

---

## Proposed categories (full app map)

Legend: **bold** = already in toolkit · *(Pending)* = approved, not implemented yet · *(?)* = still undecided in review

---

### 1. Browsers

*Subtitle: Web browsers*


| App             | Status      |
| --------------- | ----------- |
| Brave           | in toolkit  |
| Google Chrome   | in toolkit  |
| Mozilla Firefox | in toolkit  |
| LibreWolf       | *(Pending)* |
| Opera GX        | *(Pending)* |


**Count:** 5 now → **7** after Pending

---

### 2. Communication

*Subtitle: Chat, email, and video calls*


| App                 | Status      |
| ------------------- | ----------- |
| Discord             | in toolkit  |
| Telegram            | in toolkit  |
| Microsoft Teams     | *(Pending)* |
| Slack               | *(Pending)* |
| Signal              | *(Pending)* |
| Mozilla Thunderbird | *(Pending)* |
| Zoom Workplace      | *(Pending)* |


**Count:** 2 → **8**

---

### 3. Developer

*Subtitle: Code editors, IDEs, and build tools*  
*(Renamed from “Dev Tools” — no overlap with homelab/Kubernetes)*


| App                          | Status     |
| ---------------------------- | ---------- |
| CMake                        | in toolkit |
| Cursor                       | in toolkit |
| Git                          | in toolkit |
| GitHub Desktop               | in toolkit |
| IntelliJ IDEA (Community)    | in toolkit |
| Visual Studio Code           | in toolkit |
| Visual Studio Community 2022 | in toolkit |
| Visual Studio Community 2026 | in toolkit |


**Count:** 8 → **8** *(unchanged)*

---

### 4. Games

*Subtitle: Game stores and platforms*  
*(Renamed from “Game Launchers”)*

*Note: **Moonlight** and **Parsec** (Pending / undecided) live here — remote play for games, not general IT remote access.*


| App                 | Status      |
| ------------------- | ----------- |
| Epic Games Launcher | in toolkit  |
| itch.io             | in toolkit  |
| Steam               | in toolkit  |
| Battle.net          | *(Pending)* |
| EA app              | *(Pending)* |
| GOG Galaxy          | *(Pending)* |
| NVIDIA GeForce NOW  | *(Pending)* |
| Ubisoft Connect     | *(Pending)* |
| Moonlight           | *(Pending)* |
| Parsec              | *(?)*       |


**Count:** 3 → **9–10**

---

### 5. Hardware & Diagnostics

*Subtitle: Drivers, temps, disk health, and GPU tools*  
*(New — absorbs **Drivers** + hardware slice of old **Utility**)*


| App                            | Status                            |
| ------------------------------ | --------------------------------- |
| Snappy Driver Installer Origin | in toolkit *(was Drivers)*        |
| MSI Afterburner                | in toolkit *(moved from Utility)* |
| CPU-Z                          | *(Pending)*                       |
| CrystalDiskInfo                | *(Pending)*                       |
| CrystalDiskMark                | *(Pending)*                       |
| Display Driver Uninstaller     | *(Pending)*                       |
| FanControl                     | *(Pending)*                       |
| GPU-Z                          | *(Pending)*                       |
| HWiNFO                         | *(Pending)*                       |
| HWMonitor                      | *(Pending)*                       |
| OpenRGB                        | *(Pending)*                       |


**Count:** 2 → **11**

---

### 6. Languages

*Subtitle: Runtimes for coding — Python, Node, Java, etc.*


| App                  | Status     |
| -------------------- | ---------- |
| Go                   | in toolkit |
| Node.js (Current)    | in toolkit |
| Node.js (LTS)        | in toolkit |
| Microsoft OpenJDK 21 | in toolkit |
| Microsoft OpenJDK 25 | in toolkit |
| Python               | in toolkit |
| Rust (MSVC)          | in toolkit |


**Count:** 7 → **7** *(unchanged)*

---

### 7. Media

*Subtitle: Watch, listen, record, and stream*


| App                   | Status                                       |
| --------------------- | -------------------------------------------- |
| AIMP                  | in toolkit                                   |
| Blender               | in toolkit *(moved from Office & Documents)* |
| HandBrake             | in toolkit                                   |
| Jellyfin Media Player | in toolkit                                   |
| Jellyfin Server       | in toolkit                                   |
| OBS Studio            | in toolkit                                   |
| Plex Desktop          | in toolkit                                   |
| Plex Media Server     | in toolkit                                   |
| VLC                   | in toolkit                                   |


**Count:** 8 → **9** *(+ Blender)*

---

### 8. Network & Remote

*Subtitle: VPN, SSH, and network troubleshooting*  
*(New — split from **Utility**; game streaming clients are under **Games**)*


| App       | Status      |
| --------- | ----------- |
| PuTTY     | *(Pending)* |
| WinSCP    | *(Pending)* |
| Tailscale | *(Pending)* |
| WireGuard | *(Pending)* |
| Wireshark | *(Pending)* |
| Nmap      | *(Pending)* |


**Count:** 0 → **6**

---

### 9. Office & Documents

*Subtitle: Office suite, PDFs, notes, and image/design apps*  
*(Renamed from “Productivity”; **Blender** moved to **Media**)*


| App                           | Status      |
| ----------------------------- | ----------- |
| Audacity                      | in toolkit  |
| GIMP                          | in toolkit  |
| LibreOffice                   | in toolkit  |
| Notepad++                     | in toolkit  |
| Inkscape                      | *(Pending)* |
| Krita                         | *(Pending)* |
| Paint.NET                     | *(Pending)* |
| Sumatra PDF                   | *(Pending)* |
| Adobe Acrobat Reader (64-bit) | *(?)*       |


**Count:** 5 → **8–9**

---

### 10. Runtimes

*Subtitle: Required by many apps — install first on fresh PCs*


| App                     | Status     |
| ----------------------- | ---------- |
| .NET Desktop Runtime 6  | in toolkit |
| .NET Desktop Runtime 8  | in toolkit |
| .NET Desktop Runtime 9  | in toolkit |
| .NET Desktop Runtime 10 | in toolkit |
| PowerShell 7            | in toolkit |
| VC++ Redistributables   | in toolkit |
| WebView2 Runtime        | in toolkit |


**Count:** 7 → **7** *(unchanged)*

---

### 11. Security & Privacy

*Subtitle: Antimalware, passwords, and VPN*  
*(New category)*


| App          | Status      |
| ------------ | ----------- |
| Bitwarden    | *(Pending)* |
| KeePass      | *(Pending)* |
| Malwarebytes | *(Pending)* |
| Mullvad VPN  | *(?)*       |


**Count:** 0 → **3–4**

---

### 12. System Tools

*Subtitle: Zip, uninstall, search, screenshots, and USB boot media*  
*(New — main slice of old **Utility**)*


| App                   | Status      |
| --------------------- | ----------- |
| 7-Zip                 | in toolkit  |
| Balena Etcher         | in toolkit  |
| Bulk Crap Uninstaller | in toolkit  |
| Microsoft PowerToys   | in toolkit  |
| qBittorrent           | in toolkit  |
| Revo Uninstaller      | in toolkit  |
| Rufus                 | in toolkit  |
| Ventoy                | in toolkit  |
| WinRAR                | in toolkit  |
| Autoruns              | *(Pending)* |
| Process Explorer      | *(Pending)* |
| Rainmeter             | *(Pending)* |
| ShareX                | *(Pending)* |
| WizTree               | *(Pending)* |
| Everything            | *(?)*       |
| ZoomIt                | *(?)*       |


**Count:** 9 → **15–16**

---

### 13. Virtualization & Containers

*Subtitle: VMs, Docker, and Kubernetes — homelab territory*  
*(New — split from **Utility** + infra **Dev Tools**)*


| App            | Status                            |
| -------------- | --------------------------------- |
| Docker Desktop | in toolkit *(moved from Utility)* |
| Freelens       | *(?)*                             |
| Helm           | *(Pending)*                       |
| k9s            | *(Pending)*                       |
| kubectl        | *(Pending)*                       |
| Minikube       | *(Pending)*                       |
| Podman         | *(?)*                             |
| Terraform      | *(Pending)*                       |
| Vagrant        | *(Pending)*                       |
| VirtualBox     | *(Pending)*                       |


**Count:** 1 → **9–10**

---

## Summary by category (after Pending)


| #   | Category                    | Now    | + Pending | + If all (?) approved | Max     |
| --- | --------------------------- | ------ | --------- | --------------------- | ------- |
| 1   | Browsers                    | 5      | 7         | 7                     | 7       |
| 2   | Communication               | 2      | 8         | 8                     | 8       |
| 3   | Developer                   | 8      | 8         | 8                     | 8       |
| 4   | Games                       | 3      | 9         | 10                    | 10      |
| 5   | Hardware & Diagnostics      | 2      | 11        | 11                    | 11      |
| 6   | Languages                   | 7      | 7         | 7                     | 7       |
| 7   | Media                       | 8      | 9         | 9                     | 9       |
| 8   | Network & Remote            | 0      | 6         | 6                     | 6       |
| 9   | Office & Documents          | 5      | 8         | 9                     | 9       |
| 10  | Runtimes                    | 7      | 7         | 7                     | 7       |
| 11  | Security & Privacy          | 0      | 3         | 4                     | 4       |
| 12  | System Tools                | 9      | 14        | 16                    | 16      |
| 13  | Virtualization & Containers | 1      | 9         | 10                    | 10      |
|     | **Total**                   | **55** | **104**   | **111**               | **111** |


Largest categories after reorganize: **System Tools (~16)**, **Hardware & Diagnostics (~11)**, **Virtualization (~10)** — still big, but each has a clear “job description.” Old **Utility** alone would have been **~40+** apps.

---

## What moves out of old “Utility” (24 apps today)


| App                                                                               | Goes to                         |
| --------------------------------------------------------------------------------- | ------------------------------- |
| 7-Zip, WinRAR, PowerToys, Revo, BCUninstaller, Etcher, Rufus, Ventoy, qBittorrent | **System Tools**                |
| MSI Afterburner                                                                   | **Hardware & Diagnostics**      |
| Docker Desktop                                                                    | **Virtualization & Containers** |
| *(all Pending/utility apps)*                                                      | See categories above            |


---

## Minimal vs full proposal

If 13 categories feels like too much menu real estate, a **minimal** version keeps 10 categories but still fixes the worst pain:


| Minimal change                                                            | Effect                                                               |
| ------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| Add **Security & Privacy** only                                           | Malwarebytes, Bitwarden, KeePass have a home                         |
| Rename **Games**, **Office & Documents**, **Developer**                   | Plain English                                                        |
| Split **Utility** into **System Tools** + **Hardware & Diagnostics** only | Cuts Utility in half; VPN/SSH/K8s stay in System Tools until phase 2 |


The **full 13-category layout** in this document is the recommended end state once Pending apps are implemented.

---

## Your feedback

**Recorded decisions (approved):**

- [x] Approve **full 13-category** layout  
- [ ] Prefer **minimal 4-change** layout first  
- [ ] Rename tweaks (e.g. “Office & Documents” → something else)  
- [x] Move specific apps — **Moonlight** and **Parsec** → **Games**; **Blender** → **Media**

When you are ready to refactor folders, scripts, and the launcher menu, say **implement the category layout**.

---

*Related files: `Install-Wishlist.md` (Pending queue) · `WinGet-Candidate-Review.md` (undecided apps)*