Using Notepad++ for editing your scripts ensures you don't accidentally get stuck with invisible formatting or broken character encodings.

Since you prefer a local-first ecosystem where directory changes matter, we can expand your `syscheck` command to include automated checks for directory integrity. This includes flagging massive unexpected changes, verifying that your crucial storage paths are online and accessible, and monitoring local storage limits.

Here is how to update your routine to include directory health, followed by how to make Notepad++ your default environment for editing your PowerShell configuration.

## 1. The Directory Health Commands

Here are the specific blocks we are adding to your routine to monitor your local files and sync states.

### Verify Critical Paths are Mounted and Online

PowerShell

```
$CriticalPaths = @("C:\", "D:\") # Add any external drives or specific root folders here
foreach ($Path in $CriticalPaths) {
    $State = Test-Path $Path
    Write-Host "Path [$Path] Status: " -NoNewline
    if ($State) { Write-Host "ONLINE" -ForegroundColor Green } else { Write-Host "OFFLINE/MISSING" -ForegroundColor Red }
}
```

- **What it does:** Ensures that internal volumes, micro-SD cards, or encrypted vaults are actually mounted and readable before your background sync engines attempt to write to them.
    

### Spot Check Unexpected Massive Changes (File Drift)

PowerShell

```
$TargetDir = "$HOME\Documents" # Change this to your primary local repository or vault
$Cutoff = (Get-Date).AddDays(-1)
$RecentFiles = Get-ChildItem -Path $TargetDir -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -gt $Cutoff }
Write-Host "Files modified in the last 24 hours: $($RecentFiles.Count)"
```

- **What it does:** Counts how many files have changed in your core data directories over the last day.
    
- **Why it matters:** If you haven't touched your files since yesterday afternoon, this number should be close to zero. If it reads "450 files changed," it immediately alerts you that a sync engine, a background process, or an automated script did heavy work while you were away.
    

## 2. Updated Master Script: `syscheck`

Let's integrate these directory health validations right into your master morning check script.

PowerShell

```
function Invoke-MorningCheck {
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host "     RUNNING MORNING SYSTEM DIAGNOSTICS      " -ForegroundColor Cyan
    Write-Host "=============================================" -ForegroundColor Cyan

    Write-Host "`n[1/5] Checking Critical Storage Paths..." -ForegroundColor Yellow
    # Add your exact local directory paths or drive roots to this array:
    $CriticalPaths = @("$HOME\Documents", "C:\") 
    foreach ($Path in $CriticalPaths) {
        if (Test-Path $Path) {
            Write-Host "  [✓] Accessible: $Path" -ForegroundColor Green
        } else {
            Write-Host "  [X] NOT FOUND : $Path" -ForegroundColor Red
        }
    }

    Write-Host "`n[2/5] Checking Directory File Drift (Last 24 Hours)..." -ForegroundColor Yellow
    # Monitors recent modifications to catch unexpected file rewrites or deletions
    $WatchDir = "$HOME\Documents"
    if (Test-Path $WatchDir) {
        $Changes = Get-ChildItem -Path $WatchDir -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -gt (Get-Date).AddDays(-1) }
        Write-Host "  Total modified files in target directory: $($Changes.Count)" -ForegroundColor WindowsAccent
    }

    Write-Host "`n[3/5] Checking Component Store Health (DISM)..." -ForegroundColor Yellow
    DISM /Online /Cleanup-Image /CheckHealth

    Write-Host "`n[4/5] Checking Active Core Services..." -ForegroundColor Yellow
    # Adjust names to match your precise background sync/tunnel daemons
    Get-Service -Name "Syncthing", "Tailscale", "WinDefend" -ErrorAction SilentlyContinue | Format-Table Name, Status

    Write-Host "[5/5] Top 5 Resource Consuming Processes..." -ForegroundColor Yellow
    Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 ProcessName, @{Name="CPU(s)";Expression={$_.CPU}}, @{Name="RAM(MB)";Expression={[math]::round($_.WorkingSet / 1MB, 2)}} | Format-Table

    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host " Diagnostics Complete. For deep scan use: sfc /scannow" -ForegroundColor Gray
    Write-Host "=============================================" -ForegroundColor Cyan
}

Set-Alias -Name syscheck -Value Invoke-MorningCheck
```

## 3. Wiring Up Notepad++ to PowerShell

To ensure you never have to mess with standard Windows Notepad when tweaking your environment, you can set up a persistent alias. This lets you open your profile script directly inside Notepad++ straight from the command line.

### Step 1: Open Your Profile Using Notepad++ One Last Time

Run this command to open your configuration using the direct file path to your Notepad++ installation (adjust the path if you installed the 32-bit version or used a non-standard directory):

PowerShell

```
& "C:\Program Files\Notepad++\notepad++.exe" $PROFILE
```

### Step 2: Paste the Automation Alias

Once your profile opens in Notepad++, replace your old script with the updated 5-step version above. Then, paste this line at the very bottom of the file:

PowerShell

```
# Quick shortcut to edit this profile anytime using Notepad++
function Edit-Profile { & "C:\Program Files\Notepad++\notepad++.exe" $PROFILE }
Set-Alias -Name edpro -Value Edit-Profile
```

### Step 3: Save and Refresh

1. Save the file in Notepad++ (`Ctrl + S`).
    
2. Close your administrative PowerShell window and open a fresh one.
    

From this morning forward, your routine is entirely streamlined. You type **`syscheck`** to inspect your drives, file modifications, and sync services. If you ever want to update a path or add a new daemon to the script, you simply type **`edpro`**, and your environment configuration drops instantly into a clean Notepad++ tab.