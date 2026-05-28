This guide provides comprehensive, step-by-step instructions for using **rclone** and **robocopy** in Microsoft PowerShell. Both are powerful command-line tools for file operations, but they serve different primary purposes: **rclone** excels at syncing with cloud storage and remote servers, while **robocopy** is a robust local/network file copy utility built into Windows.

## 📋 Quick Comparison: rclone vs. robocopy

| Feature | rclone | robocopy |
|---------|--------|----------|
| **Primary use** | Cloud storage sync, remote file management | Local/network file copy, directory mirroring |
| **Installation** | Requires separate installation (`winget install Rclone.Rclone`) | Built into Windows (Vista and later) |
| **Cloud support** | 40+ cloud providers (Google Drive, S3, Azure, etc.) | None (local drives and network shares only) |
| **Key commands** | `copy`, `sync`, `move`, `mount`, `ls`, `delete` | Single `robocopy` command with many options |
| **Deletion behavior** | `copy` doesn't delete; `sync` makes destination match source (deletes extras) | Controlled by `/purge` or `/mir` |
| **Scripting ease** | Simple command structure, easy to wrap in scripts | More complex syntax, but still scriptable |
| **Multi-threading** | Built-in (`--transfers` flag) | `/mt` parameter (1-128 threads) |
| **Resume ability** | Automatic for most backends | `/z` (restartable mode) |

---

## 🚀 Rclone in PowerShell: Complete Guide

Rclone is a command-line program to manage files on cloud storage, with powerful cloud equivalents to the unix commands rsync, cp, mv, mount, ls, ncdu, tree, rm, and cat.

### 1. Installation

**Option A: Using WinGet (Recommended)**
```powershell
# Install rclone with WinGet
winget install Rclone.Rclone
```
This method handles path setup automatically.

**Option B: Manual Installation**
```powershell
# Create installation directory
mkdir C:\rclone
cd C:\rclone

# Download rclone (replace URL with latest from https://rclone.org/downloads/)
Invoke-WebRequest -Uri "https://downloads.rclone.org/rclone-current-windows-amd64.zip" -OutFile rclone.zip
Expand-Archive rclone.zip -DestinationPath .
# Move rclone.exe to C:\rclone
Move-Item -Path .\rclone-*\rclone.exe -Destination .
```

**Add rclone to PATH (if needed)**
```powershell
# Add rclone directory to user's PATH
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\rclone", [EnvironmentVariableTarget]::User)
# Reload environment variables
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
```

**Verify installation**
```powershell
rclone version
```

**Enable PowerShell tab completion**
```powershell
# Load completion for current session
rclone completion powershell | Out-String | Invoke-Expression
# To make it permanent, add to your PowerShell profile:
Add-Content -Path $PROFILE -Value "rclone completion powershell | Out-String | Invoke-Expression"
```
This generates a PowerShell completion script for rclone.

### 2. Configuration

Rclone uses a configuration file to store remote connections.

**Interactive setup**
```powershell
rclone config
```
This opens an interactive menu:
- Choose `n` for new remote
- Enter a name (e.g., `gdrive`, `s3backup`)
- Select storage type (e.g., `13` for Google Drive)
- Follow prompts for authentication

**Example: Configure Google Drive**
```powershell
rclone config
# n (new remote)
# name: gdrive
# storage: 22 (Google Drive)
# client_id: (leave blank for default)
# client_secret: (leave blank for default)
# scope: 1 (full access)
# root_folder_id: (leave blank)
# service_account_file: (leave blank)
# Edit advanced config? n
# Use auto config? y
# (Browser will open for authentication)
```

**List configured remotes**
```powershell
rclone listremotes
```

**Check configuration file location**
```powershell
rclone config file
```

### 3. Basic Commands

#### **Copy** - Copy files from source to destination, skipping identical files
```powershell
# Basic copy (does not delete files at destination)
rclone copy C:\local\folder remote:path/to/folder

# Copy with progress
rclone copy C:\local\folder remote:path/to/folder --progress

# Copy only recently changed files (last 24 hours) with optimization
rclone copy --max-age 24h --no-traverse C:\local\folder remote:path
```
The `--no-traverse` flag prevents rclone from listing the entire destination directory, speeding up copies when only a few files have changed.

#### **Sync** - Make destination identical to source (deletes extra files at destination)
```powershell
# Sync (WARNING: deletes files at destination that aren't in source)
rclone sync C:\source\folder remote:dest/folder

# Safe sync with interactive confirmation
rclone sync --interactive C:\source remote:dest

# Dry-run to see what would happen
rclone sync --dry-run C:\source remote:dest
```
Important: `sync` modifies the destination to match the source, including deleting files if necessary.

#### **Move** - Move files from source to destination (deletes source after copy)
```powershell
# Move entire folder
rclone move C:\old\folder remote:new/folder

# Move with progress
rclone move C:\source remote:dest --progress
```

#### **List files**
```powershell
# List files in a remote
rclone ls remote:path

# List files with sizes in human-readable format
rclone lsd remote:path

# Tree view
rclone tree remote:path
```

#### **Delete files**
```powershell
# Delete a file
rclone delete remote:path/file.txt

# Delete a directory
rclone purge remote:path/directory
```

### 4. Advanced Features

#### **Mount cloud storage as a drive**
```powershell
# Install WinFsp first (required for mounting)
# Download from https://winfsp.dev/rel/

# Mount remote as drive letter
rclone mount remote:path X: --vfs-cache-mode writes

# Mount with specific caching
rclone mount remote:path X: --vfs-cache-mode full --dir-cache-time 5m

# Unmount
rclone unmount X:
```
Mounting allows you to access cloud storage like a local drive.

#### **Bandwidth limiting**
```powershell
# Limit upload speed
rclone copy C:\folder remote:dest --bwlimit 1M

# Limit download speed only
rclone copy remote:source C:\folder --bwlimit 1M:off
```

#### **Checksum verification**
```powershell
# Use checksums instead of modtime/size for comparison
rclone sync C:\source remote:dest --checksum
```

#### **Filter files**
```powershell
# Exclude certain files
rclone sync C:\source remote:dest --exclude "*.tmp" --exclude "*.log"

# Include only certain patterns
rclone copy C:\source remote:dest --include "*.pdf" --include "*.docx"
```

### 5. PowerShell Scripting with Rclone

**Basic backup script**
```powershell
# backup.ps1
$source = "C:\ImportantFiles"
$destination = "gdrive:Backup"
$logfile = "C:\Logs\rclone_backup_$(Get-Date -Format 'yyyyMMdd').log"

try {
    rclone sync $source $destination `
        --progress `
        --log-file $logfile `
        --log-level INFO `
        --exclude "*.tmp" `
        --create-empty-src-dirs
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Backup completed successfully" -ForegroundColor Green
    }
    else {
        Write-Warning "Backup completed with exit code $LASTEXITCODE"
    }
}
catch {
    Write-Error "Backup failed: $_"
}
```

**Scheduled sync script**
```powershell
# scheduled_sync.ps1
param(
    [string]$Source,
    [string]$Destination,
    [string]$LogPath = "C:\Logs\rclone_sync.log"
)

$startTime = Get-Date
Add-Content -Path $LogPath -Value "[$(Get-Date)] Starting sync from $Source to $Destination"

try {
    rclone sync $Source $Destination --progress --log-file $LogPath --log-level INFO
    $exitCode = $LASTEXITCODE
    
    $endTime = Get-Date
    $duration = $endTime - $startTime
    
    Add-Content -Path $LogPath -Value "[$(Get-Date)] Sync completed with exit code $exitCode in $duration"
}
catch {
    Add-Content -Path $LogPath -Value "[$(Get-Date)] ERROR: $_"
    throw
}
```
Usage: `.\scheduled_sync.ps1 -Source "C:\Data" -Destination "remote:Backup"`

**Two-way sync using rclone bisync**
```powershell
# Experimental two-way sync
rclone bisync remote1:path remote2:path --resync
```
Note: bisync is experimental and requires careful testing.

### 6. Error Handling and Logging

**Check exit codes**
```powershell
rclone copy source dest
$exitCode = $LASTEXITCODE
switch ($exitCode) {
    0 { Write-Host "Success - no errors" }
    1 { Write-Host "Syntax or usage error" }
    2 { Write-Host "Error not otherwise categorised" }
    3 { Write-Host "Directory not found" }
    # See full list at https://rclone.org/docs/#exit-code
}
```

**Logging options**
```powershell
# Log to file
rclone sync source dest --log-file=rclone.log

# Set log level (ERROR, NOTICE, INFO, DEBUG)
rclone sync source dest --log-level DEBUG

# Combined log file with file paths
rclone sync source dest --log-file=combined.log --combined=combined.txt
```

### 7. Scheduling with Task Scheduler

**Create a scheduled task**
```powershell
$action = New-ScheduledTaskAction -Execute "powershell.exe" `
    -Argument "-File C:\Scripts\rclone_backup.ps1"

$trigger = New-ScheduledTaskTrigger -Daily -At 2am

$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" `
    -LogonType ServiceAccount -RunLevel Highest

Register-ScheduledTask -TaskName "Rclone Backup" `
    -Action $action `
    -Trigger $trigger `
    -Principal $principal `
    -Description "Daily rclone backup to cloud storage"
```

---

## 📁 Robocopy in PowerShell: Complete Guide

Robocopy (Robust File Copy) is a command-line directory replication and file copy utility that was first made available as a feature in Windows Vista and Windows Server 2008. It's built into Windows, so no installation is needed.

### 1. Built-in Availability

Robocopy is available in all modern Windows versions. No installation required - just open PowerShell and start using it.

**Verify availability**
```powershell
# Should display robocopy help
robocopy /?
```

### 2. Basic Syntax

```
robocopy <source> <destination> [<file>[ ...]] [<options>]
```

- `<source>`: Source directory path
- `<destination>`: Destination directory path
- `<file>`: Specific files to copy (wildcards supported, defaults to `*.*`)
- `<options>`: Copy, file, retry, logging, and job options

**Simple copy**
```powershell
# Copy all files from source to destination (no subdirectories)
robocopy C:\source D:\destination

# Copy with subdirectories (excluding empty ones)
robocopy C:\source D:\destination /s

# Copy with subdirectories (including empty ones)
robocopy C:\source D:\destination /e
```

### 3. Common Scenarios

**Mirror a directory** (exact copy with deletions)
```powershell
robocopy C:\source D:\destination /mir
```
The `/mir` option is equivalent to `/e /purge` - it mirrors a directory tree, deleting files in the destination that no longer exist in the source.

**Move files** (delete from source after copying)
```powershell
# Move files only
robocopy C:\source D:\destination /mov

# Move files and directories
robocopy C:\source D:\destination /move
```

**Copy with permissions and attributes**
```powershell
# Copy all file information (data, attributes, timestamps, ACL, owner, audit)
robocopy C:\source D:\destination /copyall /e

# Copy security only
robocopy C:\source D:\destination /sec /e
```

**Multi-threaded copy** (faster for large numbers of files)
```powershell
# Copy with 32 threads (default is 8)
robocopy C:\source D:\destination /mt:32 /e
```

### 4. Key Parameter Reference

#### Copy Options
| Option | Description |
|--------|-------------|
| `/s` | Copy subdirectories (excludes empty directories) |
| `/e` | Copy subdirectories (includes empty directories) |
| `/lev:<n>` | Copy only top n levels of the source directory tree |
| `/z` | Restartable mode (resume interrupted copies) |
| `/b` | Backup mode (override ACLs) |
| `/zb` | Restartable mode, fallback to backup mode if access denied |
| `/j` | Unbuffered I/O (recommended for large files) |
| `/copyall` | Copy all file info (data, attributes, timestamps, ACL, owner, audit) |
| `/purge` | Delete destination files that no longer exist in source |
| `/mir` | Mirror directory tree (equivalent to `/e /purge`) |
| `/mov` | Move files (delete from source after copy) |
| `/move` | Move files and directories |

#### File Selection Options
| Option | Description |
|--------|-------------|
| `/xf <file>` | Exclude files matching specified names/paths |
| `/xd <dir>` | Exclude directories matching specified names |
| `/xc` | Exclude changed files (same timestamp, different size) |
| `/xn` | Exclude newer files |
| `/xo` | Exclude older files |
| `/max:<n>` | Maximum file size (exclude larger files) |
| `/min:<n>` | Minimum file size (exclude smaller files) |
| `/maxage:<n>` | Maximum file age (exclude older files, n is days or YYYYMMDD) |
| `/minage:<n>` | Minimum file age (exclude newer files) |

#### Retry Options
| Option | Description |
|--------|-------------|
| `/r:<n>` | Number of retries on failed copies (default: 1,000,000) |
| `/w:<n>` | Wait time between retries in seconds (default: 30) |
| `/reg` | Save `/r` and `/w` settings in registry as defaults |

#### Logging Options
| Option | Description |
|--------|-------------|
| `/l` | List only (don't copy, delete, or timestamp) |
| `/v` | Verbose output, show all skipped files |
| `/log:<file>` | Write status output to log file (overwrite) |
| `/log+:<file>` | Write status output to log file (append) |
| `/tee` | Write output to console and log file |
| `/njh` | No job header in output |
| `/njs` | No job summary in output |
| `/eta` | Show estimated time of arrival |
| `/ts` | Include source file timestamps in output |

See the complete reference at Microsoft documentation: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy

### 5. Advanced Usage

**Restartable mode with backup fallback**
```powershell
robocopy C:\source D:\destination /zb /e /r:3 /w:10 /log:C:\logs\robocopy.log
```

**Low free space mode** (pauses when destination disk is low on space)
```powershell
# Pause when free space falls below 10% (default)
robocopy C:\source D:\destination /lfsm /e

# Pause when free space falls below 5GB
robocopy C:\source D:\destination /lfsm:5G /e
```

**Monitor for changes and re-run**
```powershell
# Run again when 5 changes detected
robocopy C:\source D:\destination /mon:5 /e

# Run again after 10 minutes if changes detected
robocopy C:\source D:\destination /mot:10 /e
```

**Copy only archive files** (reset archive attribute)
```powershell
# Copy files with archive attribute set, then reset it
robocopy C:\source D:\destination /m /e
```
This is useful for incremental backups.

**Test mode** (list what would be copied)
```powershell
# List only, don't copy anything
robocopy C:\source D:\destination /e /l /v
```

### 6. PowerShell Scripting with Robocopy

**Comprehensive backup script**
```powershell
# robocopy_backup.ps1
param(
    [Parameter(Mandatory=$true)]
    [string]$Source,
    [Parameter(Mandatory=$true)]
    [string]$Destination,
    [string]$LogPath = "C:\Logs\robocopy_$(Get-Date -Format 'yyyyMMdd_HHmmss').log",
    [int]$Retries = 3,
    [int]$WaitSeconds = 10
)

$robocopyArgs = @(
    $Source,
    $Destination,
    "/e",           # Include empty directories
    "/z",           # Restartable mode
    "/copyall",     # Copy all attributes
    "/dcopy:DAT",   # Copy directory data, attributes, timestamps
    "/r:$Retries",  # Retry count
    "/w:$WaitSeconds", # Wait between retries
    "/tee",         # Output to console and log
    "/log:$LogPath"
)

try {
    $startTime = Get-Date
    Write-Host "Starting robocopy from '$Source' to '$Destination' at $startTime" -ForegroundColor Cyan
    
    robocopy @robocopyArgs
    
    $exitCode = $LASTEXITCODE
    $endTime = Get-Date
    $duration = $endTime - $startTime
    
    switch ($exitCode) {
        0 { Write-Host "No files copied. No errors." -ForegroundColor Green }
        1 { Write-Host "All files copied successfully." -ForegroundColor Green }
        2 { Write-Host "Extra files in destination." -ForegroundColor Yellow }
        3 { Write-Host "Files copied with extra files." -ForegroundColor Yellow }
        { $_ -ge 8 } { Write-Error "At least one failure occurred!" }
        default { Write-Host "Exit code: $exitCode" -ForegroundColor Cyan }
    }
    
    Write-Host "Duration: $duration" -ForegroundColor Cyan
    return $exitCode
}
catch {
    Write-Error "Robocopy failed: $_"
    return -1
}
```

**Parallel robocopy jobs**
```powershell
# Parallel_Robocopy.ps1
$folders = @("Documents", "Pictures", "Videos", "Music")
$sourceBase = "C:\Users\username"
$destBase = "D:\Backup"
$maxJobs = 4

# Start parallel jobs
$jobs = foreach ($folder in $folders) {
    $source = Join-Path $sourceBase $folder
    $dest = Join-Path $destBase $folder
    
    Start-Job -Name "Robocopy_$folder" -ScriptBlock {
        param($src, $dst)
        robocopy $src $dst /e /z /copyall /r:3 /w:10 /log:"C:\Logs\robocopy_$folder.log"
        return $LASTEXITCODE
    } -ArgumentList $source, $dest
}

# Wait for all jobs
$results = $jobs | Wait-Job | Receive-Job
$jobs | Remove-Job

# Check results
foreach ($result in $results) {
    if ($result -ge 8) {
        Write-Warning "Job failed with exit code $result"
    }
}
```

### 7. Error Handling and Exit Codes

Robocopy uses specific exit codes to indicate results:

| Exit Code | Meaning |
|-----------|---------|
| 0 | No files copied. No errors. Files already exist. |
| 1 | All files copied successfully. |
| 2 | Extra files in destination. No files copied. |
| 3 | Files copied with extra files present. No failures. |
| 4-7 | Various combinations of mismatches and extra files. |
| 8+ | Some files or directories could not be copied (errors). |

**Checking exit codes in PowerShell**
```powershell
robocopy C:\source D:\destination /e
if ($LASTEXITCODE -ge 8) {
    Write-Error "Robocopy encountered failures (exit code: $LASTEXITCODE)"
}
elseif ($LASTEXITCODE -lt 8) {
    Write-Host "Robocopy completed successfully (exit code: $LASTEXITCODE)"
}
```

### 8. Scheduling with Task Scheduler

**Create a scheduled robocopy task**
```powershell
$taskName = "Daily Robocopy Backup"
$scriptPath = "C:\Scripts\robocopy_backup.ps1"

# Define action
$action = New-ScheduledTaskAction -Execute "powershell.exe" `
    -Argument "-ExecutionPolicy Bypass -File `"$scriptPath`" -Source `"C:\Data`" -Destination `"D:\Backup`""

# Define trigger (daily at 3 AM)
$trigger = New-ScheduledTaskTrigger -Daily -At "03:00:00"

# Define settings
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -RestartCount 3 `
    -RestartInterval (New-TimeSpan -Minutes 5)

# Register task
Register-ScheduledTask -TaskName $taskName `
    -Action $action `
    -Trigger $trigger `
    -Settings $settings `
    -RunLevel Highest `
    -Description "Daily robocopy backup of C:\Data to D:\Backup"
```

---

## 🎯 Best Practices

### Rclone Best Practices
1. **Always test with `--dry-run`** before running sync operations, especially when using `sync` which can delete files.
2. **Use `--progress`** for visibility during large transfers.
3. **Enable logging** with `--log-file` and `--log-level` for troubleshooting.
4. **Use `--no-traverse`** when copying only a few changed files to large destinations for significant speed improvements.
5. **Set up tab completion** to improve productivity: `rclone completion powershell | Out-String | Invoke-Expression`
6. **Secure your config** - the rclone config file contains access tokens, treat it like a password.

### Robocopy Best Practices
1. **Always test with `/l`** (list-only mode) first to verify what will be copied.
2. **Use appropriate retry settings** - avoid the default 1,000,000 retries for most operations. Set `/r:3 /w:10` for reasonable retries.
3. **Use `/z` (restartable mode)** for large files over unreliable networks.
4. **Enable logging** with `/log` and `/tee` to track operations.
5. **Be careful with `/mir` and `/purge`** - they delete files at the destination that don't exist in the source.
6. **Use `/mt`** to speed up copies of many small files.

---

This guide covers all essential aspects of using rclone and robocopy in PowerShell, from basic commands to advanced scripting and scheduling. Choose rclone when you need to work with cloud storage or remote servers, and robocopy for robust local file operations and directory synchronization.