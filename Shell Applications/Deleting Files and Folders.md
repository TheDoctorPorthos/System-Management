**Why your command failed:** You received that red error message because `Remove-Item` is a standard PowerShell command used for deleting files and folders. Because the model name `gemma4:31b` contains a colon, PowerShell misinterpreted the `gemma4:` portion as a hard drive letter (similar to `C:`).

To remove models managed by Ollama, you need to use Ollama's native command-line interface instead.

### The Fix

The correct command to delete an Ollama model is `ollama rm <model-name>`.

To clear out everything in that list except for `qwen3.5:4b` and `qwen3.5:9b`, you can run the following commands in your PowerShell window one by one:

PowerShell

```
ollama rm nomic-embed-text:v1.5
ollama rm mxbai-embed-large:335m
ollama rm gemma4:31b
ollama rm deepseek-r1:8b
ollama rm qwen2.5-coder:latest
ollama rm qwen2.5-coder:7b
```

Alternatively, you can delete them all in a single command by separating the model names with a space:

PowerShell

```
ollama rm nomic-embed-text:v1.5 mxbai-embed-large:335m gemma4:31b deepseek-r1:8b qwen2.5-coder:latest qwen2.5-coder:7b
```

Once that finishes, you can type `ollama list` again to verify that only your two `qwen3.5` models remain.