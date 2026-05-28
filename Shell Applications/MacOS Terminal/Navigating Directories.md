Navigating the file system in macOS Terminal is done with a handful of simple commands. The default shell on modern macOS is **zsh**, but these commands work in bash and other shells too.

Here are the step‑by‑step details, from checking where you are to moving around efficiently.

---

## 1. See your current location
```bash
pwd
```
`pwd` (“print working directory”) shows the full path of the folder you’re in.  
Example output: `/Users/yourname/Documents`

---

## 2. List what’s in the current folder
```bash
ls
```
Shows files and folders (not hidden ones).  
More useful variants:
```bash
ls -l      # detailed list (permissions, size, date)
ls -a      # include hidden files (names starting with .)
ls -la     # detailed + hidden
```

---

## 3. Change directory (`cd`)
`cd` (change directory) is how you move around.

### Go to a specific absolute path
```bash
cd /Applications
```
Begins with `/` → absolute path from the root of the drive.

### Go to a relative path
```bash
cd Documents
```
No leading `/` → looks for `Documents` inside the **current** working directory.

### Move up one level (parent folder)
```bash
cd ..
```
`.` means “current directory”, `..` means “parent”.  
You can chain them: `cd ../..` goes up two levels.

### Go to your home folder
```bash
cd ~
```
or simply:
```bash
cd
```
The tilde `~` is shorthand for `/Users/yourusername`.

### Return to the previous directory
```bash
cd -
```
Switches back to the last folder you were in. Very handy.

### Jump to the root of the drive
```bash
cd /
```
The root directory contains system folders like `/Applications`, `/Users`, `/System`.

---

## 4. Use tab completion
When typing a path, hit the **Tab** key to auto‑complete directory or file names.  
If there are multiple possibilities, press Tab twice to see a list.

Example:  
`cd Doc` <kbd>Tab</kbd> → automatically fills `Documents/`

This works with relative and absolute paths, even with `~`.

---

## 5. Handle folder names with spaces
Enclose the path in quotes or escape spaces with a backslash.
```bash
cd "My Projects"
# or
cd My\ Projects
```
Tab completion does this automatically – just start typing and press Tab.

---

## 6. Open the current folder in Finder
```bash
open .
```
`open .` opens the current directory in a Finder window.  
You can also open any path: `open ~/Desktop`

---

## 7. Drag a folder from Finder into Terminal
You can drag any folder from a Finder window and drop it into Terminal. Its full path will be pasted at the cursor, properly escaped if it contains spaces. This is a quick way to build a `cd` command.

---

## 8. List the directory tree (optional, but helpful)
macOS doesn’t include `tree` by default. A rough alternative:
```bash
ls -R
```
Or install `tree` via Homebrew (`brew install tree`) and then run:
```bash
tree
```

---

## Quick reference cheat sheet

| Command         | Action                                      |
|-----------------|---------------------------------------------|
| `pwd`           | Show current directory                      |
| `ls`            | List files/folders                         |
| `ls -la`        | Detailed list with hidden files             |
| `cd /path`      | Go to absolute path                        |
| `cd folder`     | Go into a subfolder                         |
| `cd ..`         | Go up one level                             |
| `cd ~` or `cd`  | Go to home directory                        |
| `cd -`          | Go back to previous directory               |
| `open .`        | Open current folder in Finder               |

With these commands and the Tab key, you can navigate any folder structure quickly and accurately. The terminal’s working directory is separate from Finder, so moving in the terminal does not change which Finder window is open, and vice versa.