import { z } from "zod"
import type { RateClassSchema } from "@beg/validations"
import { useGet } from "./useAPI"

// Schema for rate class filter
const rateClassFilterSchema = z.object({
    year: z.number().optional(),
})

// Schema for single rate class params
const rateClassParamsSchema = z.object({
    classType: z.string(),
    year: z.number(),
})

export function useFetchRateClasses() {
    return useGet<
        RateClassSchema[],
        {
            query: typeof rateClassFilterSchema
        }
    >("rate", {
        query: rateClassFilterSchema,
    })
}

export function useFetchRateClass() {
    return useGet<
        RateClassSchema,
        {
            params: typeof rateClassParamsSchema
        }
    >("rate/:classType/:year", {
        params: rateClassParamsSchema,
    })
}
