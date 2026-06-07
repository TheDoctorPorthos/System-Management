This is where managing your environments directly through CLIs really shines. We can build a master function in your bash profile that lets you sync any individual vault on the fly, or loop through all of them with a single command.

Here is the master script. I have set it up with your "Systems Management" folder and added a placeholder for your "Research" vault (or any other vaults you migrate).

### The Master Sync Script

1. Open your profile:
    
    Bash
    
    ```
    nano $HOME/.bashrc
    ```
    
2. Delete the old `sync-systems` function we made earlier, and paste this robust version in its place:
    

Bash

```
# Core sync engine (handles the actual Git commands)
function _run_git_sync() {
    local vault_name="$1"
    local vault_path="$2"
    
    echo "========================================"
    echo "🔄 Syncing: $vault_name"
    
    if [ -d "$vault_path" ]; then
        cd "$vault_path" || return
        git add .
        git commit -m "Android CLI sync $(date +'%Y-%m-%d %H:%M:%S')"
        git pull --rebase origin main
        git push origin main
        echo "✅ $vault_name synced successfully!"
    else
        echo "❌ Error: Cannot find directory at $vault_path"
    fi
}

# The Master Command
function vaultsync() {
    # 1. Define your vault paths here
    local sys_path="/storage/emulated/0/Documents/Systems-Management-"
    local res_path="/storage/emulated/0/Documents/YourResearchVault" # Update this path!

    # 2. Route the command based on your input
    case "$1" in
        "systems")
            _run_git_sync "Systems Management" "$sys_path"
            ;;
        "research")
            _run_git_sync "Research Vault" "$res_path"
            ;;
        "all")
            echo "🚀 Initiating Bulk Vault Sync..."
            _run_git_sync "Systems Management" "$sys_path"
            _run_git_sync "Research Vault" "$res_path"
            echo "========================================"
            echo "🎉 All vaults are up to date!"
            ;;
        *)
            echo "Usage: vaultsync [systems|research|all]"
            echo "Example: vaultsync all"
            ;;
    esac
    
    # Return to home directory when finished
    cd $HOME
}
```

3. Save and exit (`Ctrl + O`, `Enter`, then `Ctrl + X`).
    
4. Apply the changes:
    
    Bash
    
    ```
    source $HOME/.bashrc
    ```
    

### How to Use Your New Engine

Now, you have total control from the terminal.

- If you just finished tweaking some PowerShell scripts and only want to push that specific vault, type:
    
    Bash
    
    ```
    vaultsync systems
    ```
    
- If you finish a writing session and want to push your research vault:
    
    Bash
    
    ```
    vaultsync research
    ```
    
- **The Bulk Sync:** When you wake up and want to pull all changes down from your iMac across every vault simultaneously, or you are packing up for the day and want to push everything to the cloud at once, simply type:
    
    Bash
    
    ```
    vaultsync all
    ```
    

Whenever you migrate a new Obsidian vault using that hardened `--separate-git-dir` architecture, you just open `.bashrc`, add the new path variable to the list, and pop it into the `case` statement.