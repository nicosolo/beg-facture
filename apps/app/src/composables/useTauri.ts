import { computed } from "vue"
import { invoke } from "@tauri-apps/api/core"
// Dynamically import Tauri modules only when running in Tauri

// Check if we're in Tauri environment
const isTauriEnvironment = () => {
    return typeof window !== "undefined" && window.__TAURI_INTERNALS__ !== undefined
}

export function useTauri() {
    // Check if we're running in Tauri
    const isTauri = computed(() => isTauriEnvironment())

    /**
     * Open a folder in the system's file explorer
     * @param folderPath - The relative path to the folder (will be combined with HOST_PROJECT_FOLDER)
     * @returns Promise<boolean> - True if successful, false otherwise
     */
    const openFolder = async (folderPath: string): Promise<boolean> => {
        if (!isTauri.value) {
            console.warn("Tauri is not available")
            return false
        }

        try {
            // Import invoke dynamically

            console.log("Opening folder with base path:", folderPath)
            // Use the custom command that handles base path logic
            const fullPath = await invoke<string>("open_project_folder", {
                relativePath: folderPath,
            })
            console.log("Opened folder at:", fullPath)
            return true
        } catch (error) {
            console.error("Failed to open folder:", error)
            return false
        }
    }

    return {
        isTauri: computed(() => isTauri.value),
        openFolder,
    }
}

// Add type declaration for window (Tauri global)
declare global {
    interface Window {
        __TAURI_INTERNALS__?: object
    }
}
