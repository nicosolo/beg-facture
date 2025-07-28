import { ref, readonly } from "vue"

export interface Alert {
    id: string
    message: string
    type: "success" | "error" | "info" | "warning"
    visible: boolean
}

const alerts = ref<Alert[]>([])
const MAX_ALERTS = 5

export const useAlert = () => {
    const addAlert = (message: string, type: Alert["type"] = "success", duration = 3000) => {
        const id = Date.now().toString()
        const alert: Alert = {
            id,
            message,
            type,
            visible: true,
        }

        // Remove oldest alert if we're at the limit
        if (alerts.value.length >= MAX_ALERTS) {
            alerts.value.shift()
        }

        alerts.value.push(alert)

        if (duration > 0) {
            setTimeout(() => {
                removeAlert(id)
            }, duration)
        }

        return id
    }

    const removeAlert = (id: string) => {
        const index = alerts.value.findIndex((alert) => alert.id === id)
        if (index > -1) {
            alerts.value.splice(index, 1)
        }
    }

    const successAlert = (message: string, duration?: number) => {
        return addAlert(message, "success", duration)
    }

    const errorAlert = (message: string, duration?: number) => {
        return addAlert(message, "error", duration)
    }

    const infoAlert = (message: string, duration?: number) => {
        return addAlert(message, "info", duration)
    }

    const warningAlert = (message: string, duration?: number) => {
        return addAlert(message, "warning", duration)
    }

    return {
        alerts: readonly(alerts),
        addAlert,
        removeAlert,
        successAlert,
        errorAlert,
        infoAlert,
        warningAlert,
    }
}