Here are the exact, step-by-step instructions to create a clean, isolated Python environment.

Since your architecture requires maximum speed and minimal system bloat, we are going to use **`uv`** (by Astral). In 2026, it is the industry standard—written in Rust, it is 10x to 100x faster than the older tools, and it replaces about four different legacy Python programs with a single command line.

### Step 1: Install the `uv` Engine (System Level)

First, you need to install the tool on your machine. Open your system's terminal (Command Prompt/PowerShell on Windows, or Terminal on Mac).

- **If you are on your Windows machine (Galaxy Book4 Ultra):**
    
    Copy and paste this into PowerShell and hit Enter:
    
    PowerShell
    
    ```
    powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
    ```
    

```
*   **If you are on your Mac (M1 iMac):**
    Copy and paste this into Terminal and hit Enter:
    ```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

_Once this finishes, close the terminal and open a completely new one so your system registers the new command._

### Step 2: Create Your Project Directory

Navigate to where you want your code to live, and tell `uv` to initialize a new project.

In your terminal, type:

Bash

```
uv init my-rag-project
```

This creates a new folder called `my-rag-project`. It automatically sets up the basic files you need, including a `pyproject.toml` (which acts as the blueprint for your project's rules and dependencies).

Next, move into that folder:

Bash

```
cd my-rag-project
```

### Step 3: Create the Virtual Environment (The "Isolated Kitchen")

Now, inside your project folder, tell `uv` to build the isolated environment.

Type this and hit Enter:

Bash

```
uv venv
```

- **What this does:** It instantly creates a hidden folder named `.venv` inside your project directory. This folder contains a completely private copy of Python.
    

### Step 4: Install Your Packages Safely

Instead of polluting your computer's global system, you now install the specific tools you need for this project (like the backend server and AI tools).

Type this and hit Enter:

Bash

```
uv add fastapi uvicorn chromadb
```

- **What this does:** `uv` will download those packages and lock them _only_ inside that `.venv` folder. It will also update your `pyproject.toml` file so you always have a written record of exactly what is installed.
    

### Step 5: Connect It to VS Code

Now that your environment is built, you need to tell VS Code to use it.

1. Open **VS Code**.
    
2. Go to **File > Open Folder** and select your `my-rag-project` folder.
    
3. Open any Python file (like `main.py`).
    
4. Look at the very bottom-right corner of the VS Code window. You will see a Python version number (e.g., `3.12.0`). Click on it.
    
5. A menu will drop down from the top of the screen asking you to "Select Interpreter."
    
6. Look for the option that has `('.venv': venv)` next to it and select it.
    

**You are now fully set up.**

Your AI autocomplete (Codeium) will read from this isolated folder. Your linter (Ruff) will format against it. And if you make a catastrophic mistake, you can simply delete the `.venv` folder and run `uv sync` to rebuild it instantly without touching your operating system.