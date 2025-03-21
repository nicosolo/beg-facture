import { ref } from "vue"
import { hc } from "hono/client"
import type { AppType } from "@beg/api"

export function useAPI() {
    const baseUrl = "/api"
    const client = hc<AppType>(baseUrl)
    const loading = ref(false)
    const error = ref<string | null>(null)

    return {
        client,
        loading,
        error,
        setLoading: (state: boolean) => (loading.value = state),
        setError: (message: string | null) => (error.value = message),
    }
}
