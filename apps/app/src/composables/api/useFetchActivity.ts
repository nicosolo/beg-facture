import { activityFilterSchema, type ActivityListResponse } from "@beg/validations"
import { useGet } from "./useAPI"

export function useActivityAPI() {
    return useGet<
        ActivityListResponse,
        {
            query: typeof activityFilterSchema
        }
    >("activity", {
        query: activityFilterSchema,
    })
}
