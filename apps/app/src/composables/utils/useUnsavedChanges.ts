import { ref, computed, onMounted, onUnmounted, type Ref, type ComputedRef } from "vue"
import { onBeforeRouteLeave } from "vue-router"

interface UseUnsavedChangesOptions {
    /** Custom check function or computed ref for unsaved changes */
    hasChanges?: ComputedRef<boolean> | Ref<boolean>
    /** Message to show in confirm dialog (for route navigation) */
    confirmMessage?: string
    /** Enable vue-router navigation guard */
    useRouteGuard?: boolean
}

const isTauriEnvironment = () =>
    typeof window !== "undefined" && window.__TAURI_INTERNALS__ !== undefined

/**
 * Composable for handling unsaved changes warnings
 * - Shows browser warning on page refresh/close
 * - In Tauri, intercepts window close request with confirm dialog
 * - Optionally blocks vue-router navigation with confirm dialog
 */
export function useUnsavedChanges(options: UseUnsavedChangesOptions = {}) {
    const {
        confirmMessage = "Vous avez des modifications non enregistrées. Voulez-vous vraiment quitter ?",
        useRouteGuard = true,
    } = options

    const isDirty = ref(false)
    let tauriUnlisten: (() => void) | null = null

    const hasUnsavedChanges = computed(() => {
        if (options.hasChanges) {
            return options.hasChanges.value || isDirty.value
        }
        return isDirty.value
    })

    const markDirty = () => {
        isDirty.value = true
    }

    const markClean = () => {
        isDirty.value = false
    }

    // Browser beforeunload handler
    const handleBeforeUnload = (e: BeforeUnloadEvent) => {
        if (hasUnsavedChanges.value) {
            e.preventDefault()
            e.returnValue = ""
            return ""
        }
    }

    onMounted(async () => {
        window.addEventListener("beforeunload", handleBeforeUnload)

        // Tauri: intercept window close request
        if (isTauriEnvironment()) {
            try {
                const { getCurrentWindow } = await import("@tauri-apps/api/window")
                const currentWindow = getCurrentWindow()
                tauriUnlisten = await currentWindow.onCloseRequested(async (event) => {
                    if (hasUnsavedChanges.value) {
                        event.preventDefault()
                        const { confirm } = await import("@tauri-apps/plugin-dialog")
                        const shouldClose = await confirm(confirmMessage, {
                            title: "Modifications non enregistrées",
                            okLabel: "Quitter",
                            cancelLabel: "Annuler",
                        })
                        if (shouldClose) {
                            await currentWindow.destroy()
                        }
                    }
                })
            } catch (err) {
                console.error("Failed to setup Tauri close guard:", err)
            }
        }
    })

    onUnmounted(() => {
        window.removeEventListener("beforeunload", handleBeforeUnload)
        if (tauriUnlisten) {
            tauriUnlisten()
            tauriUnlisten = null
        }
    })

    // Vue Router navigation guard
    if (useRouteGuard) {
        onBeforeRouteLeave(async () => {
            if (hasUnsavedChanges.value) {
                if (isTauriEnvironment()) {
                    const { confirm } = await import("@tauri-apps/plugin-dialog")
                    const shouldLeave = await confirm(confirmMessage, {
                        title: "Modifications non enregistrées",
                        okLabel: "Quitter",
                        cancelLabel: "Annuler",
                    })
                    if (!shouldLeave) return false
                } else {
                    const answer = window.confirm(confirmMessage)
                    if (!answer) return false
                }
            }
        })
    }

    return {
        isDirty,
        hasUnsavedChanges,
        markDirty,
        markClean,
    }
}
