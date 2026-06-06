# 🧹 DeepCacheCleaner

![Platform](https://img.shields.io/badge/Platform-Windows%2010%20%7C%2011-0078D4?style=for-the-badge&logo=windows)
![Language](https://img.shields.io/badge/Language-Batch%20Script-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)
![Version](https://img.shields.io/badge/Version-3.0-FF6B6B?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)
![Admin Required](https://img.shields.io/badge/Requires-Administrator-red?style=for-the-badge&logo=shield)

> **A deep, automated Windows cache cleaner that wipes 38 cache locations across 8 phases — including Windows Update leftovers, browser cache, app cache, crash dumps, event logs, and the WinSxS component store — then refreshes your PC 5 times.**

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [What Gets Cleaned](#-what-gets-cleaned)
- [Prerequisites](#-prerequisites)
- [How to Use](#-how-to-use)
- [Phase-by-Phase Breakdown](#-phase-by-phase-breakdown)
- [Important Warnings](#-important-warnings)
- [Frequently Asked Questions](#-frequently-asked-questions)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🔍 Overview

**DeepCacheCleaner** is a single-file Windows Batch script designed to perform a thorough, automated cleanup of your system with zero manual effort. Unlike basic disk cleanup tools, this script goes deep — it targets not just the standard `%TEMP%` folder, but also Windows Update residual files, the `WinSxS` component store, upgrade leftovers (`Windows.old`, `$Windows.~BT`), crash dumps, event logs, and cache from popular apps like Chrome, Discord, Spotify, and VS Code.

It safely **stops the relevant Windows services** before cleaning locked files, then **restores all services** after the cleanup is complete, ensuring no system functionality is broken. Finally, it **restarts Windows Explorer and sends 5 desktop refresh signals** to apply all visual changes immediately.

**Typical disk space reclaimed:** 2 GB – 30+ GB depending on system age and update history.

---

## ✨ Features

- **38 cache locations** cleaned across 8 structured phases
- **Auto-elevates** to Administrator — no manual right-clicking needed
- **Service-aware** — stops 8 Windows services before cleaning, restores them all after
- **Windows Update deep wipe** — removes downloaded update files, history database, `catroot2`, upgrade staging folders, and leftover old OS installations
- **DISM integration** — runs `StartComponentCleanup` to shrink the `WinSxS` folder
- **Multi-profile browser cleaning** — handles all Chrome, Edge, and Firefox user profiles automatically
- **App cache support** — cleans Teams, Discord, Spotify, VS Code, Office, and OneDrive
- **Crash dump & log cleanup** — removes memory dumps, WER reports, event logs, and driver logs
- **Explorer refresh** — restarts `explorer.exe` and sends 5 × F5 to apply all visual changes
- **Safe by design** — uses `>nul 2>&1` suppression so in-use files are silently skipped, never forced-deleted in a way that could corrupt open processes
- **No dependencies** — pure Batch + built-in Windows tools (`DISM`, `wevtutil`, `ipconfig`, `wsreset`, PowerShell)

---

## 🗂️ What Gets Cleaned

### Phase 2 — Core System Cache (Items 01–10)

| # | Target | Path |
|---|--------|------|
| 01 | User Temp folder | `%TEMP%` |
| 02 | Windows System Temp | `C:\Windows\Temp` |
| 03 | Prefetch cache | `C:\Windows\Prefetch` |
| 04 | Thumbnail cache | `%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db` |
| 05 | Icon cache | `%LocalAppData%\IconCache.db` + `iconcache_*.db` |
| 06 | DirectX Shader cache | `%LocalAppData%\D3DSCache` |
| 07 | Font cache | `%WinDir%\ServiceProfiles\LocalService\...\FontCache` |
| 08 | IE / Legacy Edge cache | `%LocalAppData%\Microsoft\Windows\INetCache` |
| 09 | Recent files list | `%AppData%\Microsoft\Windows\Recent` (+ AutomaticDestinations, CustomDestinations) |
| 10 | Recycle Bin | All drives |

### Phase 3 — Windows Update Deep Clean (Items 11–21)

| # | Target | Path / Notes |
|---|--------|------|
| 11 | Update downloaded files | `C:\Windows\SoftwareDistribution\Download` |
| 12 | Update history database | `C:\Windows\SoftwareDistribution\DataStore` |
| 13 | catroot2 signature cache | `C:\Windows\System32\catroot2` |
| 14 | Installer Patch Cache | `C:\Windows\Installer\$PatchCache$` |
| 15 | Delivery Optimization cache | `...\NetworkService\...\DeliveryOptimization` |
| 16 | Windows Update log files | `C:\Windows\WindowsUpdate.log` + `Logs\WindowsUpdate\` |
| 17 | `Windows.old` | Old OS installation — **can be 10–30 GB** — skipped if not present |
| 18 | `$Windows.~BT` | Upgrade temp files — skipped if not present |
| 19 | `$Windows.~WS` | Upgrade staging files — skipped if not present |
| 20 | CBS logs | `C:\Windows\Logs\CBS\` |
| 21 | Panther / Setup logs | `C:\Windows\Panther\` |

### Phase 4 — Crash Dumps, Logs & Error Reports (Items 22–26)

| # | Target | Path |
|---|--------|------|
| 22 | Memory dump files | `C:\Windows\MEMORY.DMP` + `C:\Windows\Minidump\` |
| 23 | Windows Error Reporting | `%LocalAppData%\Microsoft\Windows\WER` + `C:\ProgramData\Microsoft\Windows\WER` |
| 24 | Windows Event Logs | Application, System, Security, Setup, WindowsUpdateClient |
| 25 | Defender scan history | `C:\ProgramData\Microsoft\Windows Defender\Scans\History` |
| 26 | Driver installation logs | `C:\Windows\inf\setupapi.dev.log` + `setupapi.setup.log` |

### Phase 5 — Browser Cache (Items 27–29)

| # | Browser | What's cleared |
|---|---------|---------------|
| 27 | Google Chrome | Cache, Code Cache, GPUCache, Media Cache, Application Cache, Service Worker CacheStorage — **all profiles** |
| 28 | Microsoft Edge | Cache, Code Cache, GPUCache, Service Worker CacheStorage — **all profiles** |
| 29 | Mozilla Firefox | cache2, startupCache, shader-cache, OfflineCache, storage/default — **all profiles** |

### Phase 6 — App Cache (Items 30–37)

| # | App | What's cleared |
|---|-----|---------------|
| 30 | Microsoft Teams | Cache, blob_storage, databases, GPUCache, Code Cache, tmp |
| 31 | Discord | Cache, Code Cache, GPUCache |
| 32 | Spotify | Storage, Data |
| 33 | Microsoft Office | WebServiceCache, Recent, OTele |
| 34 | OneDrive | logs, setup/logs |
| 35 | VS Code | Cache, Code Cache, GPUCache, CachedExtensionVSIXs, logs |
| 36 | Windows Store | `wsreset.exe` — resets Store app cache |
| 37 | DNS Cache | `ipconfig /flushdns` |

### Phase 7 — DISM WinSxS Component Cleanup (Item 38)

| # | Operation | Details |
|---|-----------|---------|
| 38 | DISM StartComponentCleanup | Removes all superseded (old) Windows Update component versions from `C:\Windows\WinSxS`. This is the folder Windows uses to store component backups and is often 5–15 GB. DISM safely marks old versions for removal. |

---

## ⚙️ Prerequisites

| Requirement | Details |
|-------------|---------|
| **OS** | Windows 10 or Windows 11 |
| **Privileges** | Administrator (script auto-requests via UAC prompt) |
| **PowerShell** | Built into Windows — no installation needed |
| **DISM** | Built into Windows — no installation needed |
| **Internet** | Not required |

> No third-party tools, no installers, no dependencies. Everything used (`DISM`, `wevtutil`, `net`, `ipconfig`, `wsreset`, `takeown`, `icacls`, PowerShell) ships with Windows out of the box.

---

## 🚀 How to Use

### Method 1 — Recommended (Right-click)

1. Download `DeepCacheCleaner.bat`
2. **Right-click** the file
3. Select **"Run as administrator"**
4. Accept the UAC prompt if asked
5. Wait — the script runs through all 8 phases automatically
6. When done, press any key to close

### Method 2 — Auto-elevates itself

1. Download `DeepCacheCleaner.bat`
2. Double-click it normally
3. It will detect it doesn't have admin rights and re-launch itself with a UAC prompt automatically
4. Accept the UAC prompt
5. Done

### Method 3 — From Command Prompt (Admin)

```cmd
:: Open CMD as Administrator, then run:
cd path\to\script
DeepCacheCleaner.bat
```

### ⏱️ Expected Runtime

| Phase | Estimated Time |
|-------|---------------|
| Phases 1–6 | 1 – 5 minutes |
| Phase 7 (DISM) | **5 – 15 minutes** (varies by system) |
| Phase 8 (Refresh) | ~15 seconds |
| **Total** | **~10 – 20 minutes** |

> DISM phase duration depends on how many old Windows Update components are sitting in `WinSxS`. On a freshly updated system it may be quick; on an older system it can take longer. This is completely normal.

---

## 📂 Phase-by-Phase Breakdown

```
DeepCacheCleaner.bat
│
├── PHASE 1/8 ── Stop Services
│   └── Pauses: wuauserv, bits, cryptsvc, msiserver,
│               FontCache, DoSvc, UsoSvc, WSearch
│
├── PHASE 2/8 ── Core System Cache
│   └── Items 01–10 (Temp, Prefetch, Icons, Thumbnails...)
│
├── PHASE 3/8 ── Windows Update Deep Clean
│   └── Items 11–21 (SoftwareDistribution, catroot2,
│                     Windows.old, ~BT, ~WS, CBS, Panther...)
│
├── PHASE 4/8 ── Dumps, Logs, Error Reports
│   └── Items 22–26 (MEMORY.DMP, WER, Event Logs,
│                     Defender History, Driver Logs)
│
├── PHASE 5/8 ── Browser Cache
│   └── Items 27–29 (Chrome, Edge, Firefox — all profiles)
│
├── PHASE 6/8 ── App Cache
│   └── Items 30–37 (Teams, Discord, Spotify, VSCode,
│                     Office, OneDrive, Store, DNS)
│
├── PHASE 7/8 ── DISM WinSxS Cleanup + Restore Services
│   └── Item 38: DISM /Cleanup-Image /StartComponentCleanup
│   └── Restores all 8 services stopped in Phase 1
│
└── PHASE 8/8 ── Refresh PC x5
    └── Restarts explorer.exe
    └── Sends F5 × 5 to desktop via WScript.Shell
```

---

## ⚠️ Important Warnings

### Before Running

> **Close your browsers and apps first.**
> Files actively in use by running processes (Chrome, Firefox, Teams, etc.) will be skipped by the cleaner. For a complete browser cache wipe, close all browser windows before running the script.

> **Back up anything important in your Recycle Bin.**
> The script empties the Recycle Bin as part of Phase 2. Anything in there will be permanently deleted.

> **Windows Update history will be reset.**
> Clearing `SoftwareDistribution\DataStore` removes the local Windows Update history log. Windows Update itself will continue to function normally — it just won't show old update history in Settings.

> **Event logs will be cleared.**
> Application, System, Security, Setup, and Windows Update Client event logs are wiped. If you need these for troubleshooting, export them before running.

> **`Windows.old` deletion is permanent.**
> If `C:\Windows.old` exists (left over from a Windows version upgrade), it will be deleted. This folder is what allows you to roll back to a previous Windows version. Once deleted, rollback is no longer possible. This folder does not exist on clean installs.

### During Runtime

> **Do NOT close the window during Phase 7 (DISM).**
> The DISM component cleanup can take 5–15 minutes. Interrupting it mid-run may leave the `WinSxS` store in an inconsistent state. Let it finish.

> **Explorer will briefly disappear during Phase 8.**
> The script kills and restarts `explorer.exe` to flush the icon and thumbnail cache. Your taskbar and desktop icons will disappear for 1–3 seconds — this is expected and normal.

### After Running

- Windows Update will **re-download** any updates it needs on its next check — cleaning `SoftwareDistribution` does not break updates.
- `catroot2` will be **automatically recreated** by the Cryptographic service on next use.
- Browsers will feel slightly slower on first launch after cleaning — they're just rebuilding their cache from fresh. This is temporary.

---

## ❓ Frequently Asked Questions

**Q: Will this break my Windows installation?**
A: No. The script only deletes cache, log, and temporary files — not system binaries or user data. All services are restored after cleanup. Windows is designed to recreate all of these files on demand.

**Q: Why does DISM take so long?**
A: DISM is scanning and processing the `WinSxS` component store, which can contain hundreds of old update packages depending on how long your system has been running. It's doing real work — be patient.

**Q: My browser cache wasn't cleaned. Why?**
A: Your browser was probably open while the script ran. Cache files are locked by the browser process. Close Chrome/Edge/Firefox completely before running the script.

**Q: Will this affect my saved passwords, bookmarks, or browser history?**
A: No. The script only clears the **cache** folders (`Cache`, `GPUCache`, `Code Cache`), not profile data like history, bookmarks, passwords, or cookies.

**Q: Is it safe to delete `Windows.old`?**
A: Yes, if you no longer need to roll back to your previous Windows version. `Windows.old` is only created when Windows is upgraded (e.g., Windows 10 → 11). If you're happy with your current Windows version, it's safe to remove. If it doesn't exist on your system, the script skips it automatically.

**Q: How much space will I reclaim?**
A: It varies widely. Typical results:
- On a regularly maintained system: **500 MB – 2 GB**
- On a system not cleaned in months: **2 GB – 10 GB**
- If `Windows.old` or `$Windows.~BT` are present: **10 GB – 30+ GB** additional

**Q: Does this work on Windows 7 or 8?**
A: The script is designed and tested for **Windows 10 and Windows 11**. Some paths and commands (like `wsreset.exe` and certain DISM flags) may not exist on older versions.

**Q: How often should I run this?**
A: Once a month is generally sufficient for most users. Power users or developers who install/uninstall software frequently may benefit from running it more often.

**Q: The script says "Skipped: Not found" for some items. Is that a problem?**
A: Not at all. Items like `Windows.old`, `$Windows.~BT`, and `$Windows.~WS` only exist on systems that have gone through a Windows upgrade. If they're not on your system, the script correctly skips them.

---

## 🤝 Contributing

Contributions, suggestions, and pull requests are welcome!

If you'd like to contribute:

1. Fork the repository
2. Create a new branch: `git checkout -b feature/your-feature-name`
3. Make your changes
4. Commit: `git commit -m "Add: description of change"`
5. Push: `git push origin feature/your-feature-name`
6. Open a Pull Request

### Ideas for contributions

- Add support for more apps (Steam, Slack, Zoom, etc.)
- Add a log file output of what was cleaned and how much space was freed
- Add a `--dry-run` mode that shows what *would* be deleted without actually deleting
- Add support for cleaning all user profiles, not just the currently logged-in user
- Build a PowerShell version for cross-compatibility

---

## 📄 License

This project is licensed under the **MIT License** — see below for details.

```
MIT License

Copyright (c) 2026

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

<div align="center">
  <sub>Made for Windows 10 / 11 &nbsp;|&nbsp; No dependencies &nbsp;|&nbsp; Run monthly for best results</sub>
</div>