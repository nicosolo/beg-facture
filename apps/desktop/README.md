# BEG Gestion Desktop Application

This is the Tauri-based desktop application for BEG Gestion, providing native desktop integration for the web application.

## Prerequisites

Before building or running the desktop application, ensure you have:

1. **Rust** installed: https://www.rust-lang.org/tools/install
2. **Node.js** and **Bun** installed
3. Platform-specific requirements:
    - **macOS**: Xcode and Command Line Tools
    - **Windows**: Microsoft C++ Build Tools and Edge WebView2
    - **Linux**: Various system dependencies (see Tauri docs)

## Installation

From the project root:

```bash
# Install dependencies
cd apps/desktop
bun install

```

## Development

```bash
cd apps/desktop
bun run dev
```

## Building for Production

### Build for windows

https://v2.tauri.app/distribute/windows-installer/

Install NSIS
On macOS you will need [Homebrew] to install NSIS:

````bash
brew install nsis

Install LLVM and the LLD Linker
Since the default Microsoft linker only works on Windows we will also need to install a new linker. To compile the Windows Resource file which is used for setting the app icon among other things we will also need the llvm-rc binary which is part of the LLVM project.

```bash
brew install llvm
````

On macOS you also have to add /opt/homebrew/opt/llvm/bin to your $PATH as suggested in the install output.

Install the Windows Rust target
Assuming you’re building for 64-bit Windows systems:

````bash
rustup target add x86_64-pc-windows-msvc

Install cargo-xwin
Instead of setting the Windows SDKs up manually we will use [cargo-xwin] as Tauri’s “runner”:

```bash
cargo install --locked cargo-xwin
````

By default cargo-xwin will download the Windows SDKs into a project-local folder. If you have multiple projects and want to share those files you can set the XWIN_CACHE_DIR environment variable with a path to the preferred location.

Building the App
Now it should be as simple as adding the runner and target to the tauri build command:

```bash
bun run build:windows:x86
bun run build:windows:arm64
```

### Using local build:

```bash
# Then build the desktop app
cd apps/desktop
bun run build
```

### useTauri() Composable

```javascript
import { useTauri } from "@/composables/useTauri"

const { isTauri, openFolder, selectFolder } = useTauri()

// Check if running in Tauri
if (isTauri.value) {
    // Open a folder in file explorer
    await openFolder("/path/to/folder")

    // Show folder selection dialog
    const selectedPath = await selectFolder()
}
```

## Troubleshooting

- If the app doesn't connect in development, ensure the web app is running on http://localhost:8084
- For build issues, check that all Rust and system dependencies are installed
- On macOS, you may need to run `xcode-select --install` if builds fail
