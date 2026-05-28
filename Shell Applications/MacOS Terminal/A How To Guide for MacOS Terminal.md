To answer your question directly: **`rsync`** is the macOS Terminal equivalent of Robocopy, while **`rclone`** is the same cross-platform tool you already know. Below is a complete guide covering both tools, plus a bonus native macOS utility, and how to automate them.

---

## 📋 Quick Comparison: rsync vs. rclone vs. ditto

| Feature | rsync | rclone | ditto (macOS native) |
|---------|-------|--------|----------------------|
| **Primary use** | Local/remote file sync, backups | Cloud storage sync (40+ providers) | Copy files/folders preserving macOS metadata |
| **Installation** | Built into macOS | Requires separate install (Homebrew) | Built into macOS |
| **Key strength** | Incremental sync, delta transfers, preserve Unix perms | Cloud sync, mount cloud as drive, encryption | Preserves resource forks, HFS+ metadata |
| **Deletion behavior** | `--delete` flag deletes extras at dest | `sync` makes dest match source; `copy` doesn't delete | No deletion (copy-only) |
| **Multi-threading** | No built-in parallelism (use xargs for parallel) | `--transfers N` flag | No |
| **Cloud support** | None (local & SSH only) | 40+ providers (Google Drive, S3, etc.) | None |
| **Resume ability** | `--partial` flag | Automatic | No |

---

## 🚀 rsync in macOS Terminal: Complete Guide

`rsync` is the direct counterpart to Robocopy, pre-installed on macOS. It synchronizes files locally or over SSH with delta-transfer efficiency (only changed parts of files are sent).

### 1. Verify Installation

```bash
rsync --version
```
Note: macOS ships with rsync 2.6.9 (an older version). For the `--info=progress2` flag, install a newer version:
```bash
brew install rsync
```
This gives you rsync 3.x with additional features.

### 2. Basic Commands

**Copy files locally** (simple copy, no deletion)
```bash
rsync -av /path/to/source/ /path/to/destination/
```
- `-a` (archive mode): preserves permissions, timestamps, symlinks; recursive
- `-v` (verbose): shows what's being copied
- ⚠️ **Trailing slash matters**: `source/` copies *contents*; `source` copies the *folder itself*

**Copy with progress information**
```bash
rsync -av --progress /path/to/source/ /path/to/destination/
```
Shows per-file progress: filename, size, bytes transferred, speed, ETA.

**Dry run (preview without copying)**
```bash
rsync -av --dry-run /path/to/source/ /path/to/destination/
```

### 3. Mirror a Directory (Robocopy `/mir` Equivalent)

```bash
rsync -av --delete /path/to/source/ /path/to/destination/
```
The `--delete` flag removes files from the destination that no longer exist in the source.

### 4. Key Parameters Reference

| Option | Description |
|--------|-------------|
| `-a` | Archive mode: preserves permissions, timestamps, symlinks, groups, owner, devices |
| `-v` | Verbose output |
| `--progress` | Per-file progress with speed and ETA |
| `--partial` | Keep partially transferred files (enables resume) |
| `--delete` | Delete extraneous files from destination |
| `--exclude '*.tmp'` | Exclude files matching pattern |
| `--include '*.pdf'` | Include only specific patterns |
| `--max-size 100M` | Maximum file size |
| `-E` | Preserve extended attributes (macOS metadata) |
| `-A` | Preserve ACLs |
| `-H` | Preserve hard links |
| `-z` | Compress data during transfer |
| `--bwlimit 1M` | Limit bandwidth to 1 MB/s |
| `--stats` | Show transfer statistics at the end |
| `--log-file /path/to/log` | Write output to a log file |

### 5. macOS-Specific Options

macOS uses extended attributes (xattrs) and resource forks that standard copies may lose. To preserve all Apple metadata:

```bash
rsync -avHE --progress /path/to/source/ /path/to/destination/
```
- `-E` preserves extended attributes
- `-H` preserves hard links
- Combine with `-A` for ACLs: `rsync -avHAE ...`

### 6. Remote Sync Over SSH

**Copy to a remote Mac/server**
```bash
rsync -avz --progress /local/folder/ user@192.168.1.100:/remote/folder/
```

**Copy from remote to local**
```bash
rsync -avz --progress user@remote:/path/to/folder/ /local/folder/
```

**Use custom SSH port**
```bash
rsync -avz -e "ssh -p 2222" /local/ user@host:/remote/
```

### 7. Shell Scripting with rsync

**Comprehensive backup script**
```bash
#!/bin/bash
# backup.sh

SOURCE="/Users/username/Documents"
DESTINATION="/Volumes/BackupDrive/Documents"
LOGFILE="$HOME/logs/rsync_backup_$(date +%Y%m%d).log"

rsync -avHAE \
  --progress \
  --delete \
  --exclude "*.tmp" \
  --log-file="$LOGFILE" \
  "$SOURCE/" "$DESTINATION/"

if [ $? -eq 0 ]; then
  echo "[$(date)] Backup completed successfully" >> "$LOGFILE"
  osascript -e 'display notification "Backup completed" with title "rsync"'
else
  echo "[$(date)] Backup failed with exit code $?" >> "$LOGFILE"
fi
```

**Check exit codes**
```bash
rsync ...
EXIT_CODE=$?
case $EXIT_CODE in
  0) echo "Success" ;;
  1) echo "Partial transfer due to error" ;;
  2) echo "Partial transfer due to vanished source files" ;;
  *) echo "Error code: $EXIT_CODE" ;;
esac
```

---

## ☁️ rclone in macOS Terminal: Complete Guide

### 1. Installation

**Option A: Homebrew (Recommended)**
```bash
brew install rclone
```


**Option B: Official script**
```bash
sudo -v ; curl https://rclone.org/install.sh | sudo bash
```


**Option C: MacPorts**
```bash
sudo port install rclone
```


**Verify installation**
```bash
rclone version
```

**Enable tab completion**
```bash
# Add to ~/.zshrc
echo 'source <(rclone completion zsh)' >> ~/.zshrc
source ~/.zshrc
```

### 2. Configuration

```bash
rclone config
```
This opens an interactive setup:
- Choose `n` for new remote
- Enter a name (e.g., `gdrive`)
- Select storage type by number (e.g., 18 for Google Drive)
- Follow OAuth prompts in your browser

Configuration is stored at `~/.config/rclone/rclone.conf`.

**List configured remotes**
```bash
rclone listremotes
```

### 3. Basic Commands

Commands are identical to the Windows version:

| Command | Description |
|---------|-------------|
| `rclone copy source dest` | Copy files (skip identical; no deletion) |
| `rclone sync source dest` | Make dest match source (deletes extras) |
| `rclone move source dest` | Move files (delete source after copy) |
| `rclone delete remote:path` | Delete a file |
| `rclone purge remote:path` | Delete a directory |
| `rclone ls remote:path` | List files |
| `rclone lsd remote:path` | List directories |
| `rclone tree remote:path` | Tree view |

**Copy with progress and multi-threading**
```bash
rclone copy ~/Documents gdrive:Backup --progress --transfers 8
```

**Dry-run sync**
```bash
rclone sync ~/source gdrive:dest --dry-run
```

### 4. Mount Cloud Storage as a Volume

First, install macFUSE:
```bash
brew install --cask macfuse
```

Then mount:
```bash
rclone mount gdrive: ~/CloudDrive --vfs-cache-mode writes
```

Unmount:
```bash
# Option 1: Use rclone
rclone unmount ~/CloudDrive

# Option 2: Use macOS command
umount ~/CloudDrive
```

### 5. Shell Scripting with rclone

```bash
#!/bin/bash
# cloud_sync.sh

SOURCE="$HOME/Documents"
DEST="gdrive:DocumentsBackup"
LOGFILE="$HOME/logs/rclone_$(date +%Y%m%d).log"

rclone sync "$SOURCE" "$DEST" \
  --progress \
  --log-file="$LOGFILE" \
  --log-level INFO \
  --exclude "*.tmp" \
  --exclude ".DS_Store"

if [ $? -eq 0 ]; then
  echo "Cloud sync completed successfully"
else
  echo "Cloud sync failed"
fi
```

---

## 🍎 Bonus: ditto (macOS Native Copy Utility)

`ditto` is a macOS-specific command that preserves Apple metadata (resource forks, Finder tags, extended attributes) by default.

### Basic Usage

```bash
# Copy a folder with all macOS metadata
ditto /path/to/source /path/to/destination
```

Unlike `rsync`, `ditto` preserves resource forks and HFS+ metadata automatically.

### Key Options

| Option | Description |
|--------|-------------|
| `-V` | Verbose: print a line for every file copied |
| `-v` | Very verbose: print detailed information |
| `-c` | Create a CPIO archive |
| `-k` | Create a PKZip archive |
| `-z` | Use gzip compression |
| `--rsrc` | Preserve resource forks |

**Example: Create a compressed ZIP**
```bash
ditto -c -k --sequesterRsrc --keepParent /path/to/folder /path/to/archive.zip
```

### When to Use ditto vs. rsync

| Scenario | Tool |
|----------|------|
| Copying macOS app bundles (.app) | `ditto` |
| Preserving Finder tags, comments | `ditto` |
| Incremental backups | `rsync` |
| Sync to external drive | `rsync` |
| Copying to non-Apple filesystems | `rsync` |

---

## 📅 Scheduling with launchd

macOS uses **launchd** (not Task Scheduler) for automation.

### 1. Create a Shell Script

Save as `~/Scripts/backup.sh`:
```bash
#!/bin/bash
rsync -avHAE --delete /Users/username/Documents/ /Volumes/Backup/Documents/
```
Make it executable:
```bash
chmod +x ~/Scripts/backup.sh
```

### 2. Create a launchd plist

Save as `~/Library/LaunchAgents/com.user.backup.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.backup</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>/Users/username/Scripts/backup.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>2</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    <key>StandardOutPath</key>
    <string>/Users/username/logs/backup.log</string>
    <key>StandardErrorPath</key>
    <string>/Users/username/logs/backup_error.log</string>
</dict>
</plist>
```


### 3. Load the Job

```bash
# Load the plist
launchctl load ~/Library/LaunchAgents/com.user.backup.plist

# Check if it's loaded
launchctl list | grep com.user.backup

# Unload if needed
launchctl unload ~/Library/LaunchAgents/com.user.backup.plist
```


### 4. Trigger on External Drive Mount

Add these keys to your plist to run when a specific volume mounts:
```xml
<key>WatchPaths</key>
<array>
    <string>/Volumes/BackupDrive</string>
</array>
```


### 5. Grant Full Disk Access

For scheduled scripts to access protected folders:
1. Go to **System Settings → Privacy & Security → Full Disk Access**
2. Add `/bin/bash` or `/bin/sh` to the list

---

## 🎯 Best Practices

### rsync Best Practices
1. **Always use `--dry-run` first** to preview changes.
2. **Trailing slash matters**: `source/` copies *contents*; `source` copies the *folder itself*.
3. **Use `-avHAE` on macOS** to preserve all Apple metadata.
4. **Use `--partial`** to resume interrupted transfers.
5. **Use `--log-file`** for record-keeping and troubleshooting.
6. **Exclude macOS junk**: `--exclude ".DS_Store" --exclude ".Spotlight-V100" --exclude ".Trashes" --exclude "._*"`.
7. **Install GNU rsync** (`brew install rsync`) for newer features like `--info=progress2`.

### rclone Best Practices
1. **Test with `--dry-run`** before syncing.
2. **Use `--progress`** for visibility on large transfers.
3. **Always specify `--log-file`** with `--log-level INFO`.
4. **Secure your config**: `~/.config/rclone/rclone.conf` contains access tokens—restrict permissions: `chmod 600 ~/.config/rclone/rclone.conf`.
5. **Use `--transfers`** to optimize speed (default is 4; increase for many small files).
6. **Mount with `--vfs-cache-mode writes`** for reliable cloud drive mounting.

### Scheduling Best Practices
1. **Use launchd for recurring tasks**; it's more reliable than cron on modern macOS.
2. **Log all output** using `StandardOutPath` and `StandardErrorPath`.
3. **Test scripts manually** before scheduling them.
4. **Grant Full Disk Access** to the shell or script runner.
5. **Use `caffeinate`** to prevent sleep during long transfers:
   ```bash
   caffeinate -s rsync -av /source/ /dest/
   ```
   

---

This guide covers the complete macOS equivalents of Robocopy (`rsync`) and rclone, plus the native `ditto` utility, with everything from basic commands to automated scheduling. Use `rsync` for robust local and remote file synchronization, `rclone` for cloud storage integration, and `ditto` when you need to preserve every bit of Apple-specific metadata.