To serve a Python web application on macOS, you can use **Uvicorn**, **Hypercorn**, or **Gunicorn** (with a Uvicorn worker). All three are ASGI servers — Gunicorn becomes ASGI‑capable when combined with Uvicorn workers. Below are the detailed steps for each, using a minimal FastAPI app as an example.

---

## Prerequisites
- macOS with **Python 3.8+** installed (check with `python3 --version`)
- A terminal application (Terminal.app, iTerm2, etc.)
- (Recommended) A Python virtual environment to isolate dependencies

### 1. Create a project folder and virtual environment
```bash
mkdir myapp && cd myapp
python3 -m venv venv
source venv/bin/activate
```

### 2. Install FastAPI (or your own ASGI framework)
```bash
pip install fastapi
```

### 3. Create a minimal application file
Create `main.py`:
```python
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Hello World"}
```
If you’re using a different framework (Quart, Starlette, Django + Channels), replace the import and app object accordingly. The server commands expect `<module>:<asgi_app_variable>`.

---

## 1. Uvicorn
Uvicorn is a lightning‑fast ASGI server, built on `uvloop` and `httptools`.  

### Install
```bash
pip install uvicorn
```

### Run (basic)
```bash
uvicorn main:app
```
- `main` → the Python file `main.py`
- `app` → the ASGI application instance (the variable named `app`)

### Custom host / port
```bash
uvicorn main:app --host 0.0.0.0 --port 8000
```

### Development mode (auto‑reload)
```bash
uvicorn main:app --reload
```

### Production‑grade settings (example)
```bash
uvicorn main:app --host 0.0.0.0 --port 8000 --workers 4 --log-level info
```
- `--workers 4` → use 4 worker processes (requires `gunicorn` if you want process management with Uvicorn workers, but Uvicorn itself supports multiprocessing on macOS with this flag).

---

## 2. Hypercorn
Hypercorn supports HTTP/1, HTTP/2, WebSockets, and can serve both ASGI and WSGI apps. It’s based on the same trio of libraries as Uvicorn (uvloop, h2, wsproto) but gives you a different command‑line interface.

### Install
```bash
pip install hypercorn
```

### Run (basic)
```bash
hypercorn main:app
```

### Custom host / port and bind
```bash
hypercorn main:app --bind 0.0.0.0:8000
```

### Enable HTTP/2
```bash
hypercorn main:app --bind 0.0.0.0:8000 --certfile cert.pem --keyfile key.pem
```
(You need a TLS certificate for HTTP/2; on macOS you can generate a self‑signed one with `openssl` if testing.)

### Development reload
```bash
hypercorn main:app --reload
```

### Multiple workers
```bash
hypercorn main:app --workers 4
```
Hypercorn handles worker processes natively (no extra server needed).

---

## 3. Gunicorn (with Uvicorn workers)
Gunicorn is a mature WSGI server. To use it with ASGI frameworks, you install **Uvicorn** and use Gunicorn’s `--worker-class` (or `-k`) option to launch Uvicorn workers.

### Install
```bash
pip install gunicorn uvicorn
```
(Uvicorn must be installed because Gunicorn imports `uvicorn.workers.UvicornWorker`.)

### Run
```bash
gunicorn main:app -w 4 -k uvicorn.workers.UvicornWorker
```
- `-w 4` → 4 worker processes
- `-k uvicorn.workers.UvicornWorker` → tells Gunicorn to use the ASGI‑capable worker class from Uvicorn

### Bind to a specific host / port
```bash
gunicorn main:app -w 4 -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:8000
```

### Development reload (use `--reload`)
```bash
gunicorn main:app -w 1 -k uvicorn.workers.UvicornWorker --reload
```
(For reload in development, use a single worker to avoid issues.)

### A note on macOS
Gunicorn on macOS uses the `fork` method by default, which works fine. If you encounter any `RuntimeError` about the spawn method, you can set the environment variable:
```bash
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
```
This is sometimes needed when using frameworks that depend on macOS’s Objective‑C runtime.

---

## Quick Reference Table
| Server    | Installation command        | Run command (development)                         | Production‑like command |
|-----------|-----------------------------|---------------------------------------------------|-------------------------|
| Uvicorn   | `pip install uvicorn`       | `uvicorn main:app --reload`                       | `uvicorn main:app --host 0.0.0.0 --port 8000 --workers 4` |
| Hypercorn | `pip install hypercorn`     | `hypercorn main:app --reload`                     | `hypercorn main:app --bind 0.0.0.0:8000 --workers 4` |
| Gunicorn  | `pip install gunicorn uvicorn` | `gunicorn main:app -w 1 -k uvicorn.workers.UvicornWorker --reload` | `gunicorn main:app -w 4 -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:8000` |

All commands assume your virtual environment is active and your application is in `main.py` with an ASGI app object named `app`.

---

If you need to serve a **pure WSGI** application (like Flask or Django without Channels) with Gunicorn, omit the `-k` flag – Gunicorn will default to its synchronous WSGI worker. Hypercorn can also serve WSGI with the `--wsgi` flag, but that’s a separate topic.To serve a Python web application on macOS, you can use **Uvicorn**, **Hypercorn**, or **Gunicorn** (with a Uvicorn worker). All three are ASGI servers — Gunicorn becomes ASGI‑capable when combined with Uvicorn workers. Below are the detailed steps for each, using a minimal FastAPI app as an example.

---

## Prerequisites
- macOS with **Python 3.8+** installed (check with `python3 --version`)
- A terminal application (Terminal.app, iTerm2, etc.)
- (Recommended) A Python virtual environment to isolate dependencies

### 1. Create a project folder and virtual environment
```bash
mkdir myapp && cd myapp
python3 -m venv venv
source venv/bin/activate
```

### 2. Install FastAPI (or your own ASGI framework)
```bash
pip install fastapi
```

### 3. Create a minimal application file
Create `main.py`:
```python
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Hello World"}
```
If you’re using a different framework (Quart, Starlette, Django + Channels), replace the import and app object accordingly. The server commands expect `<module>:<asgi_app_variable>`.

---

## 1. Uvicorn
Uvicorn is a lightning‑fast ASGI server, built on `uvloop` and `httptools`.  

### Install
```bash
pip install uvicorn
```

### Run (basic)
```bash
uvicorn main:app
```
- `main` → the Python file `main.py`
- `app` → the ASGI application instance (the variable named `app`)

### Custom host / port
```bash
uvicorn main:app --host 0.0.0.0 --port 8000
```

### Development mode (auto‑reload)
```bash
uvicorn main:app --reload
```

### Production‑grade settings (example)
```bash
uvicorn main:app --host 0.0.0.0 --port 8000 --workers 4 --log-level info
```
- `--workers 4` → use 4 worker processes (requires `gunicorn` if you want process management with Uvicorn workers, but Uvicorn itself supports multiprocessing on macOS with this flag).

---

## 2. Hypercorn
Hypercorn supports HTTP/1, HTTP/2, WebSockets, and can serve both ASGI and WSGI apps. It’s based on the same trio of libraries as Uvicorn (uvloop, h2, wsproto) but gives you a different command‑line interface.

### Install
```bash
pip install hypercorn
```

### Run (basic)
```bash
hypercorn main:app
```

### Custom host / port and bind
```bash
hypercorn main:app --bind 0.0.0.0:8000
```

### Enable HTTP/2
```bash
hypercorn main:app --bind 0.0.0.0:8000 --certfile cert.pem --keyfile key.pem
```
(You need a TLS certificate for HTTP/2; on macOS you can generate a self‑signed one with `openssl` if testing.)

### Development reload
```bash
hypercorn main:app --reload
```

### Multiple workers
```bash
hypercorn main:app --workers 4
```
Hypercorn handles worker processes natively (no extra server needed).

---

## 3. Gunicorn (with Uvicorn workers)
Gunicorn is a mature WSGI server. To use it with ASGI frameworks, you install **Uvicorn** and use Gunicorn’s `--worker-class` (or `-k`) option to launch Uvicorn workers.

### Install
```bash
pip install gunicorn uvicorn
```
(Uvicorn must be installed because Gunicorn imports `uvicorn.workers.UvicornWorker`.)

### Run
```bash
gunicorn main:app -w 4 -k uvicorn.workers.UvicornWorker
```
- `-w 4` → 4 worker processes
- `-k uvicorn.workers.UvicornWorker` → tells Gunicorn to use the ASGI‑capable worker class from Uvicorn

### Bind to a specific host / port
```bash
gunicorn main:app -w 4 -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:8000
```

### Development reload (use `--reload`)
```bash
gunicorn main:app -w 1 -k uvicorn.workers.UvicornWorker --reload
```
(For reload in development, use a single worker to avoid issues.)

### A note on macOS
Gunicorn on macOS uses the `fork` method by default, which works fine. If you encounter any `RuntimeError` about the spawn method, you can set the environment variable:
```bash
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
```
This is sometimes needed when using frameworks that depend on macOS’s Objective‑C runtime.

---

## Quick Reference Table
| Server    | Installation command        | Run command (development)                         | Production‑like command |
|-----------|-----------------------------|---------------------------------------------------|-------------------------|
| Uvicorn   | `pip install uvicorn`       | `uvicorn main:app --reload`                       | `uvicorn main:app --host 0.0.0.0 --port 8000 --workers 4` |
| Hypercorn | `pip install hypercorn`     | `hypercorn main:app --reload`                     | `hypercorn main:app --bind 0.0.0.0:8000 --workers 4` |
| Gunicorn  | `pip install gunicorn uvicorn` | `gunicorn main:app -w 1 -k uvicorn.workers.UvicornWorker --reload` | `gunicorn main:app -w 4 -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:8000` |

All commands assume your virtual environment is active and your application is in `main.py` with an ASGI app object named `app`.

---

If you need to serve a **pure WSGI** application (like Flask or Django without Channels) with Gunicorn, omit the `-k` flag – Gunicorn will default to its synchronous WSGI worker. Hypercorn can also serve WSGI with the `--wsgi` flag, but that’s a separate topic.