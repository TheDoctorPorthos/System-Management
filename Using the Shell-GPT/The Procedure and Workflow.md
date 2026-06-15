This how to use the tool inside of PowerShell:
1. Open the PowerShell
2. When ready write the prompt "Using this provided text, write a 500-word introduction on the disproportionate suspension of students of color." hit enter.
3. The tool will transcribe the prompt into code script.
4. The prompt should actually write: Get-Content 'E:\All MarkDown Files\*.md' -Raw | sgpt "Using this provided text, write a 500-word introduction on the disproportionate suspension of students of color."

---

PS C:\Users\Dr. R. Moncriffe> sgpt --shell "List the files in 'E:\All MarkDown Files'"
Get-ChildItem -LiteralPath 'E:\All MarkDown Files'
[E]xecute, [M]odify, [D]escribe, [A]bort: D
Get-ChildItem lists the items in a location, and -LiteralPath 'E:\All MarkDown Files' tells it to use that exact path literally, so the
command returns the files and folders directly inside E:\All MarkDown Files without interpreting any wildcard characters.
[E]xecute, [M]odify, [D]escribe, [A]bort: a
PS C:\Users\Dr. R. Moncriffe>

