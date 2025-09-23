import {
    idParamSchema,
    rateClassCreateSchema,
    rateClassFilterSchema,
    rateClassUpdateSchema,
    type RateClassSchema,
} from "@beg/validations"
import { useGet, usePost, usePut, useDelete } from "./useAPI"

export function useFetchRate() {
    return useGet<RateClassSchema>("rate/:id", {
        params: idParamSchema,
    })
}

export function useFetchRates() {
    return useGet<
        RateClassSchema[],
        {
            query: typeof rateClassFilterSchema
        }
    >("rate", {
        query: rateClassFilterSchema,
    })
}

export function useCreateRate() {
    return usePost<
        RateClassSchema,
        {
            body: typeof rateClassCreateSchema
        }
    >("rate", {
        body: rateClassCreateSchema,
    })
}

export function useUpdateRate() {
    return usePut<
        RateClassSchema,
        {
            params: typeof idParamSchema
            body: typeof rateClassUpdateSchema
        }
    >("rate/:id", {
        params: idParamSchema,
        body: rateClassUpdateSchema,
    })
}

export function useDeleteRate() {
    return useDelete<
        { message: string },
        {
            params: typeof idParamSchema
        }
    >("rate/:id", {
        params: idParamSchema,
    })
}
