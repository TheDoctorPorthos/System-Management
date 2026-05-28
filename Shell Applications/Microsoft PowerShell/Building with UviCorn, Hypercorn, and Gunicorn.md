Here is a complete, step-by-step guide to using **Uvicorn**, **Hypercorn**, and **Gunicorn** in Microsoft PowerShell. 

⚠️ **Critical Architecture Note First:**
- **Uvicorn & Hypercorn** are **ASGI servers** (designed for async Python frameworks like FastAPI, Starlette, Quart).
- **Gunicorn** is a **WSGI server** (designed for sync Python frameworks like Flask, Django). **Gunicorn does not run natively on Windows.** I will provide the official Windows-compatible alternatives and workarounds below.

---

## 📦 Step 1: Environment Setup (PowerShell)
1. **Verify Python & Create Virtual Environment**
   ```powershell
   python --version
   python -m venv .venv
   .\.venv\Scripts\Activate.ps1
   ```
   > 🔑 *If `Activate.ps1` is blocked:* Run `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` first.

2. **Create a Minimal ASGI App (`main.py`)**
   ```python
   from fastapi import FastAPI
   app = FastAPI()

   @app.get("/")
   def read_root():
       return {"status": "running"}
   ```

3. **Install Servers**
   ```powershell
   pip install "uvicorn[standard]"   # Includes optimized HTTP parser
   pip install hypercorn
   pip install gunicorn             # Installs, but see Windows note below
   ```

---

## 🚀 Step 2: Running Uvicorn
| Task | PowerShell Command |
|------|-------------------|
| **Basic Dev** | `python -m uvicorn main:app --reload --port 8000` |
| **Bind to Network** | `python -m uvicorn main:app --host 0.0.0.0 --port 8000` |
| **Production (4 workers)** | `python -m uvicorn main:app --host 0.0.0.0 --port 8000 --workers 4` |
| **Debug Logging** | `python -m uvicorn main:app --reload --log-level debug` |

🔹 **PowerShell Tips:**
- Always use `python -m uvicorn` to guarantee the correct virtual environment is used.
- `--reload` and `--workers` are **mutually exclusive**.
- Windows fallback: `uvloop` is unavailable on Windows; Uvicorn auto-falls back to `asyncio` (fully functional).

---

## 🌐 Step 3: Running Hypercorn
Hypercorn is a full-featured ASGI server with HTTP/2 and WebSocket support.

| Task | PowerShell Command |
|------|-------------------|
| **Basic Dev** | `python -m hypercorn main:app --bind 127.0.0.1:8000 --reload` |
| **Production (4 workers)** | `python -m hypercorn main:app --bind 0.0.0.0:8000 --workers 4` |
| **HTTP/2 + TLS** | `python -m hypercorn main:app --bind 0.0.0.0:443 --certfile cert.pem --keyfile key.pem` |
| **Watch Specific Dirs** | `python -m hypercorn main:app --reload --reload-dir src` |

🔹 **Key Syntax Difference:** Hypercorn uses `--bind HOST:PORT` instead of separate `--host`/`--port` flags.

---

## 🛑 Step 4: Gunicorn on Windows (Important Reality Check)
**Gunicorn officially does not support Windows.** It relies on Unix-specific system calls (`fork`, `select`/`epoll`, signal handling). Running it natively in PowerShell will fail or behave unpredictably.

### ✅ Windows-Compatible Alternatives
| Approach | Command | Notes |
|----------|---------|-------|
| **WSL Integration** (from PowerShell) | `wsl -e gunicorn main:app --bind 0.0.0.0:8000` | Requires Gunicorn installed *inside* WSL |
| **Docker** | `docker run -p 8000:8000 python:3.11-slim pip install gunicorn && gunicorn main:app --bind 0.0.0.0:8000` | Fully isolated, production-ready |
| **Native WSGI Alternative** | `pip install waitress` → `python -m waitress --host=0.0.0.0 --port=8000 main:app` | Windows-native WSGI server (Flask/Django compatible) |

> 💡 **Recommendation:** If you're on Windows and need WSGI, use **Waitress**. If you're building async apps (FastAPI), stick with **Uvicorn** or **Hypercorn**.

---

## 🖥️ Step 5: PowerShell Server Management
### 🔹 Run in Background (Hidden Window)
```powershell
Start-Process python -ArgumentList "-m uvicorn main:app --reload --port 8000" -WindowStyle Hidden
```

### 🔹 Run as Background Job (Capture Output)
```powershell
$job = Start-Job -ScriptBlock {
    Set-Location $using:PWD
    & python -m hypercorn main:app --bind 127.0.0.1:8000
}
# Stream logs
Receive-Job $job -Wait
```

### 🔹 Stop Server by Port
```powershell
function Stop-WebServer {
    param([int]$Port = 8000)
    $pids = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess -Unique
    if ($pids) {
        Stop-Process -Id $pids -Force -ErrorAction SilentlyContinue
        Write-Host "✅ Stopped processes on port $Port"
    } else {
        Write-Host "ℹ️  No process found on port $Port"
    }
}
Stop-WebServer 8000
```

### 🔹 Environment Variables (PowerShell Syntax)
```powershell
$env:UVICORN_WORKERS = "4"
$env:HYPERCORN_LOG_LEVEL = "info"
python -m uvicorn main:app  # Reads $env vars automatically
```

---

## 📊 Step 6: When to Use Which (Decision Guide)
| Server | Type | Windows Native? | Best For | Async/WSGI? |
|--------|------|----------------|----------|-------------|
| **Uvicorn** | ASGI | ✅ Yes | FastAPI, Starlette, lightweight async | ASGI |
| **Hypercorn** | ASGI | ✅ Yes | HTTP/2, WebSockets, production ASGI | ASGI |
| **Gunicorn** | WSGI | ❌ No | Django, Flask, traditional sync apps | WSGI |
| **Waitress** | WSGI | ✅ Yes | Windows-native sync deployments | WSGI |

> 🔑 **Rule of Thumb:** 
> - Building with **FastAPI/Starlette/Quart** → Uvicorn or Hypercorn
> - Building with **Flask/Django** → Waitress (Windows) or Gunicorn (Linux/WSL/Docker)
> - Need **HTTP/2 or advanced WebSockets** → Hypercorn

---

## 📝 Quick Reference Cheat Sheet
```powershell
# DEV
python -m uvicorn main:app --reload --port 8000
python -m hypercorn main:app --bind 127.0.0.1:8000 --reload

# PROD
python -m uvicorn main:app --host 0.0.0.0 --port 8000 --workers 4
python -m hypercorn main:app --bind 0.0.0.0:8000 --workers 4

# WINDOWS WSGI ALTERNATIVE
python -m waitress --host=0.0.0.0 --port=8000 main:app

# KILL BY PORT
Get-NetTCPConnection -LocalPort 8000 -ErrorAction Ignore | Stop-Process -Id {$_.OwningProcess} -Force
```

---

## 🔍 Troubleshooting Common PowerShell/Windows Issues
| Symptom | Cause | Fix |
|---------|-------|-----|
| `'uvicorn' is not recognized` | PATH/venv mismatch | Use `python -m uvicorn` |
| `Address already in use` | Orphaned process | Run `Stop-WebServer 8000` |
| `Reload not detecting changes` | Wrong watch dir | Add `--reload-dir . --reload-include "*.py"` |
| `Gunicorn crashes on Windows` | Unix-only syscall | Use Waitress, WSL, or Docker |
| `Slow async performance` | Missing optimized loop | Normal on Windows; `uvloop` is Linux/macOS only |

Would you like a **production-ready PowerShell deployment script** that auto-starts your chosen server, handles crashes, rotates logs, and runs as a Windows Scheduled Task? Or guidance on containerizing your ASGI/WSGI app for cross-platform consistency?