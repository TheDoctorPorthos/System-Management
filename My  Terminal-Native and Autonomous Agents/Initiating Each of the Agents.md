Because these three frameworks operate with different languages and memory architectures, they must be launched from their specific, isolated environments to avoid dependency collisions.

Here is the manual boot sequence for each engine within your master directory.

### 1. OpenCode Engine

- **Design Purpose:** The **Codebase Architect**. OpenCode is designed for granular, privacy-first codebase manipulation. It excels at fast, localized refactoring, semantic directory searches, and multi-file editing while routing logic securely through your local models. It is the tool you use when you want to directly manipulate your Python scripts or PowerShell wrappers.
    
- **Startup Steps:**
    
    1. Open PowerShell.
        
    2. Navigate to its isolated compartment: `Set-Location "~\Moncriffe_MAD_Assistant_Directory\OpenCode_Engine"`
        
    3. Activate its dedicated Python sandbox so it does not conflict with Hermes: `.\venv\Scripts\Activate.ps1`
        
    4. Launch the terminal interface: `opencode`
        

### 2. Hermes Core

- **Design Purpose:** The **Continuous Workflow Assistant**. Hermes is an always-on engine designed to maintain a closed learning loop. It is built to handle background tasks, manage system schedules, and automatically write new "skills" as it learns your daily workflows.
    
- **Startup Steps:**
    
    1. Open a new PowerShell tab.
        
    2. Navigate to its compartment: `Set-Location "~\Moncriffe_MAD_Assistant_Directory\Hermes_Core"`
        
    3. Activate its dedicated Python sandbox: `.\venv\Scripts\Activate.ps1`
        
    4. Start the agent process: `hermes start` (or your specific configuration script).
        

### 3. MiMo Workspace

- **Design Purpose:** The **Long-Horizon Execution Specialist**. As an advanced fork of OpenCode, MiMo Code is built specifically to execute massive, multi-step operations (200+ steps) autonomously. Its persistent SQLite memory architecture (utilizing its Dream and Distill functions) makes it the ideal engine to unleash on complex data pipelining or deep research scraping where standard models would lose context.
    
- **Startup Steps:**
    
    1. Open a new PowerShell tab.
        
    2. Navigate strictly to its workspace: `Set-Location "~\Moncriffe_MAD_Assistant_Directory\MiMo_Workspace"`
        
        _(Note: You do not need to activate a Python `venv` here because MiMo is installed globally via Node.js)._
        
    3. Launch the agent: `mimo`
        
        _(By launching it from this specific directory, you force MiMo to read and write its `MEMORY.md` and database checkpoints directly into the MAD Assistant folder, anchoring its memory securely.)_
        

Typing these paths and activating virtual environments every morning will quickly become tedious. The most efficient way to manage this architecture is to script the `Launch-Jack.ps1` menu we discussed previously, allowing you to trigger any of these boot sequences with a single keystroke when you start your machine.

[Automating workflows with Xiaomi's MiMo Code](https://www.youtube.com/watch?v=Gg_iTrxFY_g)

This walkthrough demonstrates how to manage large projects and automate complex local development pipelines using the newly released MiMo Code framework.