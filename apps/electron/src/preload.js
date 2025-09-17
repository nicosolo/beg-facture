const { contextBridge, ipcRenderer } = require("electron")

// Expose protected methods that allow the renderer process to use
// specific Node.js functionality in a secure way
try {
    contextBridge.exposeInMainWorld("electronAPI", {
        isElectron: true,
        platform: process.platform,
        versions: {
            node: process.versions.node,
            chrome: process.versions.chrome,
            electron: process.versions.electron,
        },
        openFolder: (folderPath) => ipcRenderer.invoke("open-folder", folderPath),
    })
} catch (error) {
    console.error("❌ Failed to expose electronAPI:", error)
}
