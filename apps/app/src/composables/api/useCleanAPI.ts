import { ref } from "vue"
import { hc } from "hono/client"
import type { ApiRoutes } from "@beg/api"
import { z } from "zod"
import { useAuthStore } from "../../stores/auth"

type InferSchema<T> = T extends z.ZodType<infer U> ? U : never

interface ApiSchemas {
    query?: z.ZodType<any>
    body?: z.ZodType<any>
    params?: z.ZodType<any>
}

export function useAPI<
    TResponse,
    TSchemas extends ApiSchemas = {}
>(
    endpoint: string,
    schemas?: TSchemas
) {
    const baseUrl = "/api"
    const loading = ref(false)
    const error = ref<string | null>(null)
    const data = ref<TResponse | null>(null)
    const auth = useAuthStore()
    const client = hc<ApiRoutes>(baseUrl)

    type QueryType = TSchemas['query'] extends z.ZodType ? InferSchema<TSchemas['query']> : void
    type BodyType = TSchemas['body'] extends z.ZodType ? InferSchema<TSchemas['body']> : void
    type ParamsType = TSchemas['params'] extends z.ZodType ? InferSchema<TSchemas['params']> : void

    const processEndpoint = (params?: ParamsType) => {
        let processedEndpoint = endpoint
        if (params && schemas?.params) {
            const paramsResult = schemas.params.safeParse(params)
            if (!paramsResult.success) {
                throw new Error(paramsResult.error.message)
            }
            for (const [key, value] of Object.entries(paramsResult.data)) {
                processedEndpoint = processedEndpoint.replace(`:${key}`, String(value))
            }
        }
        return processedEndpoint
    }

    const request = async (
        method: 'get' | 'post' | 'put' | 'delete',
        options?: {
            query?: QueryType
            body?: BodyType
            params?: ParamsType
        }
    ) => {
        loading.value = true
        error.value = null

        try {
            // Validate inputs
            const validatedQuery = options?.query && schemas?.query 
                ? schemas.query.parse(options.query) 
                : undefined
            
            const validatedBody = options?.body && schemas?.body 
                ? schemas.body.parse(options.body) 
                : undefined

            const processedEndpoint = processEndpoint(options?.params)

            // Build request
            const requestConfig: any = {
                headers: auth.getAuthHeaders()
            }

            if (validatedQuery) {
                requestConfig.query = validatedQuery
            }

            const response = await (client as any)[processedEndpoint][`$${method}`](
                method === 'get' ? requestConfig : { ...requestConfig, json: validatedBody }
            )

            if (!response.ok) {
                throw new Error(response.statusText)
            }

            const result = await response.json()
            data.value = result as TResponse
            return result as TResponse
        } catch (e) {
            error.value = e instanceof Error ? e.message : 'Unknown error'
            return null
        } finally {
            loading.value = false
        }
    }

    const get = (options?: { query?: QueryType; params?: ParamsType }) => 
        request('get', options)

    const post = (options?: { body?: BodyType; params?: ParamsType }) => 
        request('post', options)

    const put = (options?: { body?: BodyType; params?: ParamsType }) => 
        request('put', options)

    const del = (options?: { params?: ParamsType }) => 
        request('delete', options)

    return {
        loading,
        error,
        data,
        get,
        post,
        put,
        delete: del
    }
}

// Usage examples:
// const useUser = () => useAPI<User>('/users/:id', {
//     params: z.object({ id: z.string() })
// })
// 
// const useUsers = () => useAPI<User[]>('/users', {
//     query: z.object({ 
//         active: z.boolean().optional(),
//         page: z.number().optional() 
//     })
// })
// 
// const useCreateUser = () => useAPI<User>('/users', {
//     body: z.object({
//         name: z.string(),
//         email: z.string().email()
//     })
// })

// Then use it:
// const { get, loading, data } = useUser()
// await get({ params: { id: '123' } }) // TypeScript knows params needs { id: string }
// 
// const { get: getUsers } = useUsers()
// await getUsers({ query: { active: true } }) // TypeScript knows query shape
// 
// const { post } = useCreateUser()
// await post({ body: { name: 'John', email: 'john@example.com' } }) // TypeScript knows body shape