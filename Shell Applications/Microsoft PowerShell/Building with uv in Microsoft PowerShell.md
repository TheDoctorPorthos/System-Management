Here is a complete, step-by-step guide to building and managing Python projects with **`uv`** (Astral's ultra-fast Python package & project manager) in Microsoft PowerShell.

---

## 📦 Step 1: Install `uv` in PowerShell
`uv` is a standalone `.exe`. Install it natively without `pip`:

```powershell
# Official PowerShell installer (adds to USER scope PATH)
irm https://astral.sh/uv/install.ps1 | iex

# Verify installation
uv --version
```
> 🔁 **If `uv` is not recognized immediately:** Restart PowerShell, or manually refresh your session:
> ```powershell
> $env:PATH = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
> ```

---

## 📂 Step 2: Initialize a Project
`uv` replaces `pip`, `venv`, and `pyproject.toml` scaffolding with one command:

```powershell
# Create new project directory & initialize
uv init my-research-project
cd my-research-project
```
**What `uv init` creates:**
```
my-research-project/
├── pyproject.toml      # Project metadata & dependencies
├── README.md
├── .python-version     # Pins Python version (e.g., 3.12)
└── src/
    └── my_research_project/
        └── __init__.py
```

---

## 🔧 Step 3: Python Version & Environment Management
`uv` handles Python installations and virtual environments automatically:

```powershell
# Install a specific Python version (if not on system)
uv python install 3.12

# Sync creates .venv and installs all dependencies
uv sync

# Verify environment
uv run python --version
uv run which python   # Linux/WSL syntax; on Windows use:
uv run where python
```
> 💡 `uv` creates `.venv` in your project root. You **never need** `python -m venv` or `pip install`.

---

## 📦 Step 4: Add & Manage Dependencies
```powershell
# Add packages (auto-updates pyproject.toml & lockfile)
uv add pandas numpy fastapi
uv add "torch>=2.0,<2.4" --optional

# Add dev/test dependencies
uv add --dev pytest black ruff

# Sync environment to exact lockfile state
uv sync --frozen

# Update specific package
uv update pandas
```
`uv` generates a `uv.lock` file (deterministic, cross-platform, and faster than `poetry.lock` or `requirements.txt`).

---

## 🏗️ Step 5: Build Distributable Packages (`uv build`)
Python doesn't "compile" code; it **packages** it into wheels (`.whl`) and source archives (`.tar.gz`). `uv build` invokes PEP 517 build backends to do this.

### 1. Ensure `pyproject.toml` has a build system
```toml
[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[project]
name = "my-research-project"
version = "0.1.0"
description = "Dissertation data pipeline"
requires-python = ">=3.10"
dependencies = ["pandas>=2.0"]
```

### 2. Run the build
```powershell
# Creates dist/ containing .whl and .tar.gz
uv build

# Build only a wheel
uv build --wheel

# Build only source distribution
uv build --sdist

# Custom output directory
uv build --out-dir C:\Releases\MyProject
```
✅ Output: `dist/my_research_project-0.1.0-py3-none-any.whl` + `dist/my_research_project-0.1.0.tar.gz`

---

## ▶️ Step 6: Run Scripts & Apps
```powershell
# Run any script in the isolated environment
uv run python src/main.py

# Run CLI tools directly
uv run fastapi dev src/api.py
uv run pytest tests/
uv run ruff check .

# Pass arguments safely
uv run python src/analyze.py --input "data.csv" --output "results/"
```

---

## 🌐 Step 7: Publish (Optional)
```powershell
# Build + publish to PyPI or TestPyPI
uv build && uv publish

# Publish to a private registry
uv publish --publish-url https://my-registry/simple/ --token $env:PYPI_TOKEN
```

---

## 💻 PowerShell-Specific Best Practices
| Area | Recommendation |
|------|----------------|
| **PATH Management** | Always run `uv` from project root. Avoid modifying system PATH manually. |
| **Execution Policy** | `uv` is an `.exe` and bypasses PowerShell script policies. Python scripts run normally. |
| **Environment Variables** | Use `$env:UV_PYTHON_PREFERENCE = "only-managed"` to force `uv`-installed Python |
| **Cross-Platform Lockfiles** | `uv.lock` works on Windows, Linux, macOS. No platform-specific pins needed. |
| **Avoid `cd` in Scripts** | Use `uv run --directory C:\Path\To\Project python main.py` instead of `cd` + `uv run` |
| **VS Code Integration** | Set `"python.defaultInterpreterPath": "${workspaceFolder}/.venv/Scripts/python.exe"` |

---

## 🔍 Troubleshooting Common Windows/PowerShell Issues
| Symptom | Cause | Fix |
|---------|-------|-----|
| `'uv' is not recognized` | PATH not refreshed | Restart PowerShell or run `$env:PATH += ";$env:USERPROFILE\.cargo\bin"` |
| `Build fails: missing build backend` | No `[build-system]` in `pyproject.toml` | Add `hatchling` or `setuptools` as shown above |
| `.venv` locked by process | Server/script still running | `Stop-Process -Name python -Force` or `uv run --` then `Ctrl+C` |
| `Permission denied on C:\` | Antivirus/OneDrive syncing | Move project to non-synced folder (e.g., `C:\dev\`) |
| `uv sync` slow on first run | Downloading Python + wheels | Subsequent runs use cache; use `uv sync --frozen` in CI/CD |

---

## 📋 Quick Reference Cheat Sheet
```powershell
# SETUP
uv init my-project ; cd my-project
uv python install 3.12
uv sync

# DEPENDENCIES
uv add pandas fastapi
uv add --dev pytest ruff
uv update pandas

# BUILD
uv build                  # .whl + .tar.gz → dist/
uv build --wheel          # Wheels only
uv build --sdist          # Source only

# RUN
uv run python main.py
uv run pytest
uv run fastapi dev main.py

# PUBLISH
uv publish --token $env:PYPI_API_KEY
```

---

## 🎯 Pro Tips for Research/Academic Workflows
1. **Reproducible Environments:** Commit `uv.lock` + `pyproject.toml`. Anyone can run `uv sync` to get identical dependencies.
2. **CI/CD Ready:** `uv sync --frozen --no-dev` installs exact versions without dev tools. Perfect for GitHub Actions or lab servers.
3. **Cache Management:** `uv cache dir` shows where wheels/Python are stored. Clear with `uv cache clean` if disk space is tight.
4. **Wrapper for Docker:** `uv export --format requirements.txt > requirements.txt` generates a pip-compatible file if you need legacy tooling.

Would you like a **PowerShell deployment script** that automates `uv build` → version bumping → publishing, or a guide to **integrating `uv` with your dissertation data pipeline** (Jupyter, FastAPI, or batch processing)?