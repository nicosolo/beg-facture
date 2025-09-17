import { computed } from "vue"

// Type definition for the Electron API
interface ElectronAPI {
    isElectron: boolean
    platform: string
    versions: {
        node: string
        chrome: string
        electron: string
    }
    openFolder: (folderPath: string) => Promise<{ success: boolean; error?: string }>
}

export function useElectron() {
    // Check if we're running in Electron when the composable is used
    const isElectron = computed(() => {
        return typeof window !== "undefined" && !!window.electronAPI
    })

    const electronAPI = computed(() => {
        if (typeof window !== "undefined" && window.electronAPI) {
            return window.electronAPI as ElectronAPI
        }
        return null
    })

    const openFolder = async (folderPath: string): Promise<boolean> => {
        if (!electronAPI.value) {
            return false
        }

        try {
            console.log(folderPath)
            const result = await electronAPI.value.openFolder(folderPath)
            return result.success
        } catch (error) {
            console.error("Failed to open folder:", error)
            return false
        }
    }

    return {
        isElectron: computed(() => isElectron.value),
        electronAPI: computed(() => electronAPI.value),
        openFolder,
    }
}

// Add type declaration for window
declare global {
    interface Window {
        electronAPI?: ElectronAPI
    }
}
