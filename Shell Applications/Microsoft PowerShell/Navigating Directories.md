Here is a step-by-step guide to navigating directories in PowerShell, covering basics, efficiency tricks, and advanced navigation patterns.

---

## 📍 Step 1: Check Your Current Location
```powershell
Get-Location   # Full cmdlet name
pwd            # Unix-style alias
$PWD           # Built-in variable (returns a PathInfo object)
```
*Output example:* `C:\Users\DrMoncriffe\Documents\Research`

---

## 📂 Step 2: List Directory Contents
```powershell
Get-ChildItem          # Default: files & folders
ls                     # Unix alias
dir                    # CMD alias
```
**Useful modifiers:**
| Flag | Purpose |
|------|---------|
| `-Directory` | Show only folders |
| `-File` | Show only files |
| `-Force` | Include hidden/system items |
| `-Recurse` | List all subdirectories |
| `-Depth 2` | Limit recursion depth (PS 7+) |

*Example:* `ls -Directory -Force`  
*Pipeline tip:* `ls *.csv | Sort-Object LastWriteTime -Descending | Select-Object -First 5`

---

## 🔄 Step 3: Change Directories
```powershell
Set-Location <path>
cd <path>      # Most common alias
```
**Path types:**
| Type | Example | Notes |
|------|---------|-------|
| Absolute | `cd C:\Data\ProjectA` | Starts from drive root |
| Relative | `cd .\RawData` or `cd ..` | `.` = current, `..` = parent |
| Home | `cd ~` or `cd $HOME` | Goes to user profile |
| Previous | `cd -` | **PS 7+ only** |
| Cross-drive | `cd D:\Backup` | Works reliably in all versions |

> ⚠️ **Windows PowerShell 5.1 note:** Typing `D:` alone switches drives (CMD legacy). In PS 7+, use `cd D:\` consistently.

---

## 📚 Step 4: Remember & Restore Locations (Location Stack)
Ideal for jumping between multiple project folders without typing long paths.
```powershell
Push-Location C:\Data\Analysis   # Saves current dir, moves to new one
Pop-Location                     # Returns to where you pushed from
Get-Location -Stack              # View saved locations
```
*Aliases:* `pushd`, `popd`  
*Use case:* Temporarily switch to a reference folder, then return instantly.

---

## ⚡ Step 5: Speed Up Navigation with Built-in Features
| Feature | How to Use |
|---------|------------|
| **Tab Completion** | Type `cd Doc` → press `Tab` to cycle through matches |
| **Reverse Search** | Press `Ctrl+R` (requires `PSReadLine`, enabled by default in PS 5+) |
| **History Arrows** | `↑`/`↓` to cycle previous commands |
| **Path Variables** | `$env:TEMP`, `$env:USERPROFILE`, `$PSCommandPath` (script location) |
| **Create & Enter** | `mkdir NewFolder; cd NewFolder` or `cd (mkdir NewFolder).FullName` |

---

## 🌐 Advanced: Navigate Non-Filesystem "Drives"
PowerShell uses **providers** to treat other data stores like directories:
```powershell
cd HKLM:\SOFTWARE          # Windows Registry
cd Cert:\CurrentUser\My    # Certificate store
cd Env:\                   # Environment variables
cd Variable:\              # PowerShell variables
```
Use `Get-PSDrive` to see all available drives, and `Set-Location` to move into them.

---

## 📋 Quick Reference Table
| Task | Command | Alias |
|------|---------|-------|
| Show current dir | `Get-Location` | `pwd` |
| List contents | `Get-ChildItem` | `ls`, `dir` |
| Change dir | `Set-Location` | `cd` |
| Push to stack | `Push-Location` | `pushd` |
| Pop from stack | `Pop-Location` | `popd` |
| View available drives | `Get-PSDrive` | — |

---

## 💡 Pro Tips for Research/Data Workflows
1. **Use scripts, not aliases, in automation:** `Set-Location` and `Get-ChildItem` are explicit and version-safe.
2. **Combine navigation with filtering:**  
   `cd C:\Data; ls -File -Filter "*.sav" | Where-Object {$_.Length -gt 50MB}`
3. **Jump to frequently used paths:** Create a function in your `$PROFILE`:
   ```powershell
   function cd-research { Set-Location "C:\Users\DrMoncriffe\Documents\Dissertation" }
   ```
4. **Avoid `cd` in scripts:** Use `-Path` parameters on cmdlets instead. `cd` changes session state and can cause unexpected behavior in pipelines or remote sessions.

Would you like a printable navigation cheat sheet, a custom `$PROFILE` setup for your dissertation data structure, or help building a script that auto-navigates and organizes research files?