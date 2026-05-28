Termux gives you a full, powerful Linux environment right on your device. Navigating it relies entirely on a few core text commands.
Here is everything you need to confidently move around your directories.
## The "Big Three" Commands
Whenever you open Termux, you are dropped into your "home" directory. Think of these three commands as your eyes and legs.
 * **pwd (Print Working Directory):** Tells you exactly where you are right now. If you ever get lost, type this and hit Enter. In Termux, your home path will look something like /data/data/com.termux/files/home.
 * **ls (List):** Shows you the files and folders inside your current directory.
   * Use ls -l to see a detailed list (file sizes, permissions, and dates).
   * Use ls -a to see "hidden" files (files that start with a dot, like .bashrc).
 * **cd (Change Directory):** Moves you into a new folder. For example, if you see a folder named "projects" when you type ls, you can move into it by typing cd projects.
## Essential Navigation Shortcuts
Typing out full folder paths gets tedious. Use these shortcuts with the cd command to jump around quickly:
| Command | What it does |
|---|---|
| **cd ..** | Moves you **up** one level to the parent directory. (e.g., from home/projects to home). |
| **cd ~** | Instantly teleports you back to your **home** directory, no matter where you are. Just typing cd and hitting Enter usually does this too. |
| **cd -** | Jumps back to the **previous** directory you were in (like the "Back" button in a web browser). |
| **cd /** | Takes you to the absolute root of the file system. (Note: Without a rooted device, you won't have permission to do much here). |
> **Pro-Tip:** Use the **Tab** key. If you type cd pro and hit the Tab key on your virtual keyboard, Termux will auto-complete it to cd projects if that's the only folder starting with "pro". This saves a massive amount of typing.
> 
## Crucial Termux Step: Accessing Your Device's Files
By default, Termux is isolated and cannot see the regular files (like your downloads or documents) on your device. To navigate to your normal storage, you have to grant Termux permission.
 1. Run this command: termux-setup-storage
 2. A pop-up will ask for permission to access your device's files. Allow it.
 3. Termux will create a new folder in your home directory called storage.
You can now navigate to your device's internal storage by typing:
cd ~/storage/shared
From there, running ls will reveal your familiar Android folders like Download, Documents, and DCIM.

---
Now that you can navigate, you need to be able to manipulate your environment. In the terminal, creating, moving, and deleting are handled by a few simple, powerful tools.
Here is your toolkit for managing your workspace.
## Creating Files and Folders
You will generally create folders to organize your projects, and files to hold your code or notes.
 * **mkdir (Make Directory):** Creates a new folder.
   * *Example:* Typing mkdir ai_lab creates a folder named "ai_lab" in your current location.
 * **touch:** Creates a new, completely empty file. It is useful for quickly setting up placeholder files before you write to them.
   * *Example:* Typing touch bridge.py creates an empty Python file.
## Moving and Renaming
In Linux environments like Termux, moving a file and renaming a file are actually the exact same action, handled by the same command. You are essentially "moving" a file from its old name/location to a new name/location.
 * **mv (Move):** Moves or renames files and directories.
   * *To rename:* mv old_name.py new_name.py
   * *To move a file into a folder:* mv bridge.py ai_lab/ (This places the file into the "ai_lab" directory).
   * *To move a file out of a folder (up one level):* mv bridge.py ..
## Copying
When you want to duplicate a file instead of moving it, you use the copy command.
 * **cp (Copy):** Duplicates files.
   * *Example:* cp bridge.py backup_bridge.py creates a duplicate file in the same folder.
 * **cp -r (Copy Recursive):** You cannot copy a folder with just cp because the terminal needs permission to go inside the folder and copy everything within it. The -r flag tells it to copy the folder and all its contents.
   * *Example:* cp -r ai_lab/ ai_lab_backup/
## Deleting
Terminal deletions are permanent. There is no "Recycle Bin" or "Trash" folder to recover things from, so always double-check your spelling before hitting Enter.
 * **rm (Remove):** Deletes a file.
   * *Example:* rm test_script.py permanently deletes that file.
 * **rmdir (Remove Directory):** Deletes a folder, but *only* if the folder is completely empty.
 * **rm -r (Remove Recursive):** Deletes a folder and everything inside it, including other folders and files.
> **Warning:** Be extremely careful with the command rm -rf. The -f stands for "force" and will instantly delete a folder and all its contents without asking you for confirmation.
> 

---
To write code or edit files directly in Termux, you need a command-line text editor. These run entirely within the terminal interface, without opening a separate app.
Here are the three best options, ranging from beginner-friendly to professional-grade.
## 1. Nano (The Quick and Easy Option)
Nano is the standard, no-frills editor. It is perfect for making quick tweaks to configuration files or drafting simple text.
 * **Installation:** pkg install nano
 * **How to open:** Type nano bridge.py to create or open that file.
 * **Navigation:** Use your keyboard's arrow keys. The commands to save and exit are listed at the bottom of the screen (the ^ symbol represents the Ctrl key).
 * **To save and exit:** Press Ctrl + O (to save), hit Enter to confirm the file name, then press Ctrl + X (to exit).
## 2. Micro (The Modern Choice)
If you are writing complex Python scripts to build things like RAG pipelines or local AI architectures, Nano can feel a bit restrictive. **Micro** is a modern terminal editor that feels much more like a standard desktop coding app.
 * **Installation:** pkg install micro
 * **How to open:** micro bridge.py
 * **Why it's great:** It supports standard desktop keyboard shortcuts (Ctrl + S to save, Ctrl + C to copy, Ctrl + V to paste). It also supports syntax highlighting for coding and recognizes touch—you can tap the screen to move your cursor directly instead of relying solely on arrow keys.
 * **To save and exit:** Press Ctrl + S, then Ctrl + Q.
## 3. Neovim (The Powerhouse)
If you plan to spend a lot of time managing projects and coding purely in the CLI, Neovim (an upgraded version of Vim) is the industry standard. It has a steep learning curve because you navigate and edit using specialized keyboard commands rather than a mouse or arrow keys, but it is incredibly efficient once mastered.
 * **Installation:** pkg install neovim
 * **How to open:** nvim script.py
 * **To save and exit:** You must press Esc to ensure you are in "Command Mode," type :wq (write and quit), and hit Enter.
> **Recommendation:** Start by installing **Micro**. It bridges the gap perfectly between a simple terminal tool and a capable coding environment, making it ideal for managing your Python files and local model routing scripts directly from your device.
> 

---
To get to your device's Documents folder, you need to go through the shared directory that Termux created when you set up storage.
If you are currently sitting inside the storage folder, type:
```bash
cd shared/Documents

```
If you are somewhere else in Termux and want to jump directly to Documents in one command, use the absolute path (the ~ represents your home directory):
```bash
cd ~/storage/shared/Documents

```
**A quick reminder on Linux rules:**
Termux is case-sensitive. You must type Documents with a capital **D**, or Termux will tell you the folder doesn't exist.
Once you are there, you can run ls to see all the files you currently have saved in your Android device's standard Documents folder. This is a great place to store your Obsidian vault or research PDFs so both Termux and your Android apps can access them simultaneously.
