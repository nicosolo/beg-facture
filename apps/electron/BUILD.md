# Building BEG Management Desktop App

## Prerequisites

### macOS (for building all platforms)
- Bun installed
- Wine (for Windows builds): `brew install --cask wine-stable`
- Xcode Command Line Tools (for macOS builds)

### Windows (for building Windows natively)
- Bun or Node.js installed
- Visual Studio Build Tools

## Build Commands

### Single Platform Builds

```bash
# macOS (will build for current architecture)
bun run dist:mac

# Windows (both x64 and ARM64)
bun run dist:win

# Linux
bun run dist:linux

# All platforms
bun run dist:all
```

### Specific Architecture Builds

```bash
# Windows x64 only
bun run dist:win -- --x64

# Windows ARM64 only
bun run dist:win -- --arm64

# macOS Intel
bun run dist:mac -- --x64

# macOS Apple Silicon
bun run dist:mac -- --arm64
```

## Build Output

All builds are created in the `dist/` directory:

### macOS
- `BEG Management-1.0.0-arm64-mac.zip` - ZIP for distribution
- `BEG Management-1.0.0-arm64.dmg` - DMG installer
- `mac-arm64/BEG Management.app` - The actual app

### Windows
- `BEG Management Setup 1.0.0.exe` - NSIS installer (includes both architectures)
- `win-unpacked/` - Unpacked x64 version
- `win-arm64-unpacked/` - Unpacked ARM64 version

### Linux
- `BEG Management-1.0.0.AppImage` - AppImage for most Linux distributions

## Environment Variables

Set these before building for production:

```bash
# Set the web app URL (defaults to http://localhost:8084)
export APP_URL=https://app.beg-facture.com

# Build for production
bun run dist:win
```

## Code Signing

### macOS
- Requires Apple Developer certificate
- Set `CSC_LINK` and `CSC_KEY_PASSWORD` environment variables

### Windows
- Requires code signing certificate
- Set `CSC_LINK` and `CSC_KEY_PASSWORD` environment variables
- Or use `signtool.exe` manually after build

## Cross-Platform Building

### From macOS
- ✅ Can build for: macOS, Windows, Linux
- Requires Wine for Windows builds
- Linux builds may require additional tools

### From Windows
- ✅ Can build for: Windows
- ❌ Cannot build for: macOS (requires macOS)
- ⚠️ Linux builds possible with WSL

### From Linux
- ✅ Can build for: Linux, Windows
- ❌ Cannot build for: macOS (requires macOS)
- Requires Wine for Windows builds

## Distribution

### Unsigned Apps
Users will see security warnings and need to:
- **macOS**: Right-click → Open, or System Settings → Privacy & Security
- **Windows**: "More info" → "Run anyway"
- **Linux**: Make AppImage executable: `chmod +x *.AppImage`

### Signed Apps
Recommended for production distribution to avoid security warnings.

## Troubleshooting

### Wine Issues on macOS
If Wine installation fails, try:
```bash
brew install --cask wine-stable
# If on Apple Silicon:
softwareupdate --install-rosetta --agree-to-license
```

### Build Fails with "Cannot find module"
```bash
# Clear cache and reinstall
rm -rf node_modules bun.lockb
bun install
```

### Windows Build on ARM Mac
The build will create ARM64 Windows executables by default on Apple Silicon Macs.
To build x64 explicitly: `bun run dist:win -- --x64`