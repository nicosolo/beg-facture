import type { Activity, Page, Project } from "@beg/types"
import { convertProjectFilterToInput, projectFilterSchema } from "@beg/validations"
import { useAPI } from "./useAPI"

export function useFetchProject() {
    return useAPI<typeof projectFilterSchema, Page<Project>>(
        "project",
        projectFilterSchema,
        convertProjectFilterToInput,
        (data) => ({
            ...data,
            data: data.data.map((item: Project) => ({
                ...item,
                startDate: new Date(item.startDate),
                createdAt: new Date(item.createdAt),
                updatedAt: new Date(item.updatedAt),
            })),
        })
    )
}
