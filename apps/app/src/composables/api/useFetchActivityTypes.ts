import type { ActivityType } from "@beg/types"
import { activityFilterSchema } from "@beg/validations"
import { useAPI } from "./useAPI"
import { z } from "zod"

// For now, we'll use a simple schema for activity types
// TODO: Update when proper activity type schema is available in validations
const activityTypeSchema = z.object({
    id: z.number(),
    code: z.string(),
    name: z.string(),
    billable: z.boolean(),
})

const activityTypesResponseSchema = z.array(activityTypeSchema)

export function useFetchActivityTypes() {
    // TODO: Update endpoint when activity types endpoint is available
    return useAPI<z.ZodType<any>, any[]>(
        "activity/types",
        z.object({}),
        (data) => data,
        (data) => data
    )
}