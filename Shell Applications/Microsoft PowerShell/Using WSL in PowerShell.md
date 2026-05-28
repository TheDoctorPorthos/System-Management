Here is a complete, step-by-step guide to using **WSL (Windows Subsystem for Linux)** directly from Microsoft PowerShell. This workflow is ideal for running Linux-native tools (`rsync`, `gunicorn`, `docker`, `python3`, etc.) without leaving your PowerShell environment.

---

## 📦 Step 1: Install & Verify WSL
Run in **Administrator PowerShell**:
```powershell
# Install WSL 2 + default Ubuntu distro (one-command setup)
wsl --install

# Reboot when prompted
```
**Verify installation:**
```powershell
wsl --status          # Shows default version & kernel
wsl -l -v             # Lists installed distros & versions (should show "2")
```

> 💡 **Windows 10/11 Note:** `wsl --install` requires Windows 10 version 2004+ or Windows 11. For older builds, enable manually via `Enable-WindowsOptionalFeature`.

---

## 🔧 Step 2: Core WSL Commands in PowerShell
| Task | PowerShell Command |
|------|-------------------|
| Enter default Linux shell | `wsl` |
| Enter specific distro | `wsl -d Ubuntu-22.04` |
| List installed distros | `wsl -l` or `wsl --list` |
| Show versions | `wsl -l -v` |
| Run Linux command inline | `wsl ls -la /home` |
| Stop all running instances | `wsl --shutdown` |
| Update WSL kernel/components | `wsl --update` |
| Set WSL 2 as default | `wsl --set-default-version 2` |

---

## ⚡ Step 3: Running Linux Tools Directly from PowerShell
You can invoke any Linux binary installed inside WSL without leaving PowerShell:

```powershell
# Single command
wsl python3 --version
wsl rsync --version
wsl gunicorn --version

# Complex command (use bash -c for pipes, redirects, or multiple statements)
wsl bash -c "ls -la | grep '\.csv' | wc -l"

# Pass PowerShell variables to WSL
$File = "data.csv"
wsl bash -c "head -n 5 /mnt/c/Users/DrMoncriffe/$File"
```

🔹 **Important Syntax Rules:**
- Use `wsl bash -c "..."` for anything beyond a single command/argument
- Escape quotes carefully: `wsl bash -c 'echo "Hello from Linux"'`
- WSL inherits **Linux environment**, not PowerShell variables, unless explicitly passed

---

## 📁 Step 4: Filesystem & Path Interoperability
WSL bridges Windows and Linux filesystems, but cross-OS I/O has performance implications.

| Direction | Syntax | Example |
|-----------|--------|---------|
| **PowerShell → Linux** | `\\wsl.localhost\<DistroName>\` | `Copy-Item report.csv \\wsl.localhost\Ubuntu\home\user\` |
| **Linux → Windows** | `/mnt/<drive>/` | `cp /mnt/c/Users/DrMoncriffe/data/ ~/project/` |
| **Convert paths programmatically** | `wsl wslpath` | `wsl wslpath -w "/home/user/file.txt"` → `\\wsl$\Ubuntu\home\user\file.txt` |

⚠️ **Performance Rule:** 
- Keep heavy I/O (datasets, model training, `rsync`, `git`) **inside the native Linux filesystem** (`\\wsl.localhost\...`)
- Avoid running Linux tools on `/mnt/c/...` paths for large files (cross-filesystem latency)

---

## 🌐 Step 5: Networking & Port Access
WSL 2 uses a lightweight virtualized NAT network. Modern Windows auto-forwards ports, but verification helps.

```powershell
# Check WSL IP address
wsl hostname -I

# View active port proxies
netsh interface portproxy show v4tov4

# Test if a Linux service is reachable from Windows
Test-NetConnection -ComputerName localhost -Port 8000
```
✅ **Good news:** Windows 11 + WSL 2 v0.67.6+ automatically forwards `localhost:<port>` to WSL. No manual `portproxy` needed in most cases.

---

## 🛠 Step 6: PowerShell Integration & Automation
### 🔹 Create PowerShell Aliases for WSL Commands
Add to your `$PROFILE` (`notepad $PROFILE`):
```powershell
function wsl-ls   { wsl ls -la $args }
function wsl-grep { wsl grep --color=auto $args }
function wsl-rsync{ wsl rsync -avz $args }
function wsl-guni { wsl gunicorn $args }
```

### 🔹 Run WSL Scripts from PowerShell
```powershell
# Execute a Linux shell script
wsl /home/user/scripts/backup.sh

# Run with sudo
wsl sudo apt update
```

### 🔹 Pass PowerShell Env Vars to WSL
```powershell
$env:MY_API_KEY = "abc123"
wsl bash -c 'echo $MY_API_KEY'  # Works because WSL inherits the calling process environment
```

### 🔹 Mount Windows Drives in WSL (if missing)
Create `/etc/wsl.conf` inside WSL:
```ini
[automount]
enabled = true
root = /mnt/
options = "metadata,umask=22,fmask=111"
```
Then restart: `wsl --shutdown` → `wsl`

---

## 💾 Step 7: Backup, Export & Manage Distros
```powershell
# Export distro to tarball (backup/migrate)
wsl --export Ubuntu C:\Backups\ubuntu-backup.tar

# Import to a new location/name
wsl --import UbuntuDev D:\WSL\UbuntuDev C:\Backups\ubuntu-backup.tar --version 2

# Unregister (delete) a distro
wsl --unregister UbuntuDev

# Change default user
wsl -d Ubuntu -u root
```

---

## 🔍 Step 8: Troubleshooting & Best Practices
| Symptom | Fix |
|---------|-----|
| `wsl` command not found | Enable in Windows Features or run `wsl --install` |
| Slow file access | Move files to `\\wsl.localhost\...` or use Linux home dir |
| Port not reachable | Update WSL: `wsl --update`, then `wsl --shutdown` |
| Permission denied on `/mnt/c/` | Run `wsl --shutdown`, then restart. Check `/etc/wsl.conf` automount options |
| Can't ping Windows from WSL | Use `cat /etc/resolv.conf` for DNS, or `ip route show default` for gateway |
| WSL 1 vs WSL 2 confusion | Convert: `wsl --set-version <Distro> 2` |

---

## 📋 Quick Reference Cheat Sheet
```powershell
# CORE
wsl -l -v                     # List distros & versions
wsl --shutdown                # Stop all WSL instances
wsl --update                  # Update WSL kernel/components

# RUN LINUX COMMANDS
wls ls -la /home              # Quick list
wsl bash -c "grep -r 'error' /var/log"  # Complex
wsl python3 app.py            # Run Python in Linux

# PATH CONVERSION
wsl wslpath -w "/home/user/data"        # Linux → Windows
wsl wslpath -u "C:\Users\DrM\data"      # Windows → Linux

# NETWORKING
Test-NetConnection localhost 8000         # Verify port forwarding
wsl hostname -I                           # Get WSL IP

# LIFECYCLE
wsl --export Ubuntu C:\backup.tar         # Backup
wsl --import NewDistro D:\wsl\New C:\backup.tar  # Restore
wsl --unregister OldDistro                # Delete
```

---

## 🎯 Pro Tip for Your Workflow
Since you previously asked about `gunicorn` (Linux-only WSGI server) and `rsync`/`rclone`, WSL is your **best bridge**:
```powershell
# Run Gunicorn natively in WSL from PowerShell
wsl bash -c "cd /home/user/project && gunicorn main:app --bind 0.0.0.0:8000 --workers 4"

# Sync Windows research data to Linux workspace efficiently
wsl rsync -avz --progress /mnt/c/Users/DrMoncriffe/Research/ ~/research/
```

Would you like a **PowerShell module** that wraps WSL commands into reusable functions for your dissertation pipeline, or a guide to **setting up VS Code Remote-WSL** for seamless cross-OS development?