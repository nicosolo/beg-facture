import { useAuthStore } from "@/stores/auth"
import { useAppSettingsStore } from "@/stores/appSettings"
import { useAlert } from "@/composables/utils/useAlert"
import { useI18n } from "vue-i18n"
import { useTauri } from "@/composables/useTauri"

const normalizeFileName = (filePath?: string | null) => {
    if (!filePath) return ""
    const trimmed = filePath.trim()
    if (!trimmed) return ""
    const parts = trimmed.split(/[/\\]/)
    return parts[parts.length - 1] || trimmed
}

export function useInvoiceDocuments() {
    const authStore = useAuthStore()
    const appSettingsStore = useAppSettingsStore()
    const { errorAlert } = useAlert()
    const { t } = useI18n()
    const { isTauri, openFile } = useTauri()

    const buildFileUrl = (invoiceId: number, filePath?: string | null) => {
        if (!filePath) return null
        const trimmed = filePath.trim()
        if (!trimmed) return null
        return `/api/invoice/${invoiceId}/files?path=${encodeURIComponent(trimmed)}`
    }

    const downloadInvoiceFile = async (
        invoiceId: number,
        filePath?: string | null,
        mode: "download" | "open" = "open"
    ) => {
        if (!filePath) return

        // In Tauri, open file directly from host machine path
        if (isTauri.value) {
            const absolutePath = appSettingsStore.getAbsolutePath(filePath.replace("/mandats", ""))
            await openFile(absolutePath)
            return
        }

        const url = buildFileUrl(invoiceId, filePath)
        if (!url) return
        const fileName = normalizeFileName(filePath)
        try {
            const response = await fetch(url, {
                headers: authStore.getAuthHeaders(),
            })
            if (!response.ok) {
                throw new Error(`HTTP ${response.status}`)
            }
            const blob = await response.blob()
            const objectUrl = URL.createObjectURL(blob)

            if (mode === "open") {
                window.open(objectUrl, "_blank")
            } else {
                const link = document.createElement("a")
                link.href = objectUrl
                link.download = fileName
                link.click()
            }

            setTimeout(() => URL.revokeObjectURL(objectUrl), 1000)
        } catch (error) {
            console.error("Failed to download invoice document", error)
            errorAlert(t("common.errorOccurred"))
        }
    }

    const extractFileName = (filePath?: string | null) => normalizeFileName(filePath)

    return {
        buildFileUrl,
        downloadInvoiceFile,
        extractFileName,
    }
}
