import { ref } from "vue"
import { hc } from "hono/client"
import type { AppType } from "@beg/api"
import { z } from "zod"

export function useAPI<
    TFilter extends z.ZodType<any, any, any>,
    TResponse,
    TFilterInput extends z.infer<TFilter> = z.infer<TFilter>,
>(
    endpoint: string,
    filterSchema: TFilter,
    convertFilterToInput: (data: TFilterInput) => Record<string, any> = (data) =>
        data as unknown as Record<string, any>,
    convertResponseToData: (data: TResponse) => TResponse = (data) => data
) {
    const baseUrl = "/api"
    const loading = ref(false)
    const error = ref<string | null>(null)
    const client = hc<AppType>(baseUrl)
    const data = ref<TResponse | null>(null)

    const get = async (args: TFilterInput) => {
        loading.value = true
        const result = filterSchema.safeParse(convertFilterToInput(args))
        if (!result.success) {
            console.log(result)
            error.value = result.error.message
            return
        }

        const response = await (client as any)[endpoint].$get({
            query: convertFilterToInput(result.data as TFilterInput),
        })

        if (!response.ok) {
            error.value = response.statusText
            loading.value = false
            return
        }

        const json = await response.json()
        console.log(convertResponseToData(json))
        data.value = convertResponseToData(json)
        loading.value = false
    }

    const post = async (args: TFilterInput) => {
        loading.value = true
        const result = filterSchema.safeParse(args)
        if (!result.success) {
            error.value = result.error.message
            return
        }
        const response = await (client as any)[endpoint].$post({
            body: convertFilterToInput(result.data as TFilterInput),
        })

        if (!response.ok) {
            error.value = response.statusText
            loading.value = false
            return
        }
        loading.value = false
    }

    return {
        client,
        loading,
        error,
        data,
        get,
        post,
    }
}
