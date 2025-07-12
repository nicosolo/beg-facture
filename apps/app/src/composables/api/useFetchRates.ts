import { rateClassSchema } from "@beg/validations"
import { useGet } from "./useAPI"
import { z } from "zod"

const ratesResponseSchema = z.array(rateClassSchema)

export function useFetchRates() {
    return useGet<any[]>("rate")
}
