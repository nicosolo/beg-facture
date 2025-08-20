import { ref } from "vue"

interface Toast {
    id: string
    message: string
    type: "success" | "error" | "info" | "warning"
    duration?: number
}

const toasts = ref<Toast[]>([])

export function useToast() {
    const showToast = (message: string, type: Toast["type"] = "info", duration = 3000) => {
        const id = Date.now().toString()
        const toast: Toast = { id, message, type, duration }
        
        toasts.value.push(toast)
        
        if (duration > 0) {
            setTimeout(() => {
                removeToast(id)
            }, duration)
        }
        
        // For now, also log to console
        console.log(`[${type.toUpperCase()}]`, message)
    }
    
    const removeToast = (id: string) => {
        const index = toasts.value.findIndex(t => t.id === id)
        if (index > -1) {
            toasts.value.splice(index, 1)
        }
    }
    
    const showSuccess = (message: string, duration?: number) => {
        showToast(message, "success", duration)
    }
    
    const showError = (message: string, duration?: number) => {
        showToast(message, "error", duration)
    }
    
    const showInfo = (message: string, duration?: number) => {
        showToast(message, "info", duration)
    }
    
    const showWarning = (message: string, duration?: number) => {
        showToast(message, "warning", duration)
    }
    
    return {
        toasts,
        showToast,
        showSuccess,
        showError,
        showInfo,
        showWarning,
        removeToast,
    }
}