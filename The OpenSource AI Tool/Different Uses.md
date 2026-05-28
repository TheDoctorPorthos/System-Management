It is fantastic that you already have OpenCode up and running on your UltraBook. It is a incredibly potent environment for terminal-driven workflows, especially when you pair it with the digital autonomy of local-first models.
For an academic social researcher, an agentic terminal tool like this opens up some unique possibilities that go far beyond what standard web-interface chat applications can do.
## 1. Research & Methodological Use Cases
Because OpenCode can run local scripts, parse files, and interact with Model Context Protocol (MCP) servers or web-fetch tools, it bridges the gap between your conceptual thinking and your local data.
 * **Automating Literature Repository Audits:** If you have folders of text extractions, notes, or structured files (like Markdown files from knowledge management systems), you can point OpenCode to that directory. You can ask it to scan across hundreds of notes to locate theoretical blind spots, trace how a specific concept (like institutional knowledge erasure) changes across different contexts, or identify empirical gaps in your literature review summaries.
 * **Cleaning Complex Public Datasets:** Social research often relies on messy public datasets, such as regional school district disciplinary records, which frequently come as poorly formatted CSVs or text files. Instead of manually writing data-cleaning scripts, you can have OpenCode write and execute a local Python script to scan the files, flag missing variables, standardize terminology (like combining disparate suspension categories), and prepare the data for analysis.
 * **Qualitative Coding and Codebook Generation:** You can have the tool ingest a qualitative data transcript and ask it to generate an initial, inductive codebook based on the text. Because it can iterate locally, you can refine the prompt to align strictly with specific theoretical frameworks, testing how different frameworks split or group your categories.
 * **Automating Workflow Bridges:** If you use tools to automate your environment (like managing environments with uv or orchestration tools), OpenCode can act as the execution arm. You can tell it what you want to achieve in plain English, and it can configure the local Python scripts or environment variables needed to link your research data to your local models.
## 2. Solving the Directory/Folder Visibility Problem
The issue you ran into where it doesn't automatically respect the directory you initialized it from is common with certain CLI tools. When you launch a terminal agent, it often defaults to looking at its own install binary path or a global user profile directory unless explicitly told otherwise.
To force OpenCode to recognize and work out of your current project or chapter folder without typing long paths every time, you can use a few command-line techniques:
### Option A: Use the Dot (.) Shortcut
In almost all command-line tools, a single dot . represents "the current working directory." If the tool requires a path flag (for example, --path or --dir), try initializing it by passing the dot:
```powershell
opencode --path .

```
*(Replace --path with whatever specific folder flag OpenCode uses in its help documentation).*
### Option B: Pass the PowerShell Working Directory Variable
PowerShell keeps track of your current folder in a built-in variable called $PWD (Print Working Directory). You can pass this variable directly into the tool's startup command so it automatically grabs the exact path of the folder you are currently standing in:
```powershell
opencode --target $PWD

```
### Option C: Create a Permanent PowerShell Alias/Function
If you want this behavior every single time you type opencode, you can add a short function to your PowerShell Profile.
 1. Open your profile in a text editor: notepad $PROFILE
 2. Add a line that automatically appends the current directory variable to the command:
   ```powershell
   
   ```
function start-opencode { opencode --path $PWD }
Set-Alias oc start-opencode
```
3. Save and restart PowerShell. Now, typing `oc` in any folder will instantly launch the tool with its eyes locked onto that specific directory.

---

## 3. PowerShell: User Mode vs. Administrator Mode

Deciding whether to run OpenCode in a standard User session versus an Elevated (Administrator) session is a critical decision, particularly when balancing system hardening security with operational flexibility.

| Aspect | User Mode (Standard) | Administrator Mode (Elevated) |
| :--- | :--- | :--- |
| **System Security** | **High.** The AI is completely sandboxed by standard user permissions. It cannot alter core OS settings, registry keys, or protected system folders. | **Riskier.** The AI has full keys to the kingdom. If a model generates a malformed or destructive command, it can execute it without a prompt. |
| **File Access** | Restricted to your user documents, research vaults, and local project folders. | Full access to all system files, program directories, and other user profiles. |
| **Tool Capabilities** | Can run Python scripts, edit markdown notes, parse data, and make local API calls. | Required for installing global software, changing system-wide network rules, or altering Windows Defender settings. |

### The Recommendation for Research
**Always default to running OpenCode in User Mode.** 

As an autonomous agent, OpenCode executes scripts and commands on your behalf. If you run it in Administrator mode, an LLM hallucination or a poorly interpreted prompt could accidentally wipe system configuration files, conflict with advanced security configurations (like Attack Surface Reduction rules), or modify registry keys. 

Since your research workflow primarily involves manipulating data files, text documents, and local scripts, Standard User mode provides more than enough permission to read, write, and execute everything you need while maintaining a secure, hardened perimeter on your UltraBook. Only elevate to Administrator mode if you explicitly need the tool to handle an environment installation or system configuration task, and drop back down to User mode immediately after.

<ElicitationsGroup message="Where would you like to take this setup next?">

  <Elicitation label="Configure OpenCode to search local Markdown vaults" query="How can I configure OpenCode or use an MCP server to let it index and search across a local folder of Markdown notes or research files?"/>
  <Elicitation label="Write a PowerShell script to automate data loading" query="Can you help me write a PowerShell function or Python script that automatically feeds my research datasets into a local AI session?"/>
</ElicitationsGroup>

```
