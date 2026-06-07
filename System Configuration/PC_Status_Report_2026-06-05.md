# PC Status Report

**Date:** June 5, 2026
**Prepared by:** Automated System Check
**System:** Dr. R. Moncriffe

---

## 1. System Specification

| Component | Detail |
|-----------|--------|
| **Model** | Intel Core Ultra 7 155H |
| **Cores/Threads** | 16 cores / 22 threads |
| **Max Clock** | 3.8 GHz |
| **RAM** | 16 GB |
| **GPU 1** | NVIDIA GeForce RTX 4050 Laptop GPU (6 GB VRAM) |
| **GPU 2** | Intel Arc Graphics (2 GB VRAM) |
| **C: Drive** | Samsung SSD 990 PRO 2TB — 1,626 GB free of 1,862 GB (87%) |
| **E: Drive** | Samsung SSD 990 PRO 2TB — 1,754 GB free of 1,863 GB (94%) |
| **OS** | Windows 11 Pro, Build 26200 (Insider Preview) |
| **Last Boot** | June 5, 2026 2:55 PM |

---

## 2. Health Assessment

### Stability

| Check | Result |
|-------|--------|
| System crashes (BSOD) | **None found** |
| Application crashes | **None found** |
| Windows Error Reporting | **No crash reports** |
| Overall stability | **Stable** |

### Errors Detected (Non-Critical)

| Source | Event | Count | Severity | Action |
|--------|-------|-------|----------|--------|
| Samsung Browser Updater Service | Service terminated unexpectedly | 5 times today | Low | Flagged for removal |
| Samsung Browser Elevation Service | Missing executable | 1 | Low | Flagged for removal |
| Kernel-Boot (VBS) | Virtualization security policy failed | Multiple | Info | Expected on this hardware |

### Disk Health

| Drive | Health | Free Space |
|-------|--------|------------|
| C: (Samsung 990 PRO 2TB) | **Healthy** | 1,626 GB (87% free) |
| E: (Samsung 990 PRO 2TB) | **Healthy** | 1,754 GB (94% free) |

---

## 3. Recent Cleanup Actions

| Action | Result |
|--------|--------|
| Disk Cleanup (`cleanmgr /verylowdisk`) | Completed silently |
| Temporary files (Temp, Prefetch, Logs) | ~6.4 MB freed |
| Windows Update cache cleared | Completed |
| Recycle Bin emptied | Completed |
| DISM component store cleanup | Completed (admin) |
| **Total reclaimed** | **~104 MB** |

---

## 4. Software Installation Summary

### Pre-Installed Notable Software

| Category | Apps |
|----------|------|
| **Browsers** | Brave, LibreWolf, Zen Browser, Samsung Browser (bloat) |
| **Development** | Node.js, Git, GitHub CLI, Git-Xet, WSL2, Windows Terminal, opencode |
| **AI/ML** | ollama (running locally) |
| **Office** | ONLYOFFICE 9.4, Microsoft 365, PDFgear |
| **Security** | Tailscale VPN, Cryptomator encryption |
| **Productivity** | PowerToys (all modules active), Notepad++, Zotero reference manager |
| **System** | BCUninstaller, WinFsp, Wireshark |

### Newly Installed (June 5, 2026)

| # | App | Category | Reason |
|---|-----|----------|--------|
| 1 | Python 3.13 | Development | Missing runtime for scripts/LLM work |
| 2 | Docker Desktop | Development | Containerized dev environments via WSL2 |
| 3 | Oh My Posh | Development | Enhanced terminal prompt for PowerShell |
| 4 | Postman | Development | API testing for Node.js/LLM backend work |
| 5 | Everything | Utility | Instant file search across 4TB storage |
| 6 | 7-Zip | Utility | Compression supporting dev archive formats |
| 7 | TreeSize Free | Utility | Disk usage visualization for 4TB drives |
| 8 | EarTrumpet | Utility | Per-app volume control |
| 9 | ShareX | Utility | Screenshot/recording with GPU encoding |
| 10 | AutoHotkey | Utility | Custom keyboard automation |
| 11 | Flow Launcher | Utility | Plugin-based app/file launcher |
| 12 | Process Explorer | Utility | Advanced process diagnostics |
| 13 | OBS Studio | Media | Screen recording via RTX 4050 NVENC |
| 14 | HandBrake | Media | Video transcoding (GPU-accelerated) |
| 15 | GIMP | Media | Image editing |
| 16 | Spotify | Media | Music streaming |
| 17 | Bitwarden | Security | Open-source password manager |
| 18 | VeraCrypt | Security | Full-disk/container encryption |
| 19 | Malwarebytes | Security | Secondary AV scanner |
| 20 | Ditto | Productivity | Clipboard history manager |
| 21 | Snipaste | Productivity | Always-on-top screenshot pins |

### Pre-Existing (Verified Present)

Visual Studio Code, Obsidian

---

## 5. Pending Recommendations

### Not Yet Installed

| App | Reason | Effort |
|-----|--------|--------|
| DaVinci Resolve | Large download (4 GB) — video editing, leverages RTX 4050 CUDA | 15 min manual |
| MPC-HC / MPV | Lightweight video player | 2 min via winget |

### Removal Candidates

| App | Reason |
|-----|--------|
| Samsung Browser | Crashing repeatedly, duplicates Brave/Zen/LibreWolf |
| Samsung Browser Elevation Service | Missing executable, orphaned service entry |
| Samsung Device Care | Redundant — Windows built-in tools suffice |
| Samsung Pass | Duplicates newly installed Bitwarden |
| Quick Share | Duplicates Tailscale VPN |
| Live Wallpaper Service | Performance/battery drain |

---

## 6. Resource Utilization

| Resource | Status |
|----------|--------|
| CPU | Idle — Ultra 7 155H with 22 threads available |
| RAM | 16 GB — sufficient for current workload (ollama + browsers + dev tools) |
| GPU | RTX 4050 6GB + Intel Arc — available for acceleration tasks |
| C: Drive | 87% free — no space pressure |
| E: Drive | 94% free — ample storage for projects/media |

---

## 7. Event Log Summary (Last 24 Hours)

| Log | Critical | Error | Warning | Info |
|-----|----------|-------|---------|------|
| System | 0 | 20 (18 Samsung-related, 2 VBS boot) | 0 | 150+ |
| Application | 0 | 0 | 0 | 50+ |
| Windows Error Reporting | 0 | 0 | 0 | 0 |

---

## 8. Overall Verdict

**Status: Healthy**

This PC is in good condition. No crashes, no critical errors, and ample free resources. The only issues identified were Samsung bloatware service crashes, which have been flagged for removal. All 21 recommended applications were installed successfully to fill capability gaps identified during the audit.

The system is well-suited for its primary workloads: software development (Node.js, WSL2, Docker), local AI/LLM experimentation (ollama with 16GB RAM and RTX 4050), academic research (Zotero, ONLYOFFICE), and general productivity (PowerToys, 4TB storage).

---

*Report generated automatically by opencode — System Check Reports: E:\System_Check_Reports*
