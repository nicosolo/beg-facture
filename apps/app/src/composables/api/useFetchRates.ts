import { rateClassFilterSchema, type RateClassSchema } from "@beg/validations"
import { useGet } from "./useAPI"

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
