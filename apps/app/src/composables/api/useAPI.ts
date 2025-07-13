import { ref } from "vue"
import { hc } from "hono/client"
import type { ApiRoutes } from "@beg/api"
import { z } from "zod"
import { useAuthStore } from "../../stores/auth"
import { parseApiError } from "@/utils/api-error"

interface ApiSchemas {
    query?: z.ZodType<any>
    body?: z.ZodType<any>
    params?: z.ZodType<any>
}

const createRequest = () => {
    const baseUrl = "/api"

    const client = hc<ApiRoutes>(baseUrl)

    return async (
        method: "get" | "post" | "put" | "delete",
        endpoint: string,
        schemas?: ApiSchemas,
        options?: {
            query?: any
            body?: any
            params?: any
        }
    ) => {
        const auth = useAuthStore()

        // Validate inputs
        const validatedQuery =
            options?.query && schemas?.query ? schemas.query.parse(options.query) : undefined

        const validatedBody =
            options?.body && schemas?.body ? schemas.body.parse(options.body) : undefined
        let processedEndpoint = endpoint
        if (options?.params && schemas?.params) {
            const paramsResult = schemas.params.safeParse(options.params)
            if (!paramsResult.success) {
                throw new Error(paramsResult.error.message)
            }
            for (const [key, value] of Object.entries(paramsResult.data)) {
                processedEndpoint = processedEndpoint.replace(`:${key}`, String(value))
            }
        }

        // Build request
        const requestConfig: any = {
            headers: auth.getAuthHeaders(),
        }

        const response = await (client as any)[processedEndpoint][`$${method}`](
            {
                ...(validatedBody ? { json: validatedBody } : {}),
                ...(validatedQuery ? { query: validatedQuery } : {}),
            },
            requestConfig
        )

        if (!response.ok) {
            // Parse the error using our standardized error handler
            const apiError = await parseApiError(response)
            
            // For auth errors, clear the auth state
            if (apiError.isAuthError()) {
                const authStore = useAuthStore()
                authStore.logout()
            }
            
            throw apiError
        }

        return await response.json()
    }
}

export function useGet<
    TResponse,
    TSchemas extends {
        query?: z.ZodType<any>
        params?: z.ZodType<any>
    } = {},
>(
    endpoint: string,
    schemas?: {
        query?: TSchemas["query"]
        params?: TSchemas["params"]
    }
) {
    const loading = ref(false)
    const error = ref<string | null>(null)
    const data = ref<TResponse | null>(null)
    const request = createRequest()

    type QueryType = TSchemas["query"] extends z.ZodType<any> ? z.input<TSchemas["query"]> : void
    type ParamsType = TSchemas["params"] extends z.ZodType<any> ? z.input<TSchemas["params"]> : void

    type GetOptions = {} & (QueryType extends void ? {} : { query?: QueryType }) &
        (ParamsType extends void ? {} : { params?: ParamsType })

    const get = async (options?: GetOptions) => {
        loading.value = true
        error.value = null

        try {
            const result = await request("get", endpoint, schemas, options)
            data.value = result as TResponse
            return result as TResponse
        } catch (e) {
            error.value = e instanceof Error ? e.message : "Unknown error"
            throw e
        } finally {
            loading.value = false
        }
    }

    return {
        loading,
        error,
        data,
        get,
    }
}

export function usePost<
    TResponse,
    TSchemas extends {
        body?: z.ZodType<any>
        params?: z.ZodType<any>
    } = {},
>(
    endpoint: string,
    schemas?: {
        body?: TSchemas["body"]
        params?: TSchemas["params"]
    }
) {
    const loading = ref(false)
    const error = ref<string | null>(null)
    const data = ref<TResponse | null>(null)
    const request = createRequest()

    type BodyType = TSchemas["body"] extends z.ZodType<any> ? z.input<TSchemas["body"]> : void
    type ParamsType = TSchemas["params"] extends z.ZodType<any> ? z.input<TSchemas["params"]> : void

    type PostOptions = {} & (BodyType extends void ? {} : { body?: BodyType }) &
        (ParamsType extends void ? {} : { params?: ParamsType })

    const post = async (options?: PostOptions) => {
        loading.value = true
        error.value = null

        try {
            const result = await request("post", endpoint, schemas, options)
            data.value = result as TResponse
            return result as TResponse
        } catch (e) {
            error.value = e instanceof Error ? e.message : "Unknown error"
            throw e
        } finally {
            loading.value = false
        }
    }

    return {
        loading,
        error,
        data,
        post,
    }
}

export function usePut<
    TResponse,
    TSchemas extends {
        body?: z.ZodType<any>
        params?: z.ZodType<any>
    } = {},
>(
    endpoint: string,
    schemas?: {
        body?: TSchemas["body"]
        params?: TSchemas["params"]
    }
) {
    const loading = ref(false)
    const error = ref<string | null>(null)
    const data = ref<TResponse | null>(null)
    const request = createRequest()

    type BodyType = TSchemas["body"] extends z.ZodType<any> ? z.input<TSchemas["body"]> : void
    type ParamsType = TSchemas["params"] extends z.ZodType<any> ? z.input<TSchemas["params"]> : void

    type PutOptions = {} & (BodyType extends void ? {} : { body?: BodyType }) &
        (ParamsType extends void ? {} : { params?: ParamsType })

    const put = async (options?: PutOptions) => {
        loading.value = true
        error.value = null

        try {
            const result = await request("put", endpoint, schemas, options)
            data.value = result as TResponse
            return result as TResponse
        } catch (e) {
            error.value = e instanceof Error ? e.message : "Unknown error"
            throw e
        } finally {
            loading.value = false
        }
    }

    return {
        loading,
        error,
        data,
        put,
    }
}

export function useDelete<
    TResponse,
    TSchemas extends {
        params?: z.ZodType<any>
    } = {},
>(
    endpoint: string,
    schemas?: {
        params?: TSchemas["params"]
    }
) {
    const loading = ref(false)
    const error = ref<string | null>(null)
    const data = ref<TResponse | null>(null)
    const request = createRequest()

    type ParamsType = TSchemas["params"] extends z.ZodType<any> ? z.input<TSchemas["params"]> : void

    const del = async (options?: ParamsType extends void ? {} : { params?: ParamsType }) => {
        loading.value = true
        error.value = null

        try {
            const result = await request("delete", endpoint, schemas, options)
            data.value = result as TResponse
            return result as TResponse
        } catch (e) {
            error.value = e instanceof Error ? e.message : "Unknown error"
            throw new Error(error.value)
        } finally {
            loading.value = false
        }
    }

    return {
        loading,
        error,
        data,
        delete: del,
    }
}
