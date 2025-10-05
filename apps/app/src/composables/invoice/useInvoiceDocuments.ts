import { useAuthStore } from "@/stores/auth"
import { useAlert } from "@/composables/utils/useAlert"
import { useI18n } from "vue-i18n"

const normalizeFileName = (filePath?: string | null) => {
    if (!filePath) return ""
    const trimmed = filePath.trim()
    if (!trimmed) return ""
    const parts = trimmed.split(/[/\\]/)
    return parts[parts.length - 1] || trimmed
}

export function useInvoiceDocuments() {
    const authStore = useAuthStore()
    const { errorAlert } = useAlert()
    const { t } = useI18n()

    const buildFileUrl = (filePath?: string | null) => {
        if (!filePath) return null
        const trimmed = filePath.trim()
        if (!trimmed) return null
        return `/api/file?path=${encodeURIComponent(trimmed)}`
    }

    const downloadInvoiceFile = async (filePath?: string | null) => {
        if (!filePath) return
        const url = buildFileUrl(filePath)
        if (!url) return
        try {
            const response = await fetch(url, {
                headers: authStore.getAuthHeaders(),
            })
            if (!response.ok) {
                throw new Error(`HTTP ${response.status}`)
            }
            const blob = await response.blob()
            const objectUrl = URL.createObjectURL(blob)
            const link = document.createElement("a")
            link.href = objectUrl
            link.target = "_blank"
            link.rel = "noopener"
            link.click()
            URL.revokeObjectURL(objectUrl)
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
