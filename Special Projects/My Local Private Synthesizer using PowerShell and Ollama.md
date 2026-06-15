# 📋 Complete Step-by-Step Guide to Run Your Academic Introduction Generator

## ✅ **Prerequisites (One-Time Setup)**

### 1. **Install Required Software** (Do this once)
- **Python**: Already installed ✓
- **Ollama**: Already installed and running ✓
- **OpenAI Python Library**:
  ```powershell
  pip install openai
  ```

### 2. **Download Your AI Model** (Do this once per model)
```powershell
ollama pull llama3:latest
```

---

## 🔄 **Every Time You Want to Generate an Introduction**

### **Step 1: Start Ollama**
Make sure Ollama is running in the background:
- On Windows: Look for the Ollama icon in your system tray (bottom-right)
- Or start it manually:
  ```powershell
  ollama serve
  ```
  *(Leave this PowerShell window open)*

### **Step 2: Add Your Research Notes**
Place your `.md` (Markdown) files with your literature notes in:
```
E:\1-MoncriffeMadAssistant\Code Scripts\
```
*(The script will automatically find and read all `.md` files in this folder and subfolders)*

### **Step 3: Set Your Preferred Model** (Optional)
If you want to use a different model than the default (`llama3:latest`):
```powershell
$env:OLLAMA_MODEL="llama3.1:latest"
```
*(Skip this step to use the default)*

### **Step 4: Navigate to Your Script Folder**
```powershell
cd "E:\1-MoncriffeMadAssistant\Code Scripts"
```

### **Step 5: Run the Generator**
```powershell
python generate_introduction.py
```

### **Step 6: Review the Output**
The script will:
- ✅ Print the generated introduction in your PowerShell window
- ✅ Save it to: `E:\1-MoncriffeMadAssistant\Code Scripts\Generated_Lit_Review_Intro.md`
- ✅ Create a prompt file: `E:\1-MoncriffeMadAssistant\Code Scripts\_prompt_for_llm.txt`

---

##  **Quick Reference Command List**

**Copy-paste these commands in order:**

```powershell
# 1. Navigate to folder
cd "E:\1-MoncriffeMadAssistant\Code Scripts"

# 2. Set model (optional - skip if using default llama3:latest)
$env:OLLAMA_MODEL="llama3:latest"

# 3. Run the script
python generate_introduction.py
```

---

## 📝 **What to Expect**

**Success Output:**
```
[INFO] Prompt exported to: E:\1-MoncriffeMadAssistant\Code Scripts\_prompt_for_llm.txt
[INFO] Characters of source text: X,XXX
[INFO] Total prompt length: X,XXX
[INFO] No OPENAI_API_KEY. Attempting to connect to local Ollama (llama3:latest)...

============================================================
GENERATED INTRODUCTION:
============================================================

[Your academic introduction appears here...]

============================================================
[INFO] Introduction saved to: E:\1-MoncriffeMadAssistant\Code Scripts\Generated_Lit_Review_Intro.md
```

---

## 🚨 **Troubleshooting**

| Problem | Solution |
|---------|----------|
| "Ollama connection failed" | Make sure Ollama is running: `ollama serve` |
| "No such file or directory" | Check that `generate_introduction.py` exists in the folder |
| "Characters of source text: 0" | Add `.md` files with your research notes to the folder |
| Model not found | Download it: `ollama pull llama3:latest` |

---

## 🎓 **Ready for Your Next Scripts!**

Now that you have this workflow down, I'm ready to help you create 3-4 more code scripts for your research! 

**What would you like your next scripts to do?** For example:
- Generate literature review sections?
- Summarize individual articles?
- Create methodology sections?
- Analyze themes across sources?
- Generate citations/references?

Just tell me what you need, and I'll create the code and give you the same clear step-by-step instructions!