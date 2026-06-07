The short answer is: **The exact same script won't work across all three, but the exact same _concept_ will.**

You cannot copy and paste that specific script to your Windows laptop or iMac for two main reasons:

1. **File Paths:** Every operating system maps its hard drive differently. The script currently points to `/storage/emulated/0/...` which only exists on Android. Mac uses `/Users/YourName/...` and Windows uses `C:\Users\YourName\...`.
    
2. **The Shell Language:** That script is written in Bash. While your Mac natively understands Bash/Zsh, your Windows laptop natively uses PowerShell.
    

Since your Windows laptop is your source of truth, you will want a dedicated PowerShell version of this sync engine.

Here is how you replicate that exact same bulk-syncing power on your Windows machine using PowerShell:

### The Windows PowerShell Version

To set this up on Windows, you will add it to your PowerShell `$PROFILE` (the Windows equivalent of `.bashrc`).

1. Open PowerShell and open your profile in Notepad by running:
    
    PowerShell
    
    ```
    notepad $PROFILE
    ```
    
    _(If it asks if you want to create the file, click Yes)._
    
2. Paste this PowerShell translation of your engine:
    

PowerShell

```
# Core sync engine
function Invoke-GitSync {
    param (
        [string]$VaultName,
        [string]$VaultPath
    )
    
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "🔄 Syncing: $VaultName" -ForegroundColor Cyan
    
    if (Test-Path $VaultPath) {
        Set-Location $VaultPath
        git add .
        git commit -m "Windows CLI sync $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        git pull --rebase origin main
        git push origin main
        Write-Host "✅ $VaultName synced successfully!" -ForegroundColor Green
    } else {
        Write-Host "❌ Error: Cannot find directory at $VaultPath" -ForegroundColor Red
    }
}

# The Master Command
function vaultsync {
    param (
        [string]$Target = "all"
    )

    # 1. Define your Windows paths here!
    $SysPath = "C:\Users\YOUR_USERNAME\Documents\Systems-Management-"
    $ResPath = "C:\Users\YOUR_USERNAME\Documents\YourResearchVault"

    # 2. Route the command
    switch ($Target.ToLower()) {
        "systems" { Invoke-GitSync -VaultName "Systems Management" -VaultPath $SysPath }
        "research" { Invoke-GitSync -VaultName "Research Vault" -VaultPath $ResPath }
        "all" {
            Write-Host "🚀 Initiating Bulk Vault Sync..." -ForegroundColor Yellow
            Invoke-GitSync -VaultName "Systems Management" -VaultPath $SysPath
            Invoke-GitSync -VaultName "Research Vault" -VaultPath $ResPath
            Write-Host "========================================" -ForegroundColor Cyan
            Write-Host "🎉 All vaults are up to date!" -ForegroundColor Green
        }
        default {
            Write-Host "Usage: vaultsync systems | research | all"
        }
    }
    
    # Return to home directory
    Set-Location ~
}
```

3. Update the `$SysPath` and `$ResPath` variables to match where those folders actually live on your laptop, save the Notepad file, and close it.
    
4. Reload your PowerShell profile by running: `. $PROFILE`
    

### What about the iMac?

If you want this on your iMac as well, you would take the original Bash script we wrote for Termux, paste it into your Mac's `~/.zshrc` file, and simply update the folder paths to match your macOS Documents folder.

With this setup, you can type `vaultsync all` in PowerShell on your laptop, walk away, and then later type `vaultsync all` in Termux on your phone, and the two devices will perfectly hand off your data through GitHub!