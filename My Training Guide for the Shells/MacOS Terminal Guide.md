You’ve got it. Here are two standalone guides, each built around your **Procedure → Assessment → Execution** training loop. The commands are almost identical, but I’ve separated them so you can treat them as distinct reference sheets while you practice.

---

# Guide 1: macOS Terminal (zsh/bash)

Use this when you’re in the Terminal app on a Mac.

## Navigation

| Phase | Command | What it does |
|-------|---------|--------------|
| **Procedure** | `pwd` | Print working directory (where am I?) |
| | `ls` | List files and folders |
| | `cd <path>` | Change directory |
| | `pushd <path>` / `popd` | Jump to a directory and return later |
| **Assessment** | `pwd` | Confirm your current location |
| | `ls` | See what’s here before you do anything |
| | `ls -la` | Show detailed list, including hidden items |
| | `ls /some/other/path` | Inspect a folder without moving |
| **Execution** | `cd ~` | Go home |
| | `cd Documents/Projects` | Move into a relative path |
| | `cd ..` | Up one level |
| | `cd /absolute/path` | Jump anywhere instantly |
| | `pushd /tmp` … `popd` | Visit /tmp, then return |

---

## Deletion

| Phase | Command | What it does |
|-------|---------|--------------|
| **Procedure** | `rm <file>` | Permanently delete a file |
| | `rm -r <dir>` | Delete a directory and its contents |
| | `rm -rf <dir>` | Force-delete a directory (no prompts) |
| | `rmdir <dir>` | Delete an empty directory only |
| **Assessment** | `ls *.tmp` | See exactly which files match a pattern |
| | `ls -R DangerousFolder` | List everything inside a folder recursively |
| | `echo *.log` | Shell expands the wildcard, showing what would be deleted |
| | `rm -i *.bak` | Prompt for each file before deleting (interactive assessment) |
| **Execution** | `rm old.txt` | Delete a single file |
| | `rm *.tmp` | Delete all .tmp files in the current directory |
| | `rm -r OldProject` | Delete a folder and everything inside |
| | `rm -rf BadFolder` | Force-delete without confirmation (use only after `ls -R`) |

---

## Robust Copy & Sync (rsync)

| Phase | Command | What it does |
|-------|---------|--------------|
| **Procedure** | `rsync [opts] source dest` | Copy/sync with full control |
| | `-a` | Archive mode (preserve permissions, recurse) |
| | `-v` | Verbose (show files) |
| | `-n` / `--dry-run` | Assessment mode |
| | `--delete` | Mirror (delete extras in dest) |
| | `--remove-source-files` | Move files (delete from source) |
| **Assessment** | `rsync -avn ~/Documents/ /Volumes/Backup/Docs/` | Dry-run a simple copy |
| | `rsync -avn --delete ~/Projects/ /Backup/Projects/` | Dry-run a mirror (shows deletions) |
| **Execution** | `rsync -av ~/Documents/ /Backup/Docs/` | Perform the actual copy |
| | `rsync -av --delete ~/Projects/ /Backup/Projects/` | Mirror (careful!) |
| | `rsync -av --remove-source-files ~/Desktop/*.png /Archive/` | Move files |

---

## Folder Creation

| Phase | Command | What it does |
|-------|---------|--------------|
| **Procedure** | `mkdir <dir>` | Create a new directory |
| | `mkdir -p <path>` | Create nested directories at once |
| **Assessment** | `ls` | See existing folders before creating |
| | `test -d "NewFolder" && echo "Exists"` | Check if a directory already exists |
| **Execution** | `mkdir MyProject` | Create a single folder |
| | `mkdir -p Projects/2025/Data/Logs` | Create the whole tree in one command |

---

