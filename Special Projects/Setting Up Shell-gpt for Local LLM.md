You are incredibly close, but there is one critical detour in the workflow we just set up.

Right now, your workflow is actually transmitting data outside of your system. Because we initialized Shell-GPT with your explicit OpenAI API key, the `sgpt` command is currently bypassing your local hardware and talking directly to OpenAI's cloud servers.

Here is the exact breakdown of your **current** transmission:

- **Input:** You type a prompt into PowerShell using `sgpt`.
    
- **Routing:** `sgpt` packages the request and sends it over the internet to OpenAI using your API key.
    
- **Processing:** OpenAI's proprietary model (like GPT-4o) processes the text on their servers.
    
- **Output:** The result is streamed back over the internet and printed in your PowerShell window.
    

### Reclaiming the Local Workflow

To achieve the true local transmission you described—where `sgpt` communicates directly with your local `ollama` instance running `qwen2.5-coder:7b` to maintain absolute data sovereignty—we must redirect Shell-GPT's communication pathway.

Ollama natively provides an "OpenAI-compatible" API on your machine. By pointing `sgpt` to your `localhost` instead of the open web, you execute the exact workflow you originally envisioned.

Here is how to route `sgpt` to your local Qwen model:

1. **Verify Ollama is Active:** Ensure your Ollama service is actively running in the background.
    
2. **Set the Local API Endpoint:** Instruct Shell-GPT to look at your local machine instead of the internet by defining the API base URL in PowerShell. Run this command:
    
    PowerShell
    
    ```
    $env:OPENAI_API_BASE="http://localhost:11434/v1"
    ```
    
3. **Assign a Dummy Key:** Ollama does not require strict authentication, but Shell-GPT's architecture still expects a key to be present. Temporarily override the real OpenAI key we used earlier:
    
    PowerShell
    
    ```
    $env:OPENAI_API_KEY="ollama"
    ```
    
4. **Execute the Local Model:** When sending your prompt, explicitly call your local Qwen model using the `--model` flag so Shell-GPT knows exactly which model to request from your local server.
    
    PowerShell
    
    ```
    sgpt --model qwen2.5-coder:7b --shell "List all files in the current directory"
    ```
    

Once those environment variables are set, the transmission remains entirely within your hardware perimeter. The shell contacts Ollama, your local Qwen model does the heavy computing, and the results print directly to your terminal without a single byte of data leaving your machine.