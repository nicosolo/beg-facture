import { app, BrowserWindow, Menu, shell, dialog, ipcMain } from "electron"
import path from "path"
import { fileURLToPath } from "url"

const __dirname = path.dirname(fileURLToPath(import.meta.url))
const isDev = process.env.NODE_ENV === "development"

let mainWindow

// Get app URL from environment or use defaults
const getAppUrl = () => {
    if (isDev) {
        // In development, connect to Docker proxy
        return "http://localhost:8084"
    }
    return process.env.APP_URL
}

// Create main application window
async function createWindow() {
    mainWindow = new BrowserWindow({
        width: 1400,
        height: 900,
        minWidth: 1024,
        minHeight: 600,
        webPreferences: {
            nodeIntegration: false,
            contextIsolation: true,
            preload: path.join(__dirname, "preload.js"),
        },
        icon: path.join(__dirname, "../resources/icon.png"),
        titleBarStyle: "default",
        show: false,
    })

    // Show window when ready
    mainWindow.once("ready-to-show", () => {
        mainWindow.show()
    })

    // Load the app URL (development or production)
    const appUrl = getAppUrl()
    await mainWindow.loadURL(appUrl)

    // In development, enable DevTools and auto-reload
    if (isDev) {
        mainWindow.webContents.openDevTools()

        // Auto-reload the renderer when the web app restarts
        mainWindow.webContents.on("did-fail-load", () => {
            console.log("Failed to load, retrying in 2 seconds...")
            setTimeout(() => {
                mainWindow.loadURL(appUrl)
            }, 2000)
        })
    }

    // Handle window closed
    mainWindow.on("closed", () => {
        mainWindow = null
    })

    // Handle external links
    mainWindow.webContents.setWindowOpenHandler(({ url }) => {
        shell.openExternal(url)
        return { action: "allow" }
    })
}

// Create application menu
function createMenu() {
    const template = [
        {
            label: "BEG Management",
            submenu: [
                {
                    label: "About BEG Management",
                    click: () => {
                        dialog.showMessageBox(mainWindow, {
                            type: "info",
                            title: "About BEG Management",
                            message: "BEG Management",
                            detail: "A professional invoicing application for managing projects and clients.",
                            buttons: ["OK"],
                        })
                    },
                },
                { type: "separator" },
                { role: "quit" },
            ],
        },
        {
            label: "Edit",
            submenu: [
                { role: "undo" },
                { role: "redo" },
                { type: "separator" },
                { role: "cut" },
                { role: "copy" },
                { role: "paste" },
                { role: "selectAll" },
            ],
        },
        {
            label: "View",
            submenu: [
                { role: "reload" },
                { role: "forceReload" },
                { role: "toggleDevTools" },
                { type: "separator" },
                { role: "resetZoom" },
                { role: "zoomIn" },
                { role: "zoomOut" },
                { type: "separator" },
                { role: "togglefullscreen" },
            ],
        },
        {
            label: "Window",
            submenu: [{ role: "minimize" }, { role: "close" }],
        },
        {
            label: "Help",
            submenu: [
                {
                    label: "Documentation",
                    click: () => {
                        shell.openExternal("https://github.com/your-org/beg-facture")
                    },
                },
            ],
        },
    ]

    if (process.platform === "darwin") {
        // macOS specific menu adjustments
        template[0].submenu.splice(
            1,
            0,
            { type: "separator" },
            { role: "services", submenu: [] },
            { type: "separator" },
            { role: "hide" },
            { role: "hideOthers" },
            { role: "unhide" }
        )

        template[4].submenu = [
            { role: "close" },
            { role: "minimize" },
            { role: "zoom" },
            { type: "separator" },
            { role: "front" },
        ]
    }

    const menu = Menu.buildFromTemplate(template)
    Menu.setApplicationMenu(menu)
}

// IPC handlers for native functionality
ipcMain.handle("open-folder", async (event, folderPath) => {
    try {
        // Open folder in native file manager
        shell.showItemInFolder(folderPath)
        return { success: true }
    } catch (error) {
        console.error("Failed to open folder:", error)
        return { success: false, error: error.message }
    }
})

// App event handlers
app.whenReady().then(async () => {
    createMenu()
    await createWindow()

    // Register keyboard shortcuts for development
    if (isDev) {
        const { globalShortcut } = await import("electron")

        // Cmd+R or Ctrl+R to reload
        globalShortcut.register("CommandOrControl+R", () => {
            if (mainWindow) {
                mainWindow.reload()
            }
        })

        // Cmd+Shift+R or Ctrl+Shift+R to hard reload
        globalShortcut.register("CommandOrControl+Shift+R", () => {
            if (mainWindow) {
                mainWindow.webContents.reloadIgnoringCache()
            }
        })
    }
})

app.on("window-all-closed", () => {
    if (process.platform !== "darwin") {
        app.quit()
    }
})

app.on("activate", async () => {
    if (BrowserWindow.getAllWindows().length === 0) {
        await createWindow()
    }
})

// Handle certificate errors in development
if (isDev) {
    app.on("certificate-error", (event, webContents, url, error, certificate, callback) => {
        event.preventDefault()
        callback(true)
    })
}
