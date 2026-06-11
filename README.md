# 🧹 DeepCacheCleaner

![Platform](https://img.shields.io/badge/Platform-Windows%2010%20%7C%2011-0078D4?style=for-the-badge&logo=windows)
![Language](https://img.shields.io/badge/Language-Batch%20Script-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)
![Version](https://img.shields.io/badge/Version-4.0-FF6B6B?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)
![Admin Required](https://img.shields.io/badge/Requires-Administrator-red?style=for-the-badge&logo=shield)

> **A deep, automated Windows cache cleaner that wipes 51 cache locations across 9 phases — including Windows Update leftovers, browser cache, gaming platforms (Steam/Epic), hardware shader caches (NVIDIA/AMD), developer tools (npm/NuGet), and the WinSxS component store — then refreshes your PC 5 times.**

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

**DeepCacheCleaner** is a single-file Windows Batch script designed to perform a thorough, automated cleanup of your system with zero manual effort. Unlike basic disk cleanup tools, this script goes deep — it targets not just the standard `%TEMP%` folder, but also Windows Update residual files, the `WinSxS` component store, upgrade leftovers (`Windows.old`, `$Windows.~BT`), hardware shader caches, gaming platforms, and developer environments.

It safely **force-closes common apps** to unlock cache files, **stops relevant Windows services**, then **restores all services** after the cleanup is complete. Finally, it **restarts Windows Explorer and sends 5 desktop refresh signals** to apply all visual changes immediately.

**Typical disk space reclaimed:** 2 GB – 50+ GB depending on system age and developer/gaming usage.

---

## ✨ Features

- **51 cache locations** cleaned across 9 structured phases
- **Proactive App-Closing** — automatically kills browsers, Discord, Steam, Slack, and others to ensure cache files are unlocked
- **Auto-elevates** to Administrator — no manual right-clicking needed
- **Hardware-Aware** — targets NVIDIA and AMD shader caches specifically
- **Gamer-Ready** — cleans Steam and Epic Games Launcher caches
- **Dev-Friendly** — wipes npm, Yarn, Bun, NuGet, pip (Python), and Winget caches
- **Windows Update deep wipe** — removes downloaded update files, history database, `catroot2`, and upgrade staging folders
- **DISM integration** — runs `StartComponentCleanup` to shrink the `WinSxS` folder
- **Multi-profile browser cleaning** — handles all Chrome, Edge, and Firefox user profiles automatically
- **Explorer refresh** — restarts `explorer.exe` and sends 5 × F5 to apply all visual changes
- **Safe by design** — uses `>nul 2>&1` suppression so in-use files are silently skipped

---

## 🗂️ What Gets Cleaned

### Phase 0 — Force Close Apps
Closes Chrome, Edge, Firefox, Discord, Teams, Slack, Steam, Epic Games, Spotify, VS Code, Telegram, and Zoom to unlock their respective cache folders.

### Phase 2 — Core System Cache (Items 01–10)
Standard Windows temp files, prefetch, thumbnails, icons, and recycle bin.

### Phase 3 — Windows Update Deep Clean (Items 11–21)
`SoftwareDistribution`, `catroot2`, `Windows.old`, CBS logs, and Panther logs.

### Phase 4 — Crash Dumps, Logs & Error Reports (Items 22–26)
Memory dumps, Windows Error Reporting (WER), and Event Logs.

### Phase 5 — Browser Cache (Items 27–29)
Google Chrome, Microsoft Edge, and Mozilla Firefox — **all profiles**.

### Phase 6 — Communication & Social Cache (Items 30–35)
| # | App | What's cleared |
|---|-----|---------------|
| 30 | Microsoft Teams | Cache, blob_storage, databases, GPUCache, Code Cache, tmp |
| 31 | Discord | Cache, Code Cache, GPUCache |
| 32 | Telegram Desktop | temp_items, thumbnails |
| 33 | Slack | Cache, Code Cache, GPUCache |
| 34 | Zoom | Data files |
| 35 | Spotify | Storage, Data |

### Phase 7 — Gaming & Hardware Cache (Items 36–39)
| # | Target | What's cleared |
|---|--------|---------------|
| 36 | Steam | appcache, htmlcache, resource images |
| 37 | Epic Games | webcache |
| 38 | NVIDIA GPU | DXCache, GLCache, NvCache |
| 39 | AMD GPU | DxCache |

### Phase 8 — Developer & System Tools (Items 40–50)
| # | Tool | What's cleared |
|---|------|---------------|
| 40 | VS Code | Cache, Code Cache, GPUCache, logs |
| 41 | npm | full npm-cache |
| 42 | Yarn | Yarn Cache folder |
| 43 | Bun | bun-cache folder |
| 44 | NuGet | NuGet v3-cache |
| 45 | Python pip | pip cache folder |
| 46 | Office | WebServiceCache, Recent, OTele |
| 47 | OneDrive | logs, setup/logs |
| 48 | Winget | WinGet temp downloads |
| 49 | Windows Store | `wsreset.exe` cache reset |
| 50 | DNS Cache | `ipconfig /flushdns` |

### Phase 9 — DISM WinSxS Component Cleanup (Item 51)
Removes superseded Windows Update components from `C:\Windows\WinSxS`.

---

## 🚀 How to Use

1. Download `DeepCacheCleaner.bat`
2. **Double-click** it (it will auto-request Administrator privileges)
3. Wait for the 9 phases to complete
4. **Note:** Your browser and open apps *will* close automatically to ensure a deep clean.

---

## 📄 License
MIT License - Copyright (c) 2026.
