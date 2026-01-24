import { computed, ref } from "vue"
import { invoke } from "@tauri-apps/api/core"
import { useAlert } from "@/composables/utils/useAlert"

const appVersion = ref<string | null>(null)

const isTauriEnvironment = () => {
    return typeof window !== "undefined" && window.__TAURI_INTERNALS__ !== undefined
}

// Module-level shared state for Tauri drag-drop
const isDragging = ref(false)
const dragPosition = ref<{ x: number; y: number } | null>(null)
const pendingDrop = ref<{ paths: string[]; position: { x: number; y: number } } | null>(null)
let dragDropListenerActive = false

const ensureDragDropListener = async () => {
    if (dragDropListenerActive || !isTauriEnvironment()) return
    dragDropListenerActive = true

    try {
        const { getCurrentWebview } = await import("@tauri-apps/api/webview")
        const webview = getCurrentWebview()

        await webview.onDragDropEvent((event) => {
            const payload = event.payload as {
                type: string
                paths?: string[]
                position?: { x: number; y: number }
            }

            const pos = payload.position ?? { x: 0, y: 0 }

            if (payload.type === "over" || payload.type === "enter") {
                isDragging.value = true
                dragPosition.value = pos
            } else if (payload.type === "leave") {
                isDragging.value = false
                dragPosition.value = null
            } else if (payload.type === "drop") {
                isDragging.value = false
                dragPosition.value = null
                if (payload.paths && payload.paths.length > 0) {
                    pendingDrop.value = { paths: payload.paths, position: pos }
                }
            }
        })
    } catch (error) {
        console.error("Failed to setup Tauri drag-drop:", error)
        dragDropListenerActive = false
    }
}

export function useTauri() {
    const isTauri = computed(() => isTauriEnvironment())
    const { errorAlert } = useAlert()

    const openFolder = async (folderPath: string): Promise<boolean> => {
        if (!isTauri.value) return false
        try {
            await invoke<string>("open_project_folder", {
                absolutePath: folderPath,
            })
            return true
        } catch (error) {
            const errorMessage = error instanceof Error ? error.message : String(error)
            errorAlert(`Impossible d'ouvrir le dossier: ${errorMessage}`, 5000)
            return false
        }
    }

    const openFile = async (filePath: string): Promise<boolean> => {
        if (!isTauri.value) return false
        try {
            await invoke<string>("open_file", {
                absolutePath: filePath,
            })
            return true
        } catch (error) {
            const errorMessage = error instanceof Error ? error.message : String(error)
            errorAlert(`Impossible d'ouvrir le fichier: ${errorMessage}`, 5000)
            return false
        }
    }

    const consumePendingDrop = (): string[] | null => {
        if (!pendingDrop.value) return null
        const paths = pendingDrop.value.paths
        pendingDrop.value = null
        return paths
    }

    const fetchAppVersion = async () => {
        if (!isTauri.value || appVersion.value) return
        try {
            const { getVersion } = await import("@tauri-apps/api/app")
            appVersion.value = await getVersion()
        } catch {
            appVersion.value = null
        }
    }

    return {
        isTauri,
        isDragging,
        dragPosition,
        pendingDrop,
        appVersion,
        openFolder,
        openFile,
        ensureDragDropListener,
        consumePendingDrop,
        fetchAppVersion,
    }
}

declare global {
    interface Window {
        __TAURI_INTERNALS__?: object
    }
}
