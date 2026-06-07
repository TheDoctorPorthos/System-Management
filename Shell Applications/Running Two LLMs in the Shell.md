By default, Ollama unloads the current model from memory when a new model is requested. To run two simultaneously, you must override its default behavior using environment variables before launching your Python script.

**1.Configure the Ollama Server:**WSL Environment.

Stop any running instances of Ollama. Then, restart the server with the `OLLAMA_MAX_LOADED_MODELS` variable set to `2`. This forces the framework to keep both models in memory concurrently.

Bash

```
export OLLAMA_MAX_LOADED_MODELS=2
ollama serve
```

**2.Download the Models:**

Open a second terminal window (leaving the server running in the first) and pull your chosen models. We will use Llama 3 and Phi-3 Mini for this example.

Bash

```
ollama pull llama3
ollama pull phi3:mini
```

**3.Initialize the Python Project:**Using uv.

Use `uv` to quickly set up your environment and install the required asynchronous Ollama client.

Bash

```
uv init dual-model-bridge
cd dual-model-bridge
uv add ollama
```

**4.Create the Async Execution Script:**

Create a file named `bridge.py`. This script uses Python's `asyncio` to send your drafted text to both models at the exact same time, preventing you from having to wait for one to finish before the other starts.

Python

```
import asyncio
import ollama

async def ask_architect(text):
    print("The Architect is reviewing structure...")
    response = await ollama.AsyncClient().generate(
        model='llama3',
        prompt=f"Review this excerpt for structural strength and theoretical alignment. Do not rewrite it. Provide 3 bullet points of feedback: {text}"
    )
    return f"\n=== The Architect (Llama 3) ===\n{response['response']}"

async def ask_utility(text):
    print("The Utility is checking formatting...")
    response = await ollama.AsyncClient().generate(
        model='phi3:mini',
        prompt=f"Check this excerpt for academic tone and Markdown formatting errors. List any issues found: {text}"
    )
    return f"\n=== The Utility (Phi-3 Mini) ===\n{response['response']}"

async def main():
    # The draft text you want to analyze
    draft_text = "The disparity in exclusionary practices often stems from subjective interpretations of behavior by administration."
    
    # Execute both requests concurrently
    results = await asyncio.gather(
        ask_architect(draft_text),
        ask_utility(draft_text)
    )
    
    for result in results:
        print(result)

if __name__ == "__main__":
    asyncio.run(main())
```

**5.Run the Bridge:**

Execute the script via the CLI to see both models process the text simultaneously.

Bash

```
uv run bridge.py
```

> If you encounter an out-of-memory error during execution, Ollama will automatically attempt to offload parts of the models to your system RAM. The inference will be slower, but it will prevent the framework from crashing.By default, Ollama unloads the current model from memory when a new model is requested. To run two simultaneously, you must override its default behavior using environment variables before launching your Python script.

**1.Configure the Ollama Server:**WSL Environment.

Stop any running instances of Ollama. Then, restart the server with the `OLLAMA_MAX_LOADED_MODELS` variable set to `2`. This forces the framework to keep both models in memory concurrently.

Bash

```
export OLLAMA_MAX_LOADED_MODELS=2
ollama serve
```

**2.Download the Models:**

Open a second terminal window (leaving the server running in the first) and pull your chosen models. We will use Llama 3 and Phi-3 Mini for this example.

Bash

```
ollama pull llama3
ollama pull phi3:mini
```

**3.Initialize the Python Project:**Using uv.

Use `uv` to quickly set up your environment and install the required asynchronous Ollama client.

Bash

```
uv init dual-model-bridge
cd dual-model-bridge
uv add ollama
```

**4.Create the Async Execution Script:**

Create a file named `bridge.py`. This script uses Python's `asyncio` to send your drafted text to both models at the exact same time, preventing you from having to wait for one to finish before the other starts.

Python

```
import asyncio
import ollama

async def ask_architect(text):
    print("The Architect is reviewing structure...")
    response = await ollama.AsyncClient().generate(
        model='llama3',
        prompt=f"Review this excerpt for structural strength and theoretical alignment. Do not rewrite it. Provide 3 bullet points of feedback: {text}"
    )
    return f"\n=== The Architect (Llama 3) ===\n{response['response']}"

async def ask_utility(text):
    print("The Utility is checking formatting...")
    response = await ollama.AsyncClient().generate(
        model='phi3:mini',
        prompt=f"Check this excerpt for academic tone and Markdown formatting errors. List any issues found: {text}"
    )
    return f"\n=== The Utility (Phi-3 Mini) ===\n{response['response']}"

async def main():
    # The draft text you want to analyze
    draft_text = "The disparity in exclusionary practices often stems from subjective interpretations of behavior by administration."
    
    # Execute both requests concurrently
    results = await asyncio.gather(
        ask_architect(draft_text),
        ask_utility(draft_text)
    )
    
    for result in results:
        print(result)

if __name__ == "__main__":
    asyncio.run(main())
```

**5.Run the Bridge:**

Execute the script via the CLI to see both models process the text simultaneously.

Bash

```
uv run bridge.py
```

> If you encounter an out-of-memory error during execution, Ollama will automatically attempt to offload parts of the models to your system RAM. The inference will be slower, but it will prevent the framework from crashing.