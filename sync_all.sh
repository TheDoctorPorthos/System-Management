#!/bin/bash

VAULTS_BASE="$HOME/storage/shared/Documents/2026 Vaults"
DISS_DIR="$HOME/storage/shared/Documents/Word Docs/Dissertation Drafts"
RCLONE_CONF="$HOME/.config/rclone/rclone.conf"
LOG_DIR="$HOME/storage/shared/Termux_Operations/Sync Logs"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

mkdir -p "$LOG_DIR"

echo "=============================="
echo "  VAULT & DISSERTATION SYNC"
echo "  $TIMESTAMP"
echo "=============================="

# --- Configuration Check ---
if [ ! -f "$RCLONE_CONF" ]; then
    echo ""
    echo "[WARN] rclone not configured. Run:  rclone config"
    echo "        Add remotes named:  gdrive  and  onedrive"
    echo ""
fi

# --- GitHub Push for Each Vault (in background) ---
github_pids=()
for vault in "$VAULTS_BASE"/*/; do
    name=$(basename "$vault")
    (
        cd "$vault" || exit
        REMOTE=$(git remote get-url origin 2>/dev/null)
        if [ -z "$REMOTE" ]; then
            echo "[SKIP] $name  no GitHub remote set"
            echo "       To add:  cd '$vault' && git remote add origin <URL>"
            exit
        fi
        git add -A 2>/dev/null
        if git diff --cached --quiet; then
            echo "[OK]   $name  nothing new to commit"
        else
            git commit -m "Auto-sync $(date +'%Y-%m-%d %H:%M')" > /dev/null 2>&1
            if git push origin HEAD 2>&1; then
                echo "[PUSH] $name  pushed to GitHub"
            else
                echo "[FAIL] $name  push failed"
            fi
        fi
    ) &
    github_pids+=($!)
done

# --- Google Drive Sync (rclone) ---
gdrive_pid=""
if rclone listremotes 2>/dev/null | grep -q "gdrive:"; then
    (
        echo "[SYNC] 2026 Vaults -> Google Drive"
        rclone sync "$VAULTS_BASE" gdrive:vaults --progress --log-file "$LOG_DIR/gdrive_$(date +%Y%m%d_%H%M%S).log" 2>&1 | tail -3
        echo "[DONE] Google Drive sync complete"
    ) &
    gdrive_pid=$!
else
    echo "[SKIP] Google Drive  no 'gdrive' remote (run: rclone config)"
fi

# --- OneDrive Sync (rclone) ---
onedrive_pid=""
if rclone listremotes 2>/dev/null | grep -q "onedrive:"; then
    (
        echo "[SYNC] Dissertation Drafts -> OneDrive"
        rclone sync "$DISS_DIR" onedrive:dissertation-drafts --progress --log-file "$LOG_DIR/onedrive_$(date +%Y%m%d_%H%M%S).log" 2>&1 | tail -3
        echo "[DONE] OneDrive sync complete"
    ) &
    onedrive_pid=$!
else
    echo "[SKIP] OneDrive  no 'onedrive' remote (run: rclone config)"
fi

# --- Wait for all background jobs ---
echo ""
echo "--- Running syncs in parallel ---"
for pid in "${github_pids[@]}"; do wait "$pid" 2>/dev/null; done
[ -n "$gdrive_pid" ] && wait "$gdrive_pid" 2>/dev/null
[ -n "$onedrive_pid" ] && wait "$onedrive_pid" 2>/dev/null

echo ""
echo "=============================="
echo "  SYNC COMPLETE"
echo "  Logs: $LOG_DIR"
echo "=============================="
