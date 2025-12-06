import { computed } from "vue"
import { invoke } from "@tauri-apps/api/core"
import { useAlert } from "@/composables/utils/useAlert"

// Check if we're in Tauri environment
const isTauriEnvironment = () => {
    return typeof window !== "undefined" && window.__TAURI_INTERNALS__ !== undefined
}

export function useTauri() {
    // Check if we're running in Tauri
    const isTauri = computed(() => isTauriEnvironment())
    const { errorAlert } = useAlert()

    /**
     * Open a folder in the system's file explorer
     * @param folderPath - The absolute path to the folder
     * @returns Promise<boolean> - True if successful, false otherwise
     */
    const openFolder = async (folderPath: string): Promise<boolean> => {
        if (!isTauri.value) {
            console.warn("Tauri is not available")
            return false
        }

        try {
            // Import invoke dynamically

            console.log("Opening folder at:", folderPath)
            // Use the custom command with absolute path
            const fullPath = await invoke<string>("open_project_folder", {
                absolutePath: folderPath,
            })
            console.log("Successfully opened folder at:", fullPath)
            return true
        } catch (error) {
            console.error("Failed to open folder:", error)

            // Show error alert to user
            const errorMessage = error instanceof Error ? error.message : String(error)
            errorAlert(`Impossible d'ouvrir le dossier: ${errorMessage}`, 5000)

            return false
        }
    }

    /**
     * Open a file with the system's default application
     * @param filePath - The absolute path to the file
     * @returns Promise<boolean> - True if successful, false otherwise
     */
    const openFile = async (filePath: string): Promise<boolean> => {
        if (!isTauri.value) {
            console.warn("Tauri is not available")
            return false
        }

        try {
            console.log("Opening file at:", filePath)
            const fullPath = await invoke<string>("open_file", {
                absolutePath: filePath,
            })
            console.log("Successfully opened file at:", fullPath)
            return true
        } catch (error) {
            console.error("Failed to open file:", error)
            const errorMessage = error instanceof Error ? error.message : String(error)
            errorAlert(`Impossible d'ouvrir le fichier: ${errorMessage}`, 5000)
            return false
        }
    }

    return {
        isTauri: computed(() => isTauri.value),
        openFolder,
        openFile,
    }
}

// Add type declaration for window (Tauri global)
declare global {
    interface Window {
        __TAURI_INTERNALS__?: object
    }
}
