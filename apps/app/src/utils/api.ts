import { useAuthStore } from "../stores/auth"
import { useI18n } from "vue-i18n"

// Base API URL
const API_BASE_URL = "/api"

// Generic API request function with authentication
export async function apiRequest<T>(
    endpoint: string,
    method: "GET" | "POST" | "PUT" | "DELETE" = "GET",
    data?: any
): Promise<T> {
    const authStore = useAuthStore()
    const { t } = useI18n()

    const url = `${API_BASE_URL}${endpoint}`
    const headers: Record<string, string> = {
        "Content-Type": "application/json",
    }

    // Add auth headers if available
    const authHeaders = authStore.getAuthHeaders()
    if (authHeaders.Authorization) {
        headers.Authorization = authHeaders.Authorization
    }

    const options: RequestInit = {
        method,
        headers,
    }

    if (data) {
        options.body = JSON.stringify(data)
    }

    const response = await fetch(url, options)

    // If unauthorized, logout user
    if (response.status === 401) {
        authStore.logout()
        throw new Error(t("auth.sessionExpired"))
    }

    if (!response.ok) {
        const errorData = await response.json().catch(() => ({}))
        throw new Error(errorData.error || t("errors.general"))
    }

    return await response.json()
}
