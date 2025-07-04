import { ref } from "vue"
import { hc } from "hono/client"
import type { ApiRoutes } from "@beg/api"
import { z } from "zod"
import { useAuthStore } from "../../stores/auth"

export function useAPI<
    TFilter extends z.ZodType<any, any, any>,
    TResponse,
    TFilterInput extends z.infer<TFilter> = z.infer<TFilter>,
>(
    endpoint: string,
    filterSchema: TFilter,
    convertToInput: (data: TFilterInput) => Record<string, any> = (data) =>
        data as unknown as Record<string, any>,
    convertToData: (data: TResponse) => TResponse = (data) => data
) {
    const baseUrl = "/api"
    const loading = ref(false)
    const error = ref<string | null>(null)
    const auth = useAuthStore()
    const client = hc<ApiRoutes>(baseUrl)

    const data = ref<TResponse | null>(null)
    const get = async (args: TFilterInput) => {
        const result = filterSchema.safeParse(convertToInput(args))
        if (!result.success) {
            console.error(result)
            error.value = result.error.message
            return
        }
        for (const key in result.data) {
            if (endpoint.includes(`:${key}`)) {
                endpoint = endpoint.replace(`:${key}`, result.data[key])
                delete result.data[key]
            }
        }
        const response = await (client as any)[endpoint].$get(
            {
                query: convertToInput(result.data as TFilterInput),
            },
            {
                headers: auth.getAuthHeaders(),
            }
        )

        if (!response.ok) {
            error.value = response.statusText
            loading.value = false
            return
        }

        const json = await response.json()
        if (convertToData) {
            data.value = convertToData(json)
        } else {
            data.value = json
        }
        loading.value = false
    }

    const post = async (args: TFilterInput) => {
        loading.value = true
        const result = filterSchema.safeParse(args)
        if (!result.success) {
            error.value = result.error.message
            return
        }
        for (const key in result.data) {
            if (endpoint.includes(`:${key}`)) {
                endpoint = endpoint.replace(`:${key}`, result.data[key])
                delete result.data[key]
            }
        }
        const response = await (client as any)[endpoint].$post(
            {
                json: convertToInput(result.data as TFilterInput),
            },
            {
                headers: auth.getAuthHeaders(),
            }
        )

        if (!response.ok) {
            error.value = response.statusText
            loading.value = false
            return
        }

        const json = await response.json()
        if (convertToData) {
            data.value = convertToData(json)
        } else {
            data.value = json
        }
        loading.value = false
    }

    return {
        loading,
        error,
        data,
        get,
        post,
    }
}
