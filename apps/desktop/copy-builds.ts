import { copyFile, mkdir, writeFile } from "node:fs/promises"
import { existsSync } from "node:fs"
import { join } from "node:path"
import tauriConf from "./src-tauri/tauri.conf.json"

const VERSION = tauriConf.version
const BUNDLE_DIR = "src-tauri/target"
const DEST_DIR = "../app/public/downloads"
const VERSION_FILE = "../app/src/config/desktop-version.json"

const builds = [
    {
        name: "macOS Universal",
        src: `${BUNDLE_DIR}/universal-apple-darwin/release/bundle/dmg/BEG Gestion_${VERSION}_universal.dmg`,
        dest: `BEG-Gestion_${VERSION}_universal.dmg`,
    },
    {
        name: "Windows x64",
        src: `${BUNDLE_DIR}/x86_64-pc-windows-msvc/release/bundle/nsis/BEG Gestion_${VERSION}_x64-setup.exe`,
        dest: `BEG-Gestion_${VERSION}_x64-setup.exe`,
    },
    {
        name: "Windows ARM64",
        src: `${BUNDLE_DIR}/aarch64-pc-windows-msvc/release/bundle/nsis/BEG Gestion_${VERSION}_arm64-setup.exe`,
        dest: `BEG-Gestion_${VERSION}_arm64-setup.exe`,
    },
]

async function main() {
    // Ensure destination directory exists
    await mkdir(DEST_DIR, { recursive: true })

    // Update version file for frontend
    await writeFile(VERSION_FILE, JSON.stringify({ version: VERSION }, null, 4) + "\n")
    console.log(`Updated version file: ${VERSION}`)

    console.log(`\nCopying builds to ${DEST_DIR}...\n`)

    for (const build of builds) {
        if (existsSync(build.src)) {
            const destPath = join(DEST_DIR, build.dest)
            await copyFile(build.src, destPath)
            console.log(`✓ ${build.name}: ${build.dest}`)
        } else {
            console.log(`✗ ${build.name}: not found (${build.src})`)
        }
    }

    console.log("\nDone!")
}

main().catch(console.error)
