import type { Activity, Page } from "@beg/types"
import { activityFilterSchema, convertActivityFilterToInput } from "@beg/validations"
import { useAPI } from "./useAPI"

export function useActivityAPI() {
    return useAPI<typeof activityFilterSchema, Page<Activity>>(
        "activity",
        activityFilterSchema,
        convertActivityFilterToInput,
        (data) => ({
            ...data,
            data: data.data.map((item: Activity) => ({
                ...item,
                date: new Date(item.date),
                startTime: new Date(item.startTime),
                endTime: new Date(item.endTime),
                validationDateTime: new Date(item.validationDateTime),
                createdAt: new Date(item.createdAt),
                updatedAt: new Date(item.updatedAt),
            })),
        })
    )
}
