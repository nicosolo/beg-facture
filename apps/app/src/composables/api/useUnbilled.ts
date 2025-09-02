import { z } from "zod"
import { useGet } from "./useAPI"
import type { UnbilledActivitiesResponse } from "@beg/validations"

// Schema for unbilled activities query parameters
const unbilledQuerySchema = z.object({
    periodStart: z.date().optional(),
    periodEnd: z.date().optional(),
})

// Schema for unbilled activities params
const unbilledParamsSchema = z.object({
    projectId: z.number(),
})

export function useFetchUnbilledActivities() {
    return useGet<
        UnbilledActivitiesResponse,
        {
            params: typeof unbilledParamsSchema
            query: typeof unbilledQuerySchema
        }
    >("unbilled/project/:projectId", {
        params: unbilledParamsSchema,
        query: unbilledQuerySchema,
    })
}
