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

/**
 * Composable for handling unsaved changes warnings
 * - Shows browser warning on page refresh/close
 * - Optionally blocks vue-router navigation with confirm dialog
 */
export function useUnsavedChanges(options: UseUnsavedChangesOptions = {}) {
    const {
        confirmMessage = "Vous avez des modifications non enregistrées. Voulez-vous vraiment quitter ?",
        useRouteGuard = true,
    } = options

    const isDirty = ref(false)

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

    onMounted(() => {
        window.addEventListener("beforeunload", handleBeforeUnload)
    })

    onUnmounted(() => {
        window.removeEventListener("beforeunload", handleBeforeUnload)
    })

    // Vue Router navigation guard
    if (useRouteGuard) {
        onBeforeRouteLeave(() => {
            if (hasUnsavedChanges.value) {
                const answer = window.confirm(confirmMessage)
                if (!answer) return false
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
