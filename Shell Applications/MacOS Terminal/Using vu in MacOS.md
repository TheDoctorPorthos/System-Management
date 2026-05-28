Building with `uv` is a fast, modern way to create Python package artifacts (like source distributions and wheels). This process relies on a few straightforward Terminal commands we can go through step by step.

### ⚙️ Prerequisites: What You'll Need

Before you can build, you need to install `uv` and have a Python project that's properly configured.

1.  **Install `uv` (macOS)**: Open your Terminal and run one of the following commands:
    *   **Using the official standalone installer (recommended)**:
        ```bash
        curl -LsSf https://astral.sh/uv/install.sh | sh
        ```
        
    *   **Using Homebrew**:
        ```bash
        brew install uv
        ```
        

2.  **Prepare Your Project**: Your Python project must be structured as a package. This typically means:
    *   It has a `pyproject.toml` file at its root.
    *   The `pyproject.toml` file includes a `[build-system]` section, which tells tools like `uv` how to build your project. If you haven't defined one, `uv` will attempt to use a legacy `setuptools` configuration.

### 🛠️ Step-by-Step: Using the Build Commands

The core of the process happens in a few simple commands in your Terminal.

1.  **Navigate to Your Project's Root Directory**: The `uv build` command needs to be run from the top level of your project folder, where your `pyproject.toml` is located. Use the `cd` command to get there.
    ```bash
    cd path/to/your-python-project
    ```

2.  **Execute the Build**: Run `uv build` to create your package's distribution files.
    ```bash
    uv build
    ```
    **What this does:**
    *   By default, this command builds the project in your current directory.
    *   The output is placed in a newly created `dist/` subdirectory.
    *   Inside `dist/`, you'll typically find a source distribution (`.tar.gz`) and a pure Python wheel (`.whl`) file.

3.  **Optional: Build with `--no-sources`**: When preparing a package for publishing on PyPI, the `uv` documentation recommends using the `--no-sources` flag. This simulates a build environment that other users or tools would have, ensuring your package is configured correctly for them.
    ```bash
    uv build --no-sources
    ```
    

### ✨ Optional: Bump Your Version Before Building

Before you run the build, you might want to update your project's version number in `pyproject.toml`. The `uv version` command can do this automatically.

*   **Set an exact version**:
    ```bash
    uv version 0.2.0
    ```
*   **Use semantic versioning bumps** (e.g., bump the minor version, or go from a pre-release to a stable version):
    ```bash
    uv version --bump minor
    ```
    

### 📦 Going Further: Publishing Your Package

After a successful build, you can upload your newly created artifacts from the `dist/` folder to PyPI using `uv publish`.

```bash
uv publish
```
You'll need to set a PyPI token for authentication using the `--token` option or the `UV_PUBLISH_TOKEN` environment variable.

I hope this helps you get your Python projects built smoothly. If you run into any snags or want to explore publishing in more detail, feel free to ask.