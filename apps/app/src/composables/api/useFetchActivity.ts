import type { Activity, Page } from "@beg/types"
import { activityFilterSchema, convertActivityFilterToInput } from "@beg/validations"
import { useGet } from "./useAPI"

export function useActivityAPI() {
    return useGet<
        Page<Activity>,
        {
            query: typeof activityFilterSchema
        }
    >("activity", {
        query: activityFilterSchema,
    })
}
