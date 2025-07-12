import { rateClassSchema } from "@beg/validations"
import { useAPI } from "./useAPI"
import { z } from "zod"

const ratesResponseSchema = z.array(rateClassSchema)

export function useFetchRates() {
    return useAPI<z.ZodType<any>, any[]>(
        "rate",
        z.object({}),
        (data) => data,
        (data) => data
    )
}