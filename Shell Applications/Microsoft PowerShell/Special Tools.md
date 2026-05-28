PowerShell **does not have a predefined or limited list** of standalone executables it can invoke. Instead, it can run **any executable file your operating system can access**, provided it meets basic path and permission requirements. This is a fundamental design feature of all modern command shells.

Here’s how it actually works, how to see what’s available on your system, and what you should know:

### 🔍 How PowerShell Discovers & Runs Executables
| Mechanism | Description |
|-----------|-------------|
| `PATH` Environment Variable | PowerShell searches directories listed in `$env:PATH` for executables |
| `$env:PATHEXT` | Defines which extensions auto-resolve without typing them (`.EXE`, `.CMD`, `.BAT`, `.COM`, `.VBS`, `.WSH`, etc.) |
| Full/Relative Paths | You can run anything by specifying a direct path: `C:\Tools\app.exe` or `.\setup.bat` |
| OS Permissions | Execution is subject to UAC, antivirus, AppLocker/WDAC, and file ACLs (not PowerShell's execution policy) |

### 📋 How to List All Executables PowerShell Can Currently Invoke
Run this in your PowerShell session:
```powershell
# List all external executables discoverable via PATH
Get-Command -CommandType Application | 
  Select-Object Name, Version, Source | 
  Sort-Object Name | 
  Format-Table -AutoSize
```
*Output will vary by system based on installed software and PATH configuration.*

### 🗂 Common Categories & Examples
| Category | Typical Executables | Notes |
|----------|---------------------|-------|
| **Windows Built-ins** | `robocopy.exe`, `ipconfig.exe`, `diskpart.exe`, `schtasks.exe`, `certutil.exe`, `msiexec.exe`, `findstr.exe` | Ship with Windows. Always available. |
| **PowerShell Itself** | `powershell.exe` (v5.1), `pwsh.exe` (v7+) | Cross-platform v7+ uses `pwsh` |
| **Dev/IT CLI Tools** | `git.exe`, `node.exe`, `python.exe`, `docker.exe`, `kubectl.exe`, `curl.exe`, `ssh.exe`, `7z.exe` | Added to PATH during installation |
| **Sync/Backup/Transfer** | `rclone.exe`, `rsync.exe`, `aria2c.exe`, `winscp.com`, `ffmpeg.exe` | Third-party. Must be manually installed & added to PATH |
| **WSL/Linux Binaries** | `wsl.exe`, `bash.exe`, or any Linux tool via `wsl -e <tool>` | Requires WSL enabled |

### ⚠️ Important Behavioral Notes
1. **Output is Plain Text**  
   External tools return strings, not .NET objects. Use `| Out-String`, `Select-String`, or regex to parse.
2. **Exit Codes**  
   Stored in `$LASTEXITCODE`. Note: `robocopy` uses `0–7` for success/warnings, `≥8` for errors.
3. **Execution Policy Does NOT Block `.exe` Files**  
   `Set-ExecutionPolicy` only affects PowerShell scripts (`.ps1`). External binaries run unless blocked by OS security layers.
4. **Silent Failures**  
   If a command "does nothing," verify:
   - It's in `PATH` (`Get-Command <name>`)
   - No typos or missing file extensions
   - No AV/AppLocker blocks
   - UAC/admin rights if required

### 💡 Pro Tip: Audit Your CLI Environment
```powershell
# Show your current PATH directories
$env:PATH -split ';' | Where-Object { Test-Path $_ }

# Count how many external commands are discoverable
(Get-Command -CommandType Application).Count
```

There is no master inventory because PowerShell inherits your system's executable landscape. If you'd like a **custom audit of your machine's available CLI tools**, a **wrapper template for a specific executable**, or help **managing PATH/aliases for your research workflow**, just let me know your OS and primary use case.