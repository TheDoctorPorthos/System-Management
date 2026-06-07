# Guide 2: Termux (Android Linux Environment)

Termux behaves like a standard Linux shell (bash) but runs inside Android. The commands are the same as macOS Terminal’s, with a few setup notes.

## Before You Start

Run these once to prepare Termux for file operations:
```bash
pkg update && pkg upgrade    # Update package lists
termux-setup-storage         # Grant access to shared phone storage (~/storage)
pkg install rsync            # Install rsync if you plan to use it
```

Your internal shared folders (Downloads, DCIM, etc.) will be at `~/storage/shared/` after setup.

---

## Navigation

| Phase | Command | Notes |
|-------|---------|-------|
| **Procedure** | `pwd` | Print working directory |
| | `ls` | List files |
| | `cd <path>` | Change directory |
| | `pushd <path>` / `popd` | Jump and return |
| **Assessment** | `pwd` | Know exactly where you are |
| | `ls` | Check contents |
| | `ls -la` | Detailed view with hidden files |
| | `ls ~/storage/shared/Download` | Inspect your phone’s Download folder |
| **Execution** | `cd ~` | Home base (`/data/data/com.termux/files/home`) |
| | `cd ..` | Up one level |
| | `cd /storage/emulated/0/Documents` | Jump to shared storage directly |
| | `pushd ~/storage/shared/DCIM` … `popd` | Visit camera folder and return |

---

## Deletion

| Phase | Command | Notes |
|-------|---------|-------|
| **Procedure** | `rm <file>` | Permanently delete a file |
| | `rm -r <dir>` | Delete a directory and its contents |
| | `rm -rf <dir>` | Force-delete (extremely careful—no undo) |
| | `rmdir <dir>` | Only removes empty directories |
| **Assessment** | `ls *.apk` | List all .apk files before deleting |
| | `ls -R ~/storage/shared/Temp` | Recursively inspect a folder |
| | `echo *.log` | Shell-expand a pattern to see the file list |
| | `rm -i *.tmp` | Prompt for each deletion |
| **Execution** | `rm old.apk` | Delete a single file |
| | `rm *.bak` | Delete all .bak files |
| | `rm -r ~/storage/shared/OldStuff` | Delete a whole folder |
| | `rm -rf BadFolder` | Force-delete (only after `ls -R`) |

---

## Robust Copy & Sync (rsync)

| Phase | Command | Notes |
|-------|---------|-------|
| **Procedure** | `rsync [opts] source dest` | Copy/sync tool |
| | `-a` | Archive mode |
| | `-v` | Verbose |
| | `-n` / `--dry-run` | Assessment mode |
| | `--delete` | Mirror (delete extras in destination) |
| | `--remove-source-files` | Move files |
| **Assessment** | `rsync -avn ~/storage/shared/Download/ /sdcard/Backup/` | Dry-run a copy |
| | `rsync -avn --delete ~/Projects/ /Backup/` | Dry-run a mirror |
| **Execution** | `rsync -av ~/storage/shared/Download/ /sdcard/Backup/` | Real copy |
| | `rsync -av --delete ~/Projects/ /Backup/` | Mirror |
| | `rsync -av --remove-source-files ~/DCIM/*.jpg /Archive/` | Move photos |

---

## Folder Creation

| Phase | Command | Notes |
|-------|---------|-------|
| **Procedure** | `mkdir <dir>` | Create a directory |
| | `mkdir -p <nested/path>` | Create all parent folders as needed |
| **Assessment** | `ls` | Check existing folders |
| | `test -d "MyFolder" && echo "Exists"` | Check for existence |
| **Execution** | `mkdir Notes` | Single folder |
| | `mkdir -p Projects/2025/code/logs` | Nested tree in one shot |

---

## The Training Loop (Same for Both Guides)

1. **Procedure**: Read the command you want to learn.  
2. **Assessment**: Run the safe preview version.  
3. **Execution**: Only when the preview looks right, run the real command.

Use these separate guides as your side-by-side practice companions. Once the macOS flow feels natural, switching to Termux will feel almost identical. Let me know when you’re ready to expand these with file viewing, moving/renaming, or permissions.